//
//  TISOLib
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ImageFileHandler.pas,v 1.4 2004/06/15 14:45:31 muetze1 Exp $
//

Unit ImageFileHandler;

Interface

Uses
  ISOException,
  Classes;

Type
  EISOImageHandlerException = Class(EISOLibException);

    // Yellow Book Format
    //
    //   ybfAuto   = auto detect
    //   ybfMode1  = 2048 byte user data
    //   ybfMode2  = 2336 byte user data
    //
  TISOYellowBookFormat = (ybfAuto, ybfMode1, ybfMode2);

    // Image Format
    //
    //   ifCompleteSectors  = with SYNC, Header, etc
    //   ifOnlyData         = only the user data
    //
  TISOImageFormat = (ifAuto, ifCompleteSectors, ifOnlyData);

  TImageFileHandler = Class
  Private
    fYellowBookFormat : TISOYellowBookFormat;
    fImageFormat      : TISOImageFormat;

    fImageOffset      : Cardinal; // e.g. used by Nero Images
    fFileStream       : TFileStream;

    fCurrentSector    : Cardinal;

  Protected
    Procedure    DetectImageType; Virtual;
    Function     CalcSectorOffset(Const ASector : Cardinal): Integer; Virtual;
    Function     CalcUserDataOffset: Integer; Virtual;
    Function     GetSectorDataSize: Cardinal; Virtual;

  Public
    Constructor  Create(Const AFileName : String; Const AImageFormat : TISOImageFormat); Overload; Virtual;
    Constructor  Create(Const ANewFileName : String; Const AYellowBookFormat : TISOYellowBookFormat; Const AImageFormat : TISOImageFormat); Overload; Virtual;
    Destructor   Destroy; Override;

    Function     SeekSector(Const ASector : Cardinal; Const AGrow : Boolean = True): Boolean; Virtual;

    Function     ReadSector_Data(Var ABuffer; Const ABufferSize : Integer = -1): Boolean; Virtual;
    Function     ReadSector_Raw (Var ABuffer; Const ABufferSize : Integer = -1): Boolean; Virtual;

  Published
    Property     YellowBookFormat : TISOYellowBookFormat   Read  fYellowBookFormat;
    Property     ImageFormat      : TISOImageFormat        Read  fImageFormat;
    Property     ImageOffset      : Cardinal               Read  fImageOffset;
    Property     SectorDataSize   : Cardinal               Read  GetSectorDataSize;
    Property     CurrentSector    : Cardinal               Read  fCurrentSector;

    Property     Stream           : TFileStream            Read  fFileStream;           
  End;


Implementation

Uses
  SysUtils; // for FileExists()

{ TImageFileHandler }

Constructor TImageFileHandler.Create(Const AFileName: String; Const AImageFormat: TISOImageFormat);
Begin
  Inherited Create;

  If ( Not FileExists(AFileName) ) Then
    Raise EISOImageHandlerException.Create('image file not found');

  fFileStream := TFileStream.Create(AFileName, fmOpenReadWrite Or fmShareDenyNone);

  DetectImageType;

  SeekSector(fCurrentSector);
End;

Constructor TImageFileHandler.Create(Const ANewFileName : String; Const AYellowBookFormat: TISOYellowBookFormat; Const AImageFormat: TISOImageFormat);
Begin
  Inherited Create;

  If ( AYellowBookFormat = ybfAuto ) Then
    Raise EISOImageHandlerException.Create('yellow book format has to be defined!');

  If ( AImageFormat = ifAuto ) Then
    Raise EISOImageHandlerException.Create('image format has to be defined!');

  fYellowBookFormat  := AYellowBookFormat;
  fImageFormat       := AImageFormat;
  fImageOffset       := 0;

  fFileStream := TFileStream.Create(ANewFileName, fmCreate Or fmShareDenyNone);

  SeekSector(fCurrentSector);
End;

Destructor TImageFileHandler.Destroy;
Begin
  If ( Assigned(fFileStream) ) Then
    FreeAndNil(fFileStream);

  Inherited;
End;

Function TImageFileHandler.CalcUserDataOffset: Integer;
Begin
  Case fImageFormat Of
    ifCompleteSectors  : Result := 16; // 12 bytes SYNC, 4 byte Header
    ifOnlyData         : Result := 0;
    ifAuto             : Raise EISOImageHandlerException.Create('can not calculate sector offset with auto values!');
  Else
    Raise EISOImageHandlerException.Create('TImageFileHandler.CalcUserDataOffset(): Implementation error!');
  End;
End;

Function TImageFileHandler.CalcSectorOffset(Const ASector: Cardinal): Integer;
Begin
  Case fImageFormat Of
    ifCompleteSectors : Result := fImageOffset + ASector * 2352;
    ifOnlyData        :
      Begin
        Case fYellowBookFormat Of
          ybfMode1 : Result := fImageOffset + ASector * 2048;
          ybfMode2 : Result := fImageOffset + ASector * 2336;
          ybfAuto  : Raise EISOImageHandlerException.Create('can not calculate sector with auto settings');
        Else
          Raise EISOImageHandlerException.Create('TImageFileHandler.CalcSectorOffset(): Implementation error!');
        End;
      End;
    ifAuto : Raise EISOImageHandlerException.Create('can not calculate sector with auto settings');
  Else
    Raise EISOImageHandlerException.Create('TImageFileHandler.CalcSectorOffset(): Implementation error!');
  End;
