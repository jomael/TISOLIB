//
//  TISOLib - function toolbox
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOToolBox.pas,v 1.6 2004/07/15 21:09:16 nalilord Exp $
//

Unit ISOToolBox;

Interface

Uses
  ISOStructs, Dialogs;

  Function IntToMB(Const ASize : Int64): String;
  Function VolumeDateTimeToStr(Const VDT : TVolumeDateTime): String;
  Function SwapWord(Const AValue : Word): Word;
  Function SwapDWord(Const AValue : LongWord): LongWord;
  Function BuildBothEndianWord(Const AValue : Word): TBothEndianWord;
  Function BuildBothEndianDWord(Const AValue : LongWord): TBothEndianDWord;
  Function BuildVolumeDateTime(Const ADateTime : TDateTime; Const AGMTOffset : Byte): TVolumeDateTime;
  Function RetrieveFileSize(Const AFileName : String): LongWord;
  Function IsAdministrator:Boolean;
  Function GetOsVersion:Integer;
  Function Endian(Const Source; Var Destination; Const Count:Integer): Boolean;
  Function EndianToIntelBytes(const AValue:Array of Byte;Count:Byte):Integer;
  Function GetLBA(Const Byte1,Byte2,Byte3,Byte4:Byte): LongWord;
  Function HMSFtoLBA(Const AHour, AMinute, ASecond, AFrame : Byte): LongWord;
  Function HiWord(Lx:LongWord):Word;
  Function LoWord(Lx:LongWord):Word;
  Function HiByte(Lx:Word):Byte;
  Function LoByte(Lx:Word):Byte;
  Function IsBitSet(Const Value: LongWord; Const Bit: Byte): Boolean;
  Function BitOn(Const Value: LongWord;Const Bit: Byte): LongWord;
  Function BitOff(Const Value: LongWord;Const Bit: Byte): LongWord;
  Function BitToggle(Const Value: LongWord;Const Bit: Byte): LongWord;
  Function ByteToBin(Value: Byte): String;

Const
  OS_UNKNOWN  = -1;
  OS_WIN95    =  0;
  OS_WIN98    =  1;
  OS_WINNT35  =  2;
  OS_WINNT4   =  3;
  OS_WIN2K    =  4;
  OS_WINXP    =  5;

Implementation

Uses
  Windows,   // for TSIDIdentifierAuthority
  SysUtils;  // for IntToStr()

Const
  SECURITY_NT_AUTHORITY: TSIDIdentifierAuthority  = (Value: (0, 0, 0, 0, 0, 5));
  SECURITY_BUILTIN_DOMAIN_RID                     = $00000020;
  DOMAIN_ALIAS_RID_ADMINS                         = $00000220;

Function IntToMB(Const ASize : Int64): String;
Begin
  Result := IntToStr( ASize Div 1024 Div 1024 );
End;

Function VolumeDateTimeToStr(Const VDT : TVolumeDateTime): String;
Begin
  Result := String(VDT.Day) + '.' + String(VDT.Month) + '.' +
            String(VDT.Year) + ' ' + String(VDT.Hour) + ':' +
            String(VDT.Minute) + ':' + String(VDT.Second) + '.' +
            String(VDT.MSeconds) + ' ' + IntToStr(VDT.GMTOffset*15) + ' min from GMT';
End;

Function SwapWord(Const AValue : Word): Word;
Begin
  Result := (( AValue shl 8) and $FF00) or (( AValue shr 8) and $00FF);
End;

Function SwapDWord(Const AValue : LongWord): LongWord;
Begin
  Result := ((AValue shl 24) and $FF000000) or
            ((AValue shl  8) and $00FF0000) or
            ((AValue shr  8) and $0000FF00) or
            ((AValue shr 24) and $000000FF);
End;

Function BuildBothEndianWord(Const AValue : Word): TBothEndianWord;
Begin
  Result.LittleEndian := AValue;
  Result.BigEndian    := SwapWord(AValue);
End;

Function BuildBothEndianDWord(Const AValue : LongWord): TBothEndianDWord;
Begin
  Result.LittleEndian := AValue;
  Result.BigEndian    := SwapDWord(AValue);
