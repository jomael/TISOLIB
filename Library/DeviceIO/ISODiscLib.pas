(******************************************************************************)
(*                                                                            *)
(*  TISOLib - ISODiscLib.pas                                                  *)
(*  Version: 1.06                                                             *)
(*  Date: 5/31/2004                                                           *)
(*  Author: Daniel Mann                                                       *)
(*  Internet: http://isolib.xenome.info                                       *)
(*                                                                            *)
(******************************************************************************)

//
// $Id: ISODiscLib.pas,v 1.5 2004/07/15 21:09:16 nalilord Exp $
//

Unit ISODiscLib;

Interface

Uses
  Windows,
  ISOSCSIConsts,
  ISOSCSIStructs,
  ISOToolBox,
  ISOASPILoader;

Type
  TProgressEvent = Procedure(Const Position: LongWord; Const Size: LongWord) Of Object;

Type
  TISODiscLib = Class
  Private
    FOnProgress : TProgressEvent;
    fUseSPTI    : Boolean;
    fUseASPI    : Boolean;
    FDrives     : TDriveList;

    Function   InitSPTI: Boolean;
    Function   InitASPI: Boolean;
    Function   OpenPort(Const APort: String): THandle;
    Function   ClosePort(Const AHandle: THandle): Boolean;
  Public
    Constructor Create; Virtual;
    Destructor  Destroy; Override;

    Function    ScanDevices: Boolean;
    function    GetStatus(const AHandle:THandle;var MechanismStatus:TMechanismStatus):Boolean;
    Function    UnitReady(Const AHandle: THandle): Boolean;
    Function    ReadDiscInformation(Const AHandle: THandle; Var DiscInformation: TDiscInformation): Boolean;
    Function    GetDiscType(Const AHandle: THandle): Integer;
    //TODO 5 -oNaliLord:test and finish the GetConfigurationData function
    function    GetConfigurationData(const AHandle:THandle;const StartingFeature:Word;const UnitReturned:TUnitReturned;Buffer:Pointer;const BufferSize:Word):Boolean;
    Function    GetFormatCapacity(Const AHandle:THandle; Var FormatCapacity:TFormatCapacity): Boolean;
    Function    ReadTOC(Const AHandle: THandle):Boolean;
    Function    ReadTrackInformation(Const AHandle: THandle; Const ATrack: Byte; Var TrackInformation:TTrackInformation): Boolean;
    Function    OpenDrive(Const ADrive: Char): THandle;
    Function    CloseDrive(Const AHandle: THandle): Boolean;
    Function    ReadDVDLayerDescriptor(Const AHandle: THandle; Var DVDLayerDescriptor:TDVDLayerDescriptor): Boolean;
    //TODO 4 -oNaliLord:finish ModeSense10Capabilities function (return set of capabilities) 
    Function    ModeSense10Capabilities(Const AHandle: THandle; Var Mode10Capabilities:TMode10Capabilities): Boolean;

    Procedure   Test(Const AHandle: THandle);

    Property    OnProgress:TProgressEvent              Read  FOnProgress
                                                       Write FOnProgress;

  End;

Implementation

Uses
  Forms,     // for Application
  Dialogs,   // for ShowMessage()
  Classes,   // for TMemoryStream, needed for some tests
  SysUtils;  // for Trim()

Constructor TISODiscLib.Create;
Begin
  Inherited;

  fUseASPI := InitASPI;
  fUseSPTI := InitSPTI;

End;

Destructor TISODiscLib.Destroy;
Begin
  If ( fUseASPI ) Then
    UnInitializeASPI;

  Inherited;
End;

Function TISODiscLib.InitSPTI: Boolean;
Begin
  If ( GetOsVersion In [OS_WIN2K, OS_WINXP, OS_WINNT4] ) Then
    Result := IsAdministrator
  Else
    Result := False;
End;

Function TISODiscLib.InitASPI: Boolean;
Var
  SupportInfo: LongWord;
Begin
  Result := False;

  If WNASPI32_Loaded Then
  Begin
    SupportInfo := GetASPI32SupportInfo;

    Result := ( HiByte( LoWord(SupportInfo) ) =  SS_COMP        ) And
              ( HiByte( LoWord(SupportInfo) ) <> SS_NO_ADAPTERS );
  End;
End;

Function TISODiscLib.OpenPort(Const APort: String): THandle;
Begin
  Result := INVALID_HANDLE_VALUE;

  If fUseSPTI Then
  Begin
    Result := CreateFile( PChar('\\.\'+ APort +':'),
                          GENERIC_READ Or GENERIC_WRITE,
                          FILE_SHARE_READ Or FILE_SHARE_WRITE,
                          Nil,
                          OPEN_EXISTING,
                          FILE_ATTRIBUTE_NORMAL,
                          0);
  End;
End;

Function TISODiscLib.ClosePort(Const AHandle: THandle): Boolean;
Begin
  Result := CloseHandle(AHandle);
End;

Function TISODiscLib.OpenDrive(Const ADrive: Char): THandle;
Begin
  Result := INVALID_HANDLE_VALUE;

  If fUseSPTI Then
    If GetDriveType(PChar(String(ADrive)+':')) = DRIVE_CDROM Then
      Result := OpenPort(ADrive);
End;

Function TISODiscLib.CloseDrive(Const AHandle: THandle):Boolean;
Begin
  Result := ClosePort(AHandle);
End;

function TISODiscLib.GetStatus(const AHandle:THandle;var MechanismStatus:TMechanismStatus):Boolean;
var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Returned : LongWord;
  Size     : Cardinal;
begin
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 11;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(TMechanismStatus);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @MechanismStatus;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0]:=$BD;
  SPTDW.Spt.Cdb[8]:=HiByte(SizeOf(TMechanismStatus));
  SPTDW.Spt.Cdb[9]:=LoByte(SizeOf(TMechanismStatus));

  Result:=DeviceIoControl(AHandle,IOCTL_SCSI_PASS_THROUGH_DIRECT,@SPTDW,Size,@SPTDW,Size,Returned,Nil);
end;

Function TISODiscLib.UnitReady(Const AHandle: THandle):Boolean;
Var
  SPTDW           : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Returned        : LongWord;
  Size            : Cardinal;
  Sense           : TSenseData;
  MechanismStatus : TMechanismStatus;
Begin
  Result:=False;
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 6;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := 0;
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := nil;
  SPTDW.Spt.SenseInfoOffset    := 48;

  if DeviceIoControl(AHandle,IOCTL_SCSI_PASS_THROUGH_DIRECT,@SPTDW,Size,@SPTDW,Size,Returned,Nil) then
  begin
    CopyMemory(@Sense,@SPTDW.SenseBuf,32);

    if Sense.ErrorCode = $00 then Result:=True else // device is maby not ready, or medium missing?
    begin
      ZeroMemory(@MechanismStatus,SizeOf(MechanismStatus));
      if GetStatus(AHandle,MechanismStatus) then
      begin
        // device status, handle advanced options: tray open, busy...
      end else
      begin
        // can't get device status, handle error here
      end;
    end;

  end;

End;

Function TISODiscLib.ScanDevices: Boolean;
Var
  SPTDW           : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  ScsiInquiryData : SCSI_INQUIRY_DATA_RESULT;
  ScsiAddress     : SCSI_ADDRESS;
  ScsiPort,
  Size, Num,
  Returned        : LongWord;
Begin
  Result := False;

  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length          := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength       := 6;
  SPTDW.Spt.SenseInfoLength := 32;
  SPTDW.Spt.DataIn          := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(ScsiInquiryData);
  SPTDW.Spt.TimeOutValue    := 120;
  SPTDW.Spt.DataBuffer      := @ScsiInquiryData;
  SPTDW.Spt.SenseInfoOffset := 48;
  SPTDW.Spt.Cdb[0]          := $12;
  SPTDW.Spt.Cdb[4]          := SizeOf(ScsiInquiryData);

  ZeroMemory(@FDrives, SizeOf(FDrives));

  Num := 0;
  Repeat
    If GetDriveType(PChar(Chr(Num+65)+':\')) = DRIVE_CDROM Then
    Begin
      ScsiPort := OpenPort(Chr(Num+65));
      If ( ScsiPort <> INVALID_HANDLE_VALUE ) Then
      Begin
        ZeroMemory(@ScsiInquiryData, SizeOf(ScsiInquiryData));

        If DeviceIoControl(ScsiPort, IOCTL_SCSI_PASS_THROUGH_DIRECT, @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
        Begin
          ZeroMemory(@ScsiAddress, SizeOf(ScsiAddress));
          ScsiAddress.Length := SizeOf(SCSI_ADDRESS);

          If DeviceIoControl(ScsiPort, IOCTL_SCSI_GET_ADDRESS, Nil, 0, @ScsiAddress, SizeOf(SCSI_ADDRESS), Returned, Nil) Then
          Begin
            FDrives.Drives[FDrives.NoOfDrives].Letter    := Chr(Num+65);
            FDrives.Drives[FDrives.NoOfDrives].HaId      := ScsiAddress.PathId;
            FDrives.Drives[FDrives.NoOfDrives].TargetId  := ScsiAddress.TargetId;
            FDrives.Drives[FDrives.NoOfDrives].LunID     := ScsiAddress.Lun;
            FDrives.Drives[FDrives.NoOfDrives].VendorId  := PChar(Trim(StrPas(ScsiInquiryData.VendorId)));
            FDrives.Drives[FDrives.NoOfDrives].ProductId := PChar(Trim(StrPas(ScsiInquiryData.ProductId)));
            FDrives.Drives[FDrives.NoOfDrives].Reversion := PChar(Trim(StrPas(ScsiInquiryData.Reversion)));

            Inc(FDrives.NoOfDrives);
            Result := True;

            Inc(FDrives.NoOfDrives);
          End;
        End;
      End;
      ClosePort(ScsiPort);
    End;
    Inc(Num);
  Until Num = 27;
End;

Function TISODiscLib.ReadDiscInformation(Const AHandle: THandle; Var DiscInformation:TDiscInformation): Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Returned,
  Size     : LongWord;
Begin
  Result := False;

  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  ZeroMemory(@DiscInformation, SizeOf(TDiscInformation));

  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(DiscInformation);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @DiscInformation;
  SPTDW.Spt.SenseInfoOffset    := 48;
  SPTDW.Spt.Cdb[0]             := $51;
  SPTDW.Spt.Cdb[7]             := HiByte(SizeOf(DiscInformation));
  SPTDW.Spt.Cdb[8]             := LoByte(SizeOf(DiscInformation));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    DiscInformation.DiscInformationLength := SwapWord( DiscInformation.DiscInformationLength );
    Result := True;
  End;
End;

Function TISODiscLib.GetDiscType(Const AHandle: THandle):Integer;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size,
  Returned : LongWord;
  DeviceConfigHeader : TDeviceConfigHeader;
Begin
  Result := -1;

  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(DeviceConfigHeader);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @DeviceConfigHeader;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $46;
  SPTDW.Spt.Cdb[1] := $02;
  SPTDW.Spt.Cdb[3] := $00;
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(DeviceConfigHeader));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(DeviceConfigHeader));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    Case SwapWord(DeviceConfigHeader.CurrentProfile) Of
      $0000 : Result :=  0;
      $0001 : Result :=  1;
      $0002 : Result :=  2;
      $0003 : Result :=  3;
      $0004 : Result :=  4;
      $0005 : Result :=  5;
      $0008 : Result :=  6;
      $0009 : Result :=  7;
      $000A : Result :=  8;
      $0010 : Result :=  9;
      $0011 : Result := 10;
      $0012 : Result := 11;
      $0013 : Result := 12;
      $0014 : Result := 13;
      $001A : Result := 14;
      $001B : Result := 15;
      $0020 : Result := 16;
      $0021 : Result := 17;
      $0022 : Result := 18;
      $FFFF : Result := 19;
    Else
      Result := -1;
    End;
  End;
End;

function TISODiscLib.GetConfigurationData(const AHandle:THandle;const StartingFeature:Word;const UnitReturned:TUnitReturned;Buffer:Pointer;const BufferSize:Word):Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size     : Integer;
  Returned : LongWord;
begin
  ZeroMemory(Buffer, BufferSize);
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(BufferSize);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := Buffer;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $46;
  SPTDW.Spt.Cdb[1] := Byte(UnitReturned);
  SPTDW.Spt.Cdb[2] := HiByte(StartingFeature);
  SPTDW.Spt.Cdb[3] := LoByte(StartingFeature);
  SPTDW.Spt.Cdb[7] := HiByte(BufferSize);
  SPTDW.Spt.Cdb[8] := LoByte(BufferSize);

  Result := DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil);
end;

Function TISODiscLib.GetFormatCapacity(Const AHandle: THandle; Var FormatCapacity:TFormatCapacity):Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size, I  : Integer;
  Returned : LongWord;
Begin
  Result := False;

  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(TFormatCapacity);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @FormatCapacity;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $23;
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(TFormatCapacity));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(TFormatCapacity));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    For I := 0 To 32 Do
    Begin
      FormatCapacity.FormattableCD[I].NumberOfBlocks :=
                      SwapDWord(FormatCapacity.FormattableCD[I].NumberOfBlocks);
      FormatCapacity.FormattableCD[I].FormatType     :=
                               FormatCapacity.FormattableCD[I].FormatType Shr 2;
    End;

    FormatCapacity.CapacityDescriptor.NumberOfBlocks := SwapDWord(FormatCapacity.CapacityDescriptor.NumberOfBlocks);

    Result := True;
  End;

