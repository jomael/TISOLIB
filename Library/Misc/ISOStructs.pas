//
//  TISOLib - ISO structure definitions
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOStructs.pas,v 1.3 2004/06/07 02:24:41 nalilord Exp $
//

Unit ISOStructs;

Interface

Type
  TBothEndianWord = Packed Record
    LittleEndian,
    BigEndian     : Word;
  End;

  TBothEndianDWord = Packed Record
    LittleEndian,
    BigEndian     : LongWord;
  End;

  TVolumeDateTime = Packed Record
    Year      : Array[0..3] Of Char;
    Month     : Array[0..1] Of Char;
    Day       : Array[0..1] Of Char;
    Hour      : Array[0..1] Of Char;
    Minute    : Array[0..1] Of Char;
    Second    : Array[0..1] Of Char;
    MSeconds  : Array[0..1] Of Char;
    GMTOffset : Byte;
  End;

  TDirectoryDateTime = Packed Record
    Year      : Byte; // since 1900
    Month     : Byte;
    Day       : Byte;
    Hour      : Byte;
    Minute    : Byte;
    Second    : Byte;
    GMTOffset : Byte; // in 15 minutes steps
  End;

  TRootDirectoryRecord = Packed Record
    {0000h} LengthOfDirectoryRecord          : Byte;
    {0001h} ExtendedAttributeRecordLength    : Byte;
    {0002h} LocationOfExtent                 : TBothEndianDWord;
    {000Ah} DataLength                       : TBothEndianDWord;
    {0012h} RecordingDateAndTime             : TDirectoryDateTime;
    {0019h} FileFlags                        : Byte;
              //  bit     value
              //  ------  ------------------------------------------
              //  0 (LS)  0 for a norma1 file, 1 for a hidden file
              //  1       0 for a file, 1 for a directory
              //  2       0 [1 for an associated file]
              //  3       0 [1 for record format specified]
              //  4       0 [1 for permissions specified]
              //  5       0
              //  6       0
              //  7 (MS)  0 [1 if not the final record for the file]

    {001Ah} FileUnitSize                     : Byte;
    {001Bh} InterleaveGapSize                : Byte;
    {001Ch} VolumeSequenceNumber             : TBothEndianWord;
    {0020h} LengthOfFileIdentifier           : Byte; // = 1
    {0021h} FileIdentifier                   : Byte; // = 0
  End;

  PDirectoryRecord = ^TDirectoryRecord;
  TDirectoryRecord = Packed Record
    LengthOfDirectoryRecord          : Byte;
    ExtendedAttributeRecordLength    : Byte;
    LocationOfExtent                 : TBothEndianDWord;
    DataLength                       : TBothEndianDWord;
    RecordingDateAndTime             : TDirectoryDateTime;
    FileFlags                        : Byte;
      //  bit     value
      //  ------  ------------------------------------------
      //  0 (LS)  0 for a norma1 file, 1 for a hidden file
      //  1       0 for a file, 1 for a directory
      //  2       0 [1 for an associated file]
      //  3       0 [1 for record format specified]
      //  4       0 [1 for permissions specified]
      //  5       0
      //  6       0
      //  7 (MS)  0 [1 if not the final record for the file]

    FileUnitSize                     : Byte;
    InterleaveGapSize                : Byte;
    VolumeSequenceNumber             : TBothEndianWord;
    LengthOfFileIdentifier           : Byte;
    // followed by FileIdentifier and padding bytes
  End;

  PPathTableRecord = ^TPathTableRecord;
  TPathTableRecord = Packed Record
    LengthOfDirectoryIdentifier      : Byte;
    ExtendedAttributeRecordLength    : Byte;
    LocationOfExtent                 : Cardinal;
    ParentDirectoryNumber            : Word;
    // followed by DirectoryIdentifier with [LengthOfDirectoryIdentifier] bytes
    // followed by padding byte, if [LengthOfDirectoryIdentifier] is odd
  End;

    // Primary Volume Descriptor
  PPrimaryVolumeDescriptor = ^TPrimaryVolumeDescriptor;
  TPrimaryVolumeDescriptor = Packed Record
    {0001h} StandardIdentifier               : Array [0..4] Of Char;
    {0006h} VolumeDescriptorVersion          : Byte;
    {0007h} unused                           : Byte;
    {0007h} SystemIdentifier                 : Array [0..31] Of Char;
    {0027h} VolumeIdentifier                 : Array [0..31] Of Char;
    {0047h} Unused2                          : Array [0..7] Of Byte;
    {0001h} VolumeSpaceSize                  : TBothEndianDWord;
    {0001h} Unused3                          : Array [0..31] of Byte;
    {0001h} VolumeSetSize                    : TBothEndianWord;
    {0001h} VolumeSequenceNumber             : TBothEndianWord;
    {0001h} LogicalBlockSize                 : TBothEndianWord;
    {0001h} PathTableSize                    : TBothEndianDWord;
    {0001h} LocationOfTypeLPathTable         : LongWord;
    {0001h} LocationOfOptionalTypeLPathTable : LongWord;
    {0001h} LocationOfTypeMPathTable         : LongWord;
    {0001h} LocationOfOptionalTypeMPathTable : LongWord;
    {0001h} RootDirectory                    : TRootDirectoryRecord;
    {0001h} VolumeSetIdentifier              : Array [0..127] Of Char;
    {0001h} PublisherIdentifier              : Array [0..127] Of Char;
    {0001h} DataPreparerIdentifier           : Array [0..127] Of Char;
    {0001h} ApplicationIdentifier            : Array [0..127] Of Char;
    {0001h} CopyrightFileIdentifier          : Array [0..36] Of Char;
    {0001h} AbstractFileIdentifier           : Array [0..36] Of Char;
    {0001h} BibliographicFileIdentifier      : Array [0..36] Of Char;
    {0001h} VolumeCreationDateAndTime        : TVolumeDateTime;
    {0001h} VolumeModificationDateAndTime    : TVolumeDateTime;
    {0001h} VolumeExpirationDateAndTime      : TVolumeDateTime;
    {0001h} VolumeEffectiveDateAndTime       : TVolumeDateTime;
    {0001h} FileStructureVersion             : Byte;
    {0001h} ReservedForFutureStandardization : Byte;
    {0001h} ApplicationUse                   : Array [0..511] Of Byte;
    {0001h} ReservedForFutureStandardization2: Array [0..652] Of Byte;
  End;

    // Supplementary Volume Descriptor
  PSupplementaryVolumeDescriptor = ^TSupplementaryVolumeDescriptor;
  TSupplementaryVolumeDescriptor = Packed Record
    {0001h} StandardIdentifier               : Array [0..4] Of Char;
    {0006h} VolumeDescriptorVersion          : Byte;
    {0007h} VolumeFlags                      : Byte;
    {0007h} SystemIdentifier                 : Array [0..31] Of Char;
    {0027h} VolumeIdentifier                 : Array [0..31] Of Char;
    {0047h} Unused2                          : Array [0..7] Of Byte;
    {0001h} VolumeSpaceSize                  : TBothEndianDWord;
    {0001h} EscapeSequences                  : Array [0..31] of Byte;
    {0001h} VolumeSetSize                    : TBothEndianWord;
    {0001h} VolumeSequenceNumber             : TBothEndianWord;
    {0001h} LogicalBlockSize                 : TBothEndianWord;
    {0001h} PathTableSize                    : TBothEndianDWord;
    {0001h} LocationOfTypeLPathTable         : LongWord;
    {0001h} LocationOfOptionalTypeLPathTable : LongWord;
    {0001h} LocationOfTypeMPathTable         : LongWord;
    {0001h} LocationOfOptionalTypeMPathTable : LongWord;
    {0001h} RootDirectory                    : TRootDirectoryRecord;
    {0001h} VolumeSetIdentifier              : Array [0..127] Of Char;
    {0001h} PublisherIdentifier              : Array [0..127] Of Char;
    {0001h} DataPreparerIdentifier           : Array [0..127] Of Char;
    {0001h} ApplicationIdentifier            : Array [0..127] Of Char;
    {0001h} CopyrightFileIdentifier          : Array [0..36] Of Char;
    {0001h} AbstractFileIdentifier           : Array [0..36] Of Char;
    {0001h} BibliographicFileIdentifier      : Array [0..36] Of Char;
    {0001h} VolumeCreationDateAndTime        : TVolumeDateTime;
    {0001h} VolumeModificationDateAndTime    : TVolumeDateTime;
    {0001h} VolumeExpirationDateAndTime      : TVolumeDateTime;
    {0001h} VolumeEffectiveDateAndTime       : TVolumeDateTime;
    {0001h} FileStructureVersion             : Byte;
    {0001h} ReservedForFutureStandardization : Byte;
    {0001h} ApplicationUse                   : Array [0..511] Of Byte;
    {0001h} ReservedForFutureStandardization2: Array [0..652] Of Byte;
  End;

    // Boot Record Volume Descriptor
  PBootRecordVolumeDescriptor = ^TBootRecordVolumeDescriptor;
  TBootRecordVolumeDescriptor = Packed Record
    StandardIdentifier               : Array [0..4] of Char;
    VersionOfDescriptor              : Byte;
    BootSystemIdentifier             : Array [0..31] of Char;
    BootIdentifier                   : Array [0..31] of Char;
    BootCatalogPointer               : LongWord;
    Unused                           : Array [0..1972] of Byte;
  End;

Const
  // Volume Descriptor Types
  vdtBR   = $00; // Boot Record
  vdtPVD  = $01; // Primary Volume Descriptor
  vdtSVD  = $02; // Supplementary Volume Descriptor
  vdtVDST = $ff; // Volume Descriptor Set Terminator

Type
  TVolumeDescriptor = Packed Record
    Case DescriptorType : Byte Of
      vdtBR   : (BootRecord    : TBootRecordVolumeDescriptor);
      vdtPVD  : (Primary       : TPrimaryVolumeDescriptor);
      vdtSVD  : (Supplementary : TSupplementaryVolumeDescriptor);
  End;

Implementation

End.

//  Log List
//
// $Log: ISOStructs.pas,v $
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