End;

Function BuildVolumeDateTime(Const ADateTime : TDateTime; Const AGMTOffset : Byte): TVolumeDateTime;
Var
  Hour, Min, Sec, MSec,
  Year, Month, Day : Word;
  s : String;
Begin
  DecodeTime(ADateTime, Hour, Min, Sec, MSec);
  DecodeDate(ADateTime, Year, Month, Day);

  Result.GMTOffset := AGMTOffset;
  s := IntToStr(Hour);
  StrPCopy(Result.Hour,     StringOfChar('0', Length(Result.Hour) - Length(s)));
  s := IntToStr(Min);
  StrPCopy(Result.Minute,   StringOfChar('0', Length(Result.Minute) - Length(s)));
  s := IntToStr(Sec);
  StrPCopy(Result.Second,   StringOfChar('0', Length(Result.Second) - Length(s)));
  s := IntToStr(MSec);
  StrPCopy(Result.MSeconds, StringOfChar('0', Length(Result.MSeconds) - Length(s)));
  s := IntToStr(Year);
  StrPCopy(Result.Year,     StringOfChar('0', Length(Result.Year) - Length(s)));
  s := IntToStr(Month);
  StrPCopy(Result.Month,    StringOfChar('0', Length(Result.Month) - Length(s)));
  s := IntToStr(Day);
  StrPCopy(Result.Day,      StringOfChar('0', Length(Result.Day) - Length(s)));
End;

Function RetrieveFileSize(Const AFileName : String): LongWord;
Var
  SR : TSearchRec;
Begin
  Result := 0;

  If ( FileExists(AFileName) ) And
     ( FindFirst(AFileName, faAnyFile, SR) = 0 ) Then
  Begin
    If ( ( SR.Attr And faDirectory ) = 0 ) And
       ( ( SR.Attr And faVolumeID  ) = 0 ) Then
      Result := SR.Size;
  End;
End;

// got it from: http://community.borland.com/article/0,1410,26752,00.html
Function IsAdministrator: Boolean;
Var
  hAccessToken: THandle;
  ptgGroups: PTokenGroups;
  dwInfoBufferSize: DWORD;
  psidAdministrators: PSID;
  x: Integer;
  bSuccess: BOOL;
Begin
  Result := False;
  bSuccess := OpenThreadToken(GetCurrentThread, TOKEN_QUERY, True,
    hAccessToken);
  If Not bSuccess Then
  Begin
    If GetLastError = ERROR_NO_TOKEN Then
    bSuccess := OpenProcessToken(GetCurrentProcess, TOKEN_QUERY,
                                  hAccessToken);
  End;
  If bSuccess Then
  Begin
    GetMem(ptgGroups, 1024);
    bSuccess := GetTokenInformation(hAccessToken, TokenGroups,
                                    ptgGroups, 1024, dwInfoBufferSize);
    CloseHandle(hAccessToken);
    If bSuccess Then
    Begin
      AllocateAndInitializeSid(SECURITY_NT_AUTHORITY, 2,
        SECURITY_BUILTIN_DOMAIN_RID, DOMAIN_ALIAS_RID_ADMINS,
        0, 0, 0, 0, 0, 0, psidAdministrators);
      {$R-}
      For x := 0 To ptgGroups.GroupCount - 1 Do
        If EqualSid(psidAdministrators, ptgGroups.Groups[x].Sid) Then
        Begin
          Result := True;
          Break;
        End;
      {$R+}
      FreeSid(psidAdministrators);
    End;
    FreeMem(ptgGroups);
  End;
End;

Function GetOsVersion:Integer;
Var
  OS:OSVERSIONINFO;