End;

Function TISODiscLib.ReadTOC(Const AHandle: THandle):Boolean;
Var
  SPTDW              : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size, Returned     : LongWord;
  TocData0000        : TTOCData0000;
  TocData0001        : TTOCData0001;
  TocData0100        : TTOCData0100;
Begin
  Result := False;

  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  ZeroMemory(@TocData0000, SizeOf(TTOCData0000));
  ZeroMemory(@TocData0001, SizeOf(TTOCData0001));
  ZeroMemory(@TocData0100, SizeOf(TTOCData0100));

  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.SenseInfoOffset    := 48;
  SPTDW.Spt.Cdb[0]             := $43; // Read TOC command

  // == TocData 0000 ===========================================================

  SPTDW.Spt.DataTransferLength := SizeOf(TocData0000);
  SPTDW.Spt.DataBuffer         := @TocData0000;

  SPTDW.Spt.Cdb[1] := $00;
  SPTDW.Spt.Cdb[2] := $00;
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(TocData0000));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(TocData0000));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    ShowMessage('Sturcture DataLength: '+IntToStr(TocData0000.DataLength)+#13+
                'TOC 0000b'+#13+
                '==========================================================='+#13+
                'FirstTrackNumber: '+IntToStr(TocData0000.FirstTrackNumber)+#13+
                'LastTrackNumber: '+IntToStr(TocData0000.LastTrackNumber)+#13+
                'ADR_CONTROL: '+IntToStr(TocData0000.ADR_CONTROL)+#13+
                'TrackNumber: '+IntToStr(TocData0000.TrackNumber)+#13+
                'TrackStartAddress: '+IntToStr(TocData0000.TrackStartAddress));
  End;

  // == TocData 0001 ===========================================================

  SPTDW.Spt.DataTransferLength := SizeOf(TocData0001);
  SPTDW.Spt.DataBuffer         := @TocData0001;

  SPTDW.Spt.Cdb[1] := $00;
  SPTDW.Spt.Cdb[2] := $01;
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(TocData0001));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(TocData0001));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    ShowMessage('Sturcture DataLength: '+IntToStr(TocData0001.DataLength)+#13+
                'TOC 0001b'+#13+
                '==========================================================='+#13+
                'FirstTrackNumber: '+IntToStr(TocData0001.FirstTrackNumber)+#13+
                'LastTrackNumber: '+IntToStr(TocData0001.LastTrackNumber)+#13+
                'ADR_CONTROL: '+IntToStr(TocData0001.ADR_CONTROL)+#13+
                'FirstTrackNumberInLastCompleteSession: '+IntToStr(TocData0001.FirstTrackNumberInLastCompleteSession)+#13+
                'StartAddressOfFirstTrackInLastSession: '+IntToStr(TocData0001.StartAddressOfFirstTrackInLastSession));
  End;

  // == TocData 0100 ===========================================================

  SPTDW.Spt.DataTransferLength := SizeOf(TocData0100);
  SPTDW.Spt.DataBuffer         := @TocData0100;

  SPTDW.Spt.Cdb[1] := $02;
  SPTDW.Spt.Cdb[2] := $04;
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(TocData0100));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(TocData0100));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    ShowMessage('Sturcture DataLength: '+IntToStr(TocData0100.DataLength)+#13+
                'TOC 0100b'+#13+
                '==========================================================='+#13+
                'ATIPStartTimeOfLeadIn_Min: '+IntToStr(TocData0100.ATIPStartTimeOfLeadIn_Min)+#13+
                'ATIPStartTimeOfLeadIn_Sec: '+IntToStr(TocData0100.ATIPStartTimeOfLeadIn_Sec)+#13+
                'ATIPStartTimeOfLeadIn_Frame: '+IntToStr(TocData0100.ATIPStartTimeOfLeadIn_Frame)+#13+
                'ATIPStartTimeOfLeadOut_Min: '+IntToStr(TocData0100.ATIPStartTimeOfLeadOut_Min)+#13+
                'ATIPStartTimeOfLeadOut_Sec: '+IntToStr(TocData0100.ATIPStartTimeOfLeadOut_Sec)+#13+
                'ATIPStartTimeOfLeadOut_Frame: '+IntToStr(TocData0100.ATIPStartTimeOfLeadOut_Frame));
  end;


