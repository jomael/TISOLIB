//
//  TISOImage
//
//  refer to http://isolib.xenome.info/
//

//
//  Bei dem Nero Image File .NRG müsste man mal schauen, wo er denn nun was für
//  komische Zusatzdaten hinschreibt...
//

//
// $Id: ISOImage.pas,v 1.5 2004/06/15 15:33:29 muetze1 Exp $
//

Unit ISOImage;

Interface

Uses
  ISOStructs,
  ISOException,
  ImageFileHandler,
  DataTree,
  VolumeDescriptors,
  SysUtils,           // for Exception
  ComCtrls,           // for TTreeView
  Classes;            // for TStrings

Type
  TISOImage = Class
  Private
      // Log Stream
    fLog         : TStrings;
    fFileName    : String;

      // debug functions:
    Procedure   DumpData(Const ALength : Cardinal);

  Protected
    fImage         : TImageFileHandler;
    fBRClass       : TBootRecordVolumeDescriptor;
    fPVDClass      : TPrimaryVolumeDescriptor;
    fSVDClass      : TSupplementaryVolumeDescriptor;
    fTree          : TDataTree;

    Procedure   Log(Const AFunction, AMessage : String);

    Function    ParseDirectory(Const AUsePrimaryVD : Boolean = True): Boolean;
    Function    ParseDirectorySub(AParentDir : TDirectoryEntry; Const AFileName : String; Var ADirectoryEntry : PDirectoryRecord): Boolean;

  Public
    Constructor Create(Const AFileName : String; ALog : TStrings = Nil); Virtual;
    Destructor  Destroy; Override;

    Function    OpenImage: Boolean;
    Function    ParsePathTable(ATreeView : TTreeView = Nil): Boolean;
    Function    ExtractFile(Const AFileEntry: TFileEntry; Const AFileName : String): Boolean;
    Function    CloseImage: Boolean;

  Published
    Property    Filename    : String       Read  fFileName;
    Property    Structure   : TDataTree    Read  fTree;
  End;

Implementation

Uses
  ISOToolBox,  // IntToMB()
  Math;        // for Min()

Type
  PByte = ^Byte;

Const
  UNIT_ID : String = '$Id: ISOImage.pas,v 1.5 2004/06/15 15:33:29 muetze1 Exp $';

{ TISOLib }

Constructor TISOImage.Create(const AFileName: String; ALog: TStrings);
Begin
  Inherited Create;

  fLog           := ALog;
  fFileName      := AFileName;
  fImage         := Nil;
  fPVDClass      := Nil;
  fSVDClass      := Nil;
  fBRClass       := Nil;
  fTree          := TDataTree.Create;
End;

Destructor TISOImage.Destroy;
Begin
  If ( Assigned(fTree) ) Then
    FreeAndNil(fTree);

  If ( Assigned(fImage) ) Then
    FreeAndNil(fImage);

  If ( Assigned(fPVDClass) ) Then
    FreeAndNil(fPVDClass);

  If ( Assigned(fSVDClass) ) Then
    FreeAndNil(fSVDClass);
     
  If ( Assigned(fBRClass) ) Then
    FreeAndNil(fBRClass);

  Inherited;
End;

Function TISOImage.CloseImage: Boolean;
Begin
  fFileName := '';

  If Assigned(fImage) Then
    FreeAndNil(fImage);
  If Assigned(fPVDClass) Then
    FreeAndNil(fPVDClass);
  If Assigned(fSVDClass) Then
    FreeAndNil(fSVDClass);
  If Assigned(fBRClass) Then
    FreeAndNil(fBRClass);
  If Assigned(fTree) Then
    FreeAndNil(fTree);

  Result := True;
End;

Procedure TISOImage.DumpData(const ALength: Cardinal);
Var
  OrgPtr,
  Buffer   : PByte;
  Row      : Cardinal;
  Col      : Word;
  CharStr,
  DumpStr  : String;
Begin
  GetMem(Buffer, ALength);
  OrgPtr := Buffer;
  Try
    fImage.Stream.ReadBuffer(Buffer^, ALength);

    For Row := 0 To ((ALength-1) Div 16) Do
    Begin
      DumpStr := IntToHex(Cardinal(fImage.Stream.Position) - ALength + Row*16, 8) + 'h | ';
      CharStr := '';
      For Col := 0 To Min(16, ALength - (Row+1)*16) Do
      Begin
        DumpStr := DumpStr + IntToHex(Buffer^, 2) + ' ';
        If ( Buffer^ > 32 ) Then
          CharStr := CharStr + Chr(Buffer^)
        Else
          CharStr := CharStr + ' ';
        Inc(Buffer);
      End;
      DumpStr := DumpStr + StringOfChar(' ', 61-Length(DumpStr)) + '| ' + CharStr;
      Log('Dump', DumpStr);
    End;
  Finally
    FreeMem(OrgPtr, ALength);
  End;
