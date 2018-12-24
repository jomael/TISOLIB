//
//  TISOLib - Exception definitions
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOException.pas,v 1.3 2004/06/07 02:24:41 nalilord Exp $
//

Unit ISOException;

Interface

Uses
  SysUtils;   // for Exception

Type
  EISOLibException = Class(Exception);
  EISOLibImageException = Class(EISOLibException);
  EISOLibContainerException = Class(EISOLibException);

Implementation

End.

//  Log List
//
// $Log: ISOException.pas,v $
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//
//