End;

Function TISODiscLib.ReadTrackInformation(Const AHandle: THandle; Const ATrack: Byte; Var TrackInformation:TTrackInformation): Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size,
  Returned : LongWord;
Begin
  Result := False;
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(TTrackInformation);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @TrackInformation;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $52;
  SPTDW.Spt.Cdb[1] := $01;
  SPTDW.Spt.Cdb[2] := HiByte(HiWord(ATrack));
  SPTDW.Spt.Cdb[3] := LoByte(HiWord(ATrack));
  SPTDW.Spt.Cdb[4] := HiByte(LoWord(ATrack));
  SPTDW.Spt.Cdb[5] := LoByte(LoWord(ATrack));
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(TTrackInformation));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(TTrackInformation));

  If DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                      @SPTDW, Size, @SPTDW, Size, Returned, Nil) Then
  Begin
    With TrackInformation Do
    Begin
      Datalength          := SwapWord(Datalength);
      TrackSize           := SwapDWord(TrackSize);
      FreeBlocks          := SwapDWord(FreeBlocks);
      TrackStartAddress   := SwapDWord(TrackStartAddress);
      NextWritableAddress := SwapDWord(NextWritableAddress);
      FixedpacketSize     := SwapDWord(FixedpacketSize);
      LastRecordedAddress := SwapDWord(LastRecordedAddress);
    End;
    Result:=True;
  End;