End;

Procedure TImageFileHandler.DetectImageType;
Type
  TCheckBuf = Packed Record
    DeskID : Byte;
    StdID  : Array[0..4] Of Char;
  End;
  TRawCheckBuf = Packed Record
    SYNC   : Array[0..11] of Byte;
    Header_SectMin,
    Header_SectSec,
    Header_SectNo,
    Header_Mode    : Byte;
    Deskriptor : TCheckBuf;
  End;
Var
  Buff    : TCheckBuf;
  RawBuff : TRawCheckBuf;
  Tries   : Boolean;
Begin
  fYellowBookFormat := ybfAuto;
  fImageFormat      := ifAuto;
  fImageOffset      := 0;

  If ( Assigned(fFileStream) ) And ( fFileStream.Size > 16*2048 ) Then
  Begin
    For Tries := False To True Do
    Begin
      If ( Tries ) Then // ok, 2nd run, last try: nero .nrg image file
        fImageOffset := 307200;

      fFileStream.Position := fImageOffset + 16 * 2048;
      fFileStream.ReadBuffer(Buff, SizeOf(Buff));

      If ( String(Buff.StdID) = 'CD001' ) Then
      Begin
        fImageFormat      := ifOnlyData;
        fYellowBookFormat := ybfMode1;

        Break;
      End;

      fFileStream.Position := fImageOffset + 16 * 2336;
      fFileStream.ReadBuffer(Buff, SizeOf(Buff));

      If ( String(Buff.StdID) = 'CD001' ) Then
      Begin
        fImageFormat      := ifOnlyData;
        fYellowBookFormat := ybfMode2;

        Break;
      End;

      fFileStream.Position := fImageOffset + 16 * 2352;
      fFileStream.ReadBuffer(RawBuff, SizeOf(RawBuff));

      If ( String(RawBuff.Deskriptor.StdID) = 'CD001' ) Then
      Begin
        fImageFormat := ifCompleteSectors;

        If ( RawBuff.Header_Mode = 1 ) Then
          fYellowBookFormat := ybfMode1
        Else If ( RawBuff.Header_Mode = 2 ) Then
          fYellowBookFormat := ybfMode2
        Else
          Raise EISOImageHandlerException.Create('unkown Yellow Book mode!');

        Break;
      End;
    End;
  End;

  If ( fImageFormat = ifAuto ) Or ( fYellowBookFormat = ybfAuto ) Then
    Raise EISOImageHandlerException.Create('unkown image format!');
End;

Function TImageFileHandler.SeekSector(Const ASector: Cardinal; Const AGrow: Boolean): Boolean;
Var
  lFPos : Integer;
Begin
  Result := False;

  If ( Assigned(fFileStream) ) Then
  Begin
    lFPos := CalcSectorOffset(ASector);

    If ( (lFPos+2048) > fFileStream.Size ) And ( Not AGrow ) Then
      Exit;

    fFileStream.Position := lFPos;

    fCurrentSector := ASector;
  End;
End;

Function TImageFileHandler.ReadSector_Data(Var ABuffer; Const ABufferSize : Integer = -1): Boolean;
Var
  lDataOffset : Integer;
Begin
  Result := False;

  If ( Assigned(fFileStream) ) Then
  Begin
    lDataOffset := CalcUserDataOffset;

    fFileStream.Seek(lDataOffset, soFromCurrent);

    If ( ABufferSize > -1 ) And ( Cardinal(ABufferSize) < GetSectorDataSize ) Then
      Raise EISOImageHandlerException.Create('TImageFileHandler.ReadSector_Data(): buffer overflow protection'); 

    fFileStream.ReadBuffer(ABuffer, GetSectorDataSize);

    SeekSector(fCurrentSector+1);

    Result := True;
  End;
End;

Function TImageFileHandler.ReadSector_Raw(Var ABuffer; Const ABufferSize : Integer = -1): Boolean;
Begin
  Result := False;

  If ( Assigned(fFileStream) ) Then
  Begin
    If ( ABufferSize > -1 ) And ( ABufferSize < 2352 ) Then
      Raise EISOImageHandlerException.Create('TImageFileHandler.ReadSector_Raw(): buffer overflow protection'); 

    fFileStream.ReadBuffer(ABuffer, 2352);

    Result := True;
  End;
End;

Function TImageFileHandler.GetSectorDataSize: Cardinal;
Begin
  Case fYellowBookFormat Of
    ybfMode1 : Result := 2048;
    ybfMode2 : Result := 2336;
  Else
    Raise EISOImageHandlerException.Create('can not figure out sector data size on auto type');
  End;
End;

End.

//  Log List
//
// $Log: ImageFileHandler.pas,v $
// Revision 1.4  2004/06/15 14:45:31  muetze1
// removed warnings and old comments
//
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//
//
