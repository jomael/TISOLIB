//
//  TISOLib - ASPI Loader
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOASPILoader.pas,v 1.3 2004/06/07 02:24:41 nalilord Exp $
//

Unit ISOASPILoader;

Interface

Uses
  Windows,
  ISOSCSIStructs;

Var
  WNASPI32_Loaded         : Boolean                 = False;
  SendASPI32Command       : TSendASPI32Command      = Nil;
  GetASPI32SupportInfo    : TGetASPI32SupportInfo   = Nil;
  GetASPI32Buffer         : TGetASPI32Buffer        = Nil;
  FreeASPI32Buffer        : TFreeASPI32Buffer       = Nil;
  TranslateASPI32Address  : TTranslateASPI32Address = Nil;

Const
  WNASPI32_Lib = 'wnaspi32.dll';

Function InitializeASPI: Boolean;
Function UnInitializeASPI: Boolean;

Implementation

Var
  WNASPI32_Instance : THandle = 0;

Function InitializeASPI:Boolean;
Begin
  Result          := False;
  WNASPI32_Loaded := False;

  WNASPI32_Instance := LoadLibrary(PChar(WNASPI32_Lib));
  If ( WNASPI32_Instance <> 0 ) Then
  Begin
    @SendASPI32Command      := GetProcAddress(WNASPI32_Instance,'SendASPI32Command');
    @GetASPI32SupportInfo   := GetProcAddress(WNASPI32_Instance,'GetASPI32SupportInfo');
    @GetASPI32Buffer        := GetProcAddress(WNASPI32_Instance,'GetASPI32Buffer');
    @FreeASPI32Buffer       := GetProcAddress(WNASPI32_Instance,'FreeASPI32Buffer');
    @TranslateASPI32Address := GetProcAddress(WNASPI32_Instance,'TranslateASPI32Address');

    WNASPI32_Loaded := True;
    Result          := True;
  End;
End;

Function UnInitializeASPI: Boolean;
Begin
  Result := False;

  If WNASPI32_Loaded Then
  Begin
    WNASPI32_Loaded   := FreeLibrary(WNASPI32_Instance);
    WNASPI32_Instance := 0;

    @SendASPI32Command      := Nil;
    @GetASPI32SupportInfo   := Nil;
    @GetASPI32Buffer        := Nil;
    @FreeASPI32Buffer       := Nil;
    @TranslateASPI32Address := Nil;

    Result := True;
  End;
End;

End.

//  Log List
//
// $Log: ISOASPILoader.pas,v $
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