End;

Function TISODiscLib.ReadDVDLayerDescriptor(Const AHandle: THandle; Var DVDLayerDescriptor:TDVDLayerDescriptor): Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size,
  Returned : LongWord;
Begin
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  ZeroMemory(@DVDLayerDescriptor, SizeOf(DVDLayerDescriptor));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := 32;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(DVDLayerDescriptor);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @DVDLayerDescriptor;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $AD;
  SPTDW.Spt.Cdb[8] := HiByte(SizeOf(DVDLayerDescriptor));
  SPTDW.Spt.Cdb[9] := LoByte(SizeOf(DVDLayerDescriptor));
  DVDLayerDescriptor.DataLength := SizeOf(DVDLayerDescriptor);

  Result := DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                             @SPTDW, Size, @SPTDW, Size, Returned, Nil);
End;

Function TISODiscLib.ModeSense10Capabilities(Const AHandle: THandle; Var Mode10Capabilities:TMode10Capabilities): Boolean;
Var
  SPTDW    : SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size,
  Returned : LongWord;
Begin
  ZeroMemory(@SPTDW, SizeOf(SPTDW));
  ZeroMemory(@Mode10Capabilities, SizeOf(Mode10Capabilities));
  Size := SizeOf(SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER);

  SPTDW.Spt.Length             := SizeOf(SCSI_PASS_THROUGH);
  SPTDW.Spt.CdbLength          := 10;
  SPTDW.Spt.SenseInfoLength    := SENSE_LEN;
  SPTDW.Spt.DataIn             := SCSI_IOCTL_DATA_IN;
  SPTDW.Spt.DataTransferLength := SizeOf(Mode10Capabilities);
  SPTDW.Spt.TimeOutValue       := 120;
  SPTDW.Spt.DataBuffer         := @Mode10Capabilities;
  SPTDW.Spt.SenseInfoOffset    := 48;

  SPTDW.Spt.Cdb[0] := $5A; // Mode Sense 10
  SPTDW.Spt.Cdb[2] := $2A + $80; // Page code, Default Values
  SPTDW.Spt.Cdb[7] := HiByte(SizeOf(Mode10Capabilities));
  SPTDW.Spt.Cdb[8] := LoByte(SizeOf(Mode10Capabilities));

  Result := DeviceIoControl( AHandle, IOCTL_SCSI_PASS_THROUGH_DIRECT,
                             @SPTDW, Size, @SPTDW, Size, Returned, Nil);