End;

Function TISOImage.ExtractFile(Const AFileEntry: TFileEntry; Const AFileName: String): Boolean;
Var
  lFStream : TFileStream;
  lFSize   : Int64;
  lBuffer  : Pointer;
Begin
  Result := False;
  
  If Assigned(AFileEntry) Then
  Begin
    fImage.SeekSector(AFileEntry.ISOData.LocationOfExtent.LittleEndian);

    lFStream := TFileStream.Create(AFileName, fmCreate);
    lFSize   := AFileEntry.ISOData.DataLength.LittleEndian;
    GetMem(lBuffer, fImage.SectorDataSize);
    Try
      While ( lFSize > 0 ) Do
      Begin
        fImage.ReadSector_Data(lBuffer^, fImage.SectorDataSize);
        lFStream.WriteBuffer(lBuffer^, Min(lFSize, fImage.SectorDataSize));
        Dec(lFSize, fImage.SectorDataSize);
      End;

      Result := True;
    Finally
      lFStream.Free;
      FreeMem(lBuffer, fImage.SectorDataSize);
    End;
  End;
End;

Procedure TISOImage.Log(Const AFunction, AMessage: String);
Begin
  If ( Assigned(fLog) ) Then
    fLog.Add(AFunction + '(): ' + AMessage);
End;

Function TISOImage.OpenImage: Boolean;
Var
  VD : TVolumeDescriptor;
Begin
  Result := False;

  If ( FileExists(fFileName) ) Then
  Begin
    fImage := TImageFileHandler.Create(fFileName, ifAuto);

    Log('OpenImage', 'file "' + fFileName + '" opened...');

      // die Sektor 0 bis Sektor 15 enthalten nur 0-Sektoren
    fImage.SeekSector(16);

    If ( fImage.ImageFormat = ifCompleteSectors ) Then
      Log('OpenImage', 'image contains RAW data')
    Else If ( fImage.ImageFormat = ifOnlyData ) Then
      Log('OpenImage', 'image contains sector data');

    If ( fImage.YellowBookFormat = ybfMode1 ) Then
      Log('OpenImage', 'image contains yellow book mode 1 data')
    Else If ( fImage.YellowBookFormat = ybfMode2 ) Then
      Log('OpenImage', 'image contains yellow book mode 2 data');

    Log('OpenImage', 'user data sector size is ' + IntToStr(fImage.SectorDataSize) + ' bytes');
    Log('OpenImage', 'image data offset in image file is ' + IntToStr(fImage.ImageOffset) + ' bytes');

    If ( fImage.SectorDataSize <> 2048 ) Then
    Begin
      Log('OpenImage', 'sorry, but sector size other than 2048 bytes are not yet supported...');
      Exit;
    End;

    Repeat
      fImage.ReadSector_Data(VD, SizeOf(TVolumeDescriptor));

      Case Byte(VD.DescriptorType) Of
        vdtBR  : Begin
                   Log('OpenImage', 'Boot Record Volume Descriptor found'); // Boot Record VD

                   If ( Assigned(fBRClass) ) Then // newer PVD
                     fBRClass.Free;
                   fBRClass := TBootRecordVolumeDescriptor.Create(VD);
                   // fBRClass.Dump(fLog);
                 End;
        vdtPVD : Begin
                   Log('OpenImage', 'Primary Volume Descriptor found');

                   If ( Assigned(fPVDClass) ) Then // newer PVD
                     fPVDClass.Free;
                   fPVDClass := TPrimaryVolumeDescriptor.Create(VD);
                   // fPVDClass.Dump(fLog);
                 End;
        vdtSVD : Begin
                   Log('OpenImage', 'Supplementary Volume Descriptor found'); // Supplementary Volume Descriptor

                   If ( Assigned(fSVDClass) ) Then // newer PVD
                     fSVDClass.Free;
                   fSVDClass := TSupplementaryVolumeDescriptor.Create(VD);
                   // fSVDClass.Dump(fLog);
                 End;
      End;
    Until ( VD.DescriptorType = vdtVDST );

    ParseDirectory;

    Result := True;
  End
  Else
  Begin
    Log('OpenImage', 'file "' + fFileName + '" not found');
    Raise EISOLibImageException.Create('image file not found');
  End;
End;

Function TISOImage.ParseDirectory(Const AUsePrimaryVD : Boolean): Boolean;
Var
  DirRootSourceRec : TRootDirectoryRecord;
  EndSector   : Cardinal;
  DR          : PDirectoryRecord;
  FileName    : String;
  lWorkPtr,
  lBuffer     : PByte;