Begin
  ZeroMemory(@OS,sizeof(OS));
  OS.dwOSVersionInfoSize:=SizeOf(OS);
  GetVersionEx(OS);

  If ( OS.dwPlatformId = VER_PLATFORM_WIN32_NT ) Then
  Begin
    If ( OS.dwMajorVersion = 3 ) And ( OS.dwMinorVersion >= 51 ) Then
    Begin
      Result := OS_WINNT35;
      Exit;
    End
    Else If ( OS.dwMajorVersion = 4 ) Then
    Begin
      Result := OS_WINNT4;
      Exit;
    End
    Else If ( OS.dwMajorVersion = 5 ) And ( OS.dwMinorVersion = 0 ) Then
    Begin
      Result:=OS_WIN2K;
      Exit;
    End
    Else
    Begin
      Result := OS_WINXP;
      Exit;
    End;
  End
  Else If ( OS.dwPlatformId = VER_PLATFORM_WIN32_WINDOWS ) Then
  Begin
    If ( OS.dwMinorVersion = 0 ) Then
    Begin
      Result:=OS_WIN95;
      Exit;
    End
    Else
    Begin
      Result:=OS_WIN98;
      Exit;
    End;
  End;

  Result := OS_UNKNOWN;
end;

Function Endian(Const Source; Var Destination; Const Count:Integer): Boolean;
Var
  PSource,PDestination:PChar;
  I:Integer;
Begin
  Result:=False;
  PSource:=@Source;
  PDestination:=PChar(@Destination)+Count;
  For i := 0 To Count-1 Do
  Begin
    Dec(PDestination);
    pDestination^:=PSource^;
    Inc(PSource);
    Result:=True;
  End;
End;

Function EndianToIntelBytes(const AValue:Array of Byte;Count:Byte):Integer;
var
  I:Integer;
begin
  Result:=0;
  for I:=0 to Count-1 do
  begin
    Result:=(AValue[I] shl ((Count-(I+1))*8) or Result);
  end;
end;

Function GetLBA(Const Byte1,Byte2,Byte3,Byte4:Byte):LongWord;
Begin
  Result := ( Byte1 Shl 24 ) Or ( Byte2 Shl 16 ) Or (Byte3 Shl 8 ) Or Byte4;
End;

Function HMSFtoLBA(Const AHour, AMinute, ASecond, AFrame : Byte): LongWord;
Begin
  Result := (AHour * 60 * 60 * 75) + (AMinute * 60 * 75) + (ASecond * 75) + AFrame;
End;

Function HiWord(Lx:LongWord):Word;
Begin
  Result := (Lx Shr 16) And $FFFF;
End;

Function LoWord(Lx:LongWord):Word;
Begin
  Result := Lx;
End;

Function HiByte(Lx:Word):Byte;
Begin
  Result := (Lx Shr 8) And $FF;
End;

Function LoByte(Lx:Word):Byte;
Begin
  Result := Lx And $FF;
End;

Function IsBitSet(Const Value: LongWord; Const Bit: Byte): Boolean;
Begin
  Result := ( Value And (1 Shl Bit) ) <> 0;
End;

Function BitOn(Const Value: LongWord; Const Bit: Byte): LongWord;
Begin
  Result := Value Or (1 Shl Bit);
End;

Function BitOff(Const Value: LongWord; Const Bit: Byte): LongWord;
Begin
  Result := Value And ((1 Shl Bit) Xor $FFFFFFFF);
End;

Function BitToggle(Const Value: LongWord; Const Bit: Byte): LongWord;
Begin
  Result := Value Xor ( 1 Shl Bit );
End;

Function ByteToBin(Value: Byte): String;
Var
  I: Integer;
begin
  Result := StringOfChar('0', 8);

  For I := 0 To 7 Do
  Begin
    If ( Value Mod 2 ) = 1 Then
      Result[8 - i] := '1';
      
    Value := Value Div 2;
  End;
End;

End.

//  Log List
//
// $Log: ISOToolBox.pas,v $
// Revision 1.6  2004/07/15 21:09:16  nalilord
// Fixed some bugs an structures in DeviceIO
// Fixed ReadTOC
// New function GetConfigurationData
// Now can get Device Capabilities but not yet finished
// Other workarounds and fixes
//
// Revision 1.5  2004/06/24 02:07:05  nalilord
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
// Revision 1.4  2004/06/20 16:10:05  nalilord
// range check error in LoByte function fixed
//
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