End;

//TODO 3 -oNaliLord:create ReadBuffer functions

(*
function TISODiscLib.Read10Buffer(Handle:Cardinal;LBA:DWORD;Length:DWORD;var Buffer; const BufferSize:Cardinal):Boolean;
var
  SPTDW:SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size:Integer;
  Returned:DWORD;
begin

  // read disc here
  // not ready, still problems with discanalyzing to get the size...

end;

function TISODiscLib.Read12Buffer(Handle:Cardinal;LBA:DWORD;Length:DWORD;var Buffer; const BufferSize:Cardinal):Boolean;
var
  SPTDW:SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size:Integer;
  Returned:DWORD;
begin

  // read disc here
  // not ready, still problems with discanalyzing to get the size...

end;

function TISODiscLib.ReadCDBuffer(Handle:Cardinal;LBA:DWORD;Length:DWORD;var Buffer; const BufferSize:Cardinal):Boolean;
var
  SPTDW:SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  Size:Integer;
  Returned:DWORD;
begin

  // read disc here
  // not ready, still problems with discanalyzing to get the size...

end;
*)

//TODO 2 -oNaliLord:remove Test function and build single functions

Procedure TISODiscLib.Test(Const AHandle: THandle);
Var
  DiscType, Attempts        : Integer;
  DiscInformation           : TDiscInformation;
  FormatCapacity            : TFormatCapacity;
  TrackInformation          : TTrackInformation;
  DVDLayerDescriptor        : TDVDLayerDescriptor;
  Mode10Capabilities        : TMode10Capabilities;
  Value                     : Byte;
  BookType, DiscSize,
  MaximumRate, LinearDensity,
  TrackDensity, NoLayer,
  LayerType, Caps : String;