Begin
  Result := False;

  If ( AUsePrimaryVD ) Then
  Begin
    Log('ParseDirectory', 'parsing directory using primary volume descriptor...');
    DirRootSourceRec := fPVDClass.Descriptor.Primary.RootDirectory;
  End
  Else
  Begin
    Log('ParseDirectory', 'parsing directory using supplementary volume descriptor...');
    If Not Assigned(fSVDClass) Then
      Raise EISOLibImageException.Create('no supplementary volume descriptor found!');
      
    DirRootSourceRec := fSVDClass.Descriptor.Primary.RootDirectory;
  End;
  Log('ParseDirectory', 'directory sector ' + IntToStr(DirRootSourceRec.LocationOfExtent.LittleEndian));

  EndSector := DirRootSourceRec.LocationOfExtent.LittleEndian +
               ( DirRootSourceRec.DataLength.LittleEndian + fImage.SectorDataSize-1 ) Div fImage.SectorDataSize;

  fImage.SeekSector(DirRootSourceRec.LocationOfExtent.LittleEndian);

  GetMem(lBuffer, fImage.SectorDataSize);
  Try
    lWorkPtr := lBuffer;
    fImage.ReadSector_Data(lWorkPtr^, fImage.SectorDataSize);

    While ( fImage.CurrentSector <= EndSector ) Do
    Begin
      If ( fImage.SectorDataSize - ( Cardinal(lWorkPtr) - Cardinal(lBuffer) )) < SizeOf(TDirectoryRecord) Then
      Begin
        lWorkPtr := lBuffer;
        fImage.ReadSector_Data(lWorkPtr^, fImage.SectorDataSize);
      End;

      New(DR);
      Move(lWorkPtr^, DR^, SizeOf(TDirectoryRecord));
      Inc(lWorkPtr, SizeOf(TDirectoryRecord));

      SetLength(FileName, DR.LengthOfFileIdentifier);
      Move(lWorkPtr^, FileName[1], DR.LengthOfFileIdentifier);
      Inc(lWorkPtr, DR.LengthOfFileIdentifier);

        // padding bytes
      If ( ( SizeOf(TDirectoryRecord) + DR.LengthOfFileIdentifier ) < DR.LengthOfDirectoryRecord ) Then
        Inc(lWorkPtr, DR.LengthOfDirectoryRecord - SizeOf(TDirectoryRecord) - DR.LengthOfFileIdentifier);

      ParseDirectorySub(fTree.RootDirectory, FileName, DR);
    End;
  Finally
    FreeMem(lBuffer, fImage.SectorDataSize);
  End;
End;

Function TISOImage.ParseDirectorySub(AParentDir : TDirectoryEntry; Const AFileName : String; Var ADirectoryEntry : PDirectoryRecord): Boolean;
Var
  EndSector   : Cardinal;
  OldPosition : Integer;
  ActDir      : TDirectoryEntry;
  FileEntry   : TFileEntry;
  DRFileName  : String;
  DR          : PDirectoryRecord;
  lWorkPtr,
  lBuffer     : PByte;