Begin
  Attempts := 0;

  If ( AHandle <> INVALID_HANDLE_VALUE ) Then
  Begin
    Repeat
      Inc(Attempts);
      Sleep(100);
      Application.ProcessMessages;
    Until ( UnitReady(AHandle)) Or (Attempts = 10);

    If Attempts < 10 Then
    Begin
      DiscType := GetDiscType(AHandle);
      If ( DiscType > -1 ) Then
      Begin
        ZeroMemory(@DiscInformation, SizeOf(DiscInformation));
        ZeroMemory(@FormatCapacity, SizeOf(FormatCapacity));
        ZeroMemory(@TrackInformation, SizeOf(TrackInformation));

        If ( DiscType <= 8 ) Or ( DiscType >= 16 ) Then
        Begin
          if ReadDiscInformation(AHandle,DiscInformation) then
          begin
            if (DiscInformation.Status and 16) = 16 then
              ShowMessage('ReadDiscInformation ok'#13'======================================='#13+
                          'FirstTrack: '+IntToStr(DiscInformation.NumberOfFirstTrack)+#13+
                          'DiscStatus: Eraseable'+#13+
                          'Sessions: '+IntToStr(DiscInformation.NumberOfSessionsLSB))
            else
              ShowMessage('ReadDiscInformation ok'#13'======================================='#13+
                          'FirstTrack: '+IntToStr(DiscInformation.NumberOfFirstTrack)+#13+
                          'Sessions: '+IntToStr(DiscInformation.NumberOfSessionsLSB));
          end;
          if GetFormatCapacity(AHandle,FormatCapacity) then
          begin
            ShowMessage('GetFormatCapacity ok'#13'======================================='#13+
                        'NumberOfBlocks: '+IntToStr(FormatCapacity.CapacityDescriptor.NumberOfBlocks)+#13+
                        'BlockLength: '+IntToStr(EndianToIntelBytes(FormatCapacity.CapacityDescriptor.BlockLength,3)));
          end;

          ReadTOC(AHandle);

        (*
          if ReadTOC(AHandle,TOCDiscInformation) then
          begin
            ShowMessage('ReadTOC ok'#13'======================================='#13+
                        'Start LBA: '+IntToStr(TOCDiscInformation.StartLBA)+#13+
                        'End LBA: '+IntToStr(TOCDiscInformation.EndLBA));
          end;
          if DiscType >= 9 then Track:=1 else Track:=TOCDiscInformation.LastTrackNumber;

          if ReadTrackInformation(AHandle,Track,TrackInformation) then
          begin
            ShowMessage('ReadTrackInformation ok'#13'======================================='#13+
                        'TrackSize: '+IntToStr(TrackInformation.TrackSize)+#13+
                        'LastRecordedAddress: '+IntToStr(TrackInformation.LastRecordedAddress));
          end;
*)
        end else
        begin
          ReadDVDLayerDescriptor(AHandle,DVDLayerDescriptor);

          Value:=(DVDLayerDescriptor.BookType_PartVersion shr 4 ) and $0F;
          case Value of
            $00: BookType:='DVD-ROM';
            $01: BookType:='DVD-RAM';
            $02: BookType:='DVD-R';
            $03: BookType:='DVD-RW';
            $09: BookType:='DVD+RW';
            $0A: BookType:='DVD+R';
            else BookType:='Unknown';
          end;

          Value:=(DVDLayerDescriptor.DiscSize_MaximumRate shr 4 ) and $0F;
          case Value of
            $00: DiscSize:='120mm';
            $01: DiscSize:='80mm';
            else DiscSize:='Unknown';
          end;

          Value:=(DVDLayerDescriptor.DiscSize_MaximumRate and $0F );
          case Value of
            $00: MaximumRate:='2.52 Mbps';
            $01: MaximumRate:='5.04 Mbps';
            $02: MaximumRate:='10.08 Mbps';
            $0F: MaximumRate:='Not Specified';
            else MaximumRate:='Unknown';
          end;

          Value:=(DVDLayerDescriptor.LinearDensity_TrackDensity shr 4 ) and $0F;
          case Value of
            $00: LinearDensity:='0.267 um/bit';
            $01: LinearDensity:='0.293 um/bit';
            $02: LinearDensity:='0.409 to 0.435 um/bit';
            $04: LinearDensity:='0.280 to 0.291 um/bit';
            $08: LinearDensity:='0.353 um/bit';
            else LinearDensity:='Reserved';
          end;

          Value:=(DVDLayerDescriptor.LinearDensity_TrackDensity and $0F );
          case Value of
            $00: TrackDensity:='0.74 um/track';
            $01: TrackDensity:='0.80 um/track';
            $02: TrackDensity:='0.615 um/track';
            else TrackDensity:='Reserved';
          end;

          NoLayer:=IntToStr((DVDLayerDescriptor.NumberOfLayers_TrackPath_LayerType shr 5 ) and $03);

          Value:=(DVDLayerDescriptor.NumberOfLayers_TrackPath_LayerType and $0F );
          case Value of
            $01: LayerType:='Layer contains embossed data';
            $02: LayerType:='Layer contains recordable area';
            $04: LayerType:='Layer contains rewritable area';
            $08: LayerType:='Reserved';
            else LayerType:='Unknown';
          end;

          ShowMessage('DVD Layer Descriptor ok'#13'======================================='#13+
                        'BookType: '+BookType+#13+
                        'DiscSize: '+DiscSize+#13+
                        'MaximumRate:'+MaximumRate+#13+
                        'LinearDensity: '+LinearDensity+#13+
                        'TrackDensity:'+TrackDensity+#13+
                        'NoLayer: '+NoLayer+#13+
                        'LayerType:'+LayerType+#13+
                        'StartingPhysicalSector: 0x'+IntToHex(SwapDWord(DVDLayerDescriptor.StartingPhysicalSector),6)+#13+
                        'EndPhysicalSector:'+IntToStr(SwapDWord(DVDLayerDescriptor.EndPhysicalSector))+#13+
                        'EndPhysicalSectorInLayerZero:'+IntToStr(SwapDWord(DVDLayerDescriptor.EndPhysicalSectorInLayerZero))+#13+
                        'Sectors:'+IntToStr(SwapDWord(DVDLayerDescriptor.EndPhysicalSector)-SwapDWord(DVDLayerDescriptor.StartingPhysicalSector)));
        End;

        if ModeSense10Capabilities(AHandle,Mode10Capabilities) then
        begin
          Caps:='';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,0) then Caps:='Device can Read CD-R';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,1) then Caps:=Caps+#13+'Device can Read CD-RW';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,2) then Caps:=Caps+#13+'Device can Read Method 2';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,3) then Caps:=Caps+#13+'Device can Read DVD-ROM';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,4) then Caps:=Caps+#13+'Device can Read DVD-R / DVD-RW';
          if IsBitSet(Mode10Capabilities.ReadCapabilities,5) then Caps:=Caps+#13+'Device can Read DVD-RAM';
          if IsBitSet(Mode10Capabilities.WriteCapabilities,0) then Caps:=Caps+#13+'Device can Write CD-R';
          if IsBitSet(Mode10Capabilities.WriteCapabilities,1) then Caps:=Caps+#13+'Device can Write CD-RW';
          if IsBitSet(Mode10Capabilities.WriteCapabilities,2) then Caps:=Caps+#13+'Device can Write Test';
          if IsBitSet(Mode10Capabilities.WriteCapabilities,4) then Caps:=Caps+#13+'Device can Write DVD-R / DVD-RW';
          if IsBitSet(Mode10Capabilities.WriteCapabilities,5) then Caps:=Caps+#13+'Device can Write DVD-RAM';
          Caps:=Caps+#13+'Device Buffer: '+IntToStr(SwapWord(Mode10Capabilities.BufferSizeSupported))+'k';
          Caps:=Caps+#13+'Max Read Speed: '+IntToStr(Round(SwapWord(Mode10Capabilities.MaxReadSpeed)  / 176.46))+'x';
          Caps:=Caps+#13+'Max Write Speed: '+IntToStr(Round(SwapWord(Mode10Capabilities.MaxWriteSpeed)  / 176.46))+'x';
          Caps:=Caps+#13+'Current Read Speed: '+IntToStr(Round(SwapWord(Mode10Capabilities.CurrentReadSpeed)  / 176.46))+'x';
          Caps:=Caps+#13+'Current Write Speed: '+IntToStr(Round(SwapWord(Mode10Capabilities.CurrentWriteSpeed)  / 176.46))+'x';
          ShowMessage('Device Capabilities'+#13+
                      '==========================================================='+#13+
                      Caps);
        end;
      End;
    End
    Else
    Begin // Unit not ready! Execute no disc function, but handle drive capabilities request!
      ShowMessage('Error, unit not ready!'#13'Tray open or no disc in drive?');
    End;
  End;
End;

End.

//  Log List
//
// $Log: ISODiscLib.pas,v $
// Revision 1.5  2004/07/15 21:09:16  nalilord
// Fixed some bugs an structures in DeviceIO
// Fixed ReadTOC
// New function GetConfigurationData
// Now can get Device Capabilities but not yet finished
// Other workarounds and fixes
//
// Revision 1.4  2004/06/24 02:07:05  nalilord
// ISOSCSIStructs
// added - record TModeParametersHeader
// changed - record TMode10Capabilities - mode header was missing
//
// ISODiscLib
// working - function ModeSense10Capabilities
//
// ISOToolBox
// crtical - bugfix function SwapWord - Miscalculation in function
// changed - function SwapDWord - Calculation in function
//
// added ToDo list
//
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