Begin
  If ( ADirectoryEntry.FileFlags And $2 ) = $2 Then // directory
  Begin
    OldPosition := fImage.CurrentSector;

    If ( AFileName <> #0 ) And ( AFileName <> #1 ) Then
    Begin
      ActDir := TDirectoryEntry.Create(fTree, AParentDir, dsfFromImage);
      ActDir.Name    := AFileName;
      ActDir.ISOData := ADirectoryEntry^;

      fImage.SeekSector(ADirectoryEntry.LocationOfExtent.LittleEndian);

      EndSector := ADirectoryEntry.LocationOfExtent.LittleEndian +
                   ( ADirectoryEntry.DataLength.LittleEndian + fImage.SectorDataSize-1 ) Div fImage.SectorDataSize;

      Dispose(ADirectoryEntry);
      ADirectoryEntry := Nil;

      GetMem(lBuffer, fImage.SectorDataSize);
      Try
        lWorkPtr := lBuffer;
        fImage.ReadSector_Data(lWorkPtr^, fImage.SectorDataSize);

        While ( fImage.CurrentSector <= EndSector ) Do
        Begin
          If ( fImage.SectorDataSize - ( Cardinal(lWorkPtr) - Cardinal(lBuffer) )) < SizeOf(TDirectoryRecord) Then
          Begin
            lWorkPtr := lBuffer;
            fImage.ReadSector_Data(lWorkPtr^, fImage.SectorDataSize);
          End;

          New(DR);
          Move(lWorkPtr^, DR^, SizeOf(TDirectoryRecord));
          Inc(lWorkPtr, SizeOf(TDirectoryRecord));

          SetLength(DRFileName, DR.LengthOfFileIdentifier);
          Move(lWorkPtr^, DRFileName[1], DR.LengthOfFileIdentifier);
          Inc(lWorkPtr, DR.LengthOfFileIdentifier);

            // padding bytes
          If ( ( SizeOf(TDirectoryRecord) + DR.LengthOfFileIdentifier ) < DR.LengthOfDirectoryRecord ) Then
            Inc(lWorkPtr, DR.LengthOfDirectoryRecord - SizeOf(TDirectoryRecord) - DR.LengthOfFileIdentifier);

          ParseDirectorySub(ActDir, DRFileName, DR);
        End;
      Finally
        FreeMem(lBuffer, fImage.SectorDataSize);
      End;
    End;

    fImage.SeekSector(OldPosition);
  End
  Else
  Begin
    If ( AFileName <> '' ) And ( ADirectoryEntry.DataLength.LittleEndian > 0 ) Then
    Begin
      FileEntry := TFileEntry.Create(AParentDir, dsfFromImage);
      FileEntry.Name    := AFileName;
      FileEntry.ISOData := ADirectoryEntry^;
    End;
  End;

  Result := True;
End;

Function TISOImage.ParsePathTable(ATreeView : TTreeView): Boolean;
Var
  PathTableEntry : TPathTableRecord;
  FileName       : String;
  SectorCount    : Cardinal;
  Node           : TTreeNode;
  PathTabelEntryNumber : Integer;
  lWorkPtr,
  lBuffer        : PByte;
  i              : Integer;

  Function FindParent(Const AParentPathNumber : Integer): TTreeNode;
  Begin
    Result := ATreeView.Items.GetFirstNode;

    While ( Integer(Result.Data) <> AParentPathNumber ) Do
      Result := Result.GetNext;
  End;

Begin
  Result := False;

  Log('ParsePathTable', 'path table first sector ' + IntToStr(fPVDClass.Descriptor.Primary.LocationOfTypeLPathTable));
  Log('ParsePathTable', 'path table length ' + IntToStr(fPVDClass.Descriptor.Primary.PathTableSize.LittleEndian) + ' bytes');

  If ( Assigned(ATreeView) ) Then
    ATreeView.Items.Clear;

  SectorCount := ( fPVDClass.Descriptor.Primary.PathTableSize.LittleEndian +
                   fImage.SectorDataSize -1 ) Div fImage.SectorDataSize;

  fImage.SeekSector(fPVDClass.Descriptor.Primary.LocationOfTypeLPathTable);

  GetMem(lBuffer, SectorCount * fImage.SectorDataSize);
  lWorkPtr := lBuffer;
  Try
    PathTabelEntryNumber := 0;

    For i := 1 To SectorCount Do
    Begin
      fImage.ReadSector_Data(lWorkPtr^, fImage.SectorDataSize);
      Inc(lWorkPtr, fImage.SectorDataSize);
    End;

    lWorkPtr := lBuffer;

    Repeat
      Move(lWorkPtr^, PathTableEntry, SizeOf(PathTableEntry));
      Inc(lWorkPtr, SizeOf(PathTableEntry));

      SetLength(FileName, PathTableEntry.LengthOfDirectoryIdentifier);
      Move(lWorkPtr^, FileName[1], PathTableEntry.LengthOfDirectoryIdentifier);
      Inc(lWorkPtr, PathTableEntry.LengthOfDirectoryIdentifier);

      If ( Odd(PathTableEntry.LengthOfDirectoryIdentifier) ) Then
        Inc(lWorkPtr, 1);

      Inc(PathTabelEntryNumber);

      If ( PathTableEntry.LengthOfDirectoryIdentifier = 1 ) Then
      Begin
        If ( Assigned(ATreeView) ) And ( PathTabelEntryNumber = 1 ) Then
        Begin
          Node := ATreeView.Items.AddChild(Nil, '/');
          Node.Data := Pointer(PathTabelEntryNumber);
        End;
      End
      Else
      Begin
        If ( Assigned(ATreeView) ) Then
        Begin
          Node := ATreeView.Items.AddChild(FindParent(PathTableEntry.ParentDirectoryNumber), FileName);
          Node.Data := Pointer(PathTabelEntryNumber);
        End;
      End;
    Until ( (Cardinal(lWorkPtr) - Cardinal(lBuffer) ) >= fPVDClass.Descriptor.Primary.PathTableSize.LittleEndian );
  Finally
    FreeMem(lBuffer, SectorCount * fImage.SectorDataSize);
  End;
End;

End.

//  Log List
//
// $Log: ISOImage.pas,v $
// Revision 1.5  2004/06/15 15:33:29  muetze1
// renamed class to prevent later problems when creatin TISOLib
//
// Revision 1.4  2004/06/15 14:46:03  muetze1
// removed warnings and old comments
//
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

