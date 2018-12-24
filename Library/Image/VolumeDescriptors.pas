//
//  TISOLib - Volume Descriptors
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: VolumeDescriptors.pas,v 1.3 2004/06/07 02:24:41 nalilord Exp $
//

Unit VolumeDescriptors;

Interface

Uses
  SysUtils,
  Classes,
  ISOStructs;

Type
  EVolumeDescriptorException = Class(Exception);
  EVDWrongDescriptorType = Class(EVolumeDescriptorException);

  TPrimaryVolumeDescriptor = Class
  Private
    Function  GetString(Const AIndex : Integer): String;
    Procedure SetString(const AIndex : Integer; Const Value: String);

  Protected
    fDescriptor : TVolumeDescriptor;

  Public
    Constructor Create; Overload; Virtual;
    Constructor Create(Const APrimaryVolumeDescriptor : TVolumeDescriptor); Overload; Virtual;
    Destructor  Destroy; Override;

    Procedure   Dump(AOutput : TStrings);

  Published
    Property  Descriptor : TVolumeDescriptor  Read  fDescriptor;

    Property  SystemIdentifier            : String   Index 0  Read  GetString
                                                              Write SetString;
    Property  VolumeIdentifier            : String   Index 1  Read  GetString
                                                              Write SetString;
    Property  VolumeSetIdentifier         : String   Index 2  Read  GetString
                                                              Write SetString;
    Property  PublisherIdentifier         : String   Index 3  Read  GetString
                                                              Write SetString;
    Property  DataPreparerIdentifier      : String   Index 4  Read  GetString
                                                              Write SetString;
    Property  ApplicationIdentifier       : String   Index 5  Read  GetString
                                                              Write SetString;
    Property  CopyrightFileIdentifier     : String   Index 6  Read  GetString
                                                              Write SetString;
    Property  AbstractFileIdentifier      : String   Index 7  Read  GetString
                                                              Write SetString;
    Property  BibliographicFileIdentifier : String   Index 8  Read  GetString
                                                              Write SetString;
    Property  VolumeCreationDateAndTime   : TVolumeDateTime   Read  fDescriptor.Primary.VolumeCreationDateAndTime
                                                              Write fDescriptor.Primary.VolumeCreationDateAndTime;
    Property  VolumeModificationDateAndTime : TVolumeDateTime
                                                              Read  fDescriptor.Primary.VolumeModificationDateAndTime
                                                              Write fDescriptor.Primary.VolumeModificationDateAndTime;
    Property  VolumeExpirationDateAndTime : TVolumeDateTime   Read  fDescriptor.Primary.VolumeExpirationDateAndTime
                                                              Write fDescriptor.Primary.VolumeExpirationDateAndTime;
    Property  VolumeEffectiveDateAndTime  : TVolumeDateTime   Read  fDescriptor.Primary.VolumeEffectiveDateAndTime
                                                              Write fDescriptor.Primary.VolumeEffectiveDateAndTime;
    Property  VolumeSetSize               : TBothEndianWord   Read  fDescriptor.Primary.VolumeSetSize
                                                              Write fDescriptor.Primary.VolumeSetSize;
    Property  VolumeSequenceNumber        : TBothEndianWord   Read  fDescriptor.Primary.VolumeSequenceNumber
                                                              Write fDescriptor.Primary.VolumeSequenceNumber;
    Property  LogicalBlockSize            : TBothEndianWord   Read  fDescriptor.Primary.LogicalBlockSize
                                                              Write fDescriptor.Primary.LogicalBlockSize;
    Property  PathTableSize               : TBothEndianDWord  Read  fDescriptor.Primary.PathTableSize
                                                              Write fDescriptor.Primary.PathTableSize;
    Property  VolumeSpaceSize             : TBothEndianDWord  Read  fDescriptor.Primary.VolumeSpaceSize
                                                              Write fDescriptor.Primary.VolumeSpaceSize;
    Property  RootDirectory               : TRootDirectoryRecord
                                                              Read  fDescriptor.Primary.RootDirectory
                                                              Write fDescriptor.Primary.RootDirectory;
    Property  LocationOfTypeLPathTable    : LongWord          Read  fDescriptor.Primary.LocationOfTypeLPathTable
                                                              Write fDescriptor.Primary.LocationOfTypeLPathTable;
    Property  LocationOfOptionalTypeLPathTable : LongWord     Read  fDescriptor.Primary.LocationOfOptionalTypeLPathTable
                                                              Write fDescriptor.Primary.LocationOfOptionalTypeLPathTable;
    Property  LocationOfTypeMPathTable    : LongWord          Read  fDescriptor.Primary.LocationOfTypeMPathTable
                                                              Write fDescriptor.Primary.LocationOfTypeMPathTable;
    Property  LocationOfOptionalTypeMPathTable : LongWord     Read  fDescriptor.Primary.LocationOfOptionalTypeMPathTable
                                                              Write fDescriptor.Primary.LocationOfOptionalTypeMPathTable;
  End;

  TSupplementaryVolumeDescriptor = Class
  Private
    Function  GetString(Const AIndex : Integer): String;
    Procedure SetString(const AIndex : Integer; Const Value: String);

  Protected
    fDescriptor : TVolumeDescriptor;

  Public
    Constructor Create; Overload; Virtual;
    Constructor Create(Const ASupplementaryVolumeDescriptor : TVolumeDescriptor); Overload; Virtual;
    Destructor  Destroy; Override;

    Procedure   Dump(AOutput : TStrings);

  Published
    Property  Descriptor : TVolumeDescriptor  Read  fDescriptor;

    Property  SystemIdentifier            : String   Index 0  Read  GetString
                                                              Write SetString;
    Property  VolumeIdentifier            : String   Index 1  Read  GetString
                                                              Write SetString;
    Property  VolumeSetIdentifier         : String   Index 2  Read  GetString
                                                              Write SetString;
    Property  PublisherIdentifier         : String   Index 3  Read  GetString
                                                              Write SetString;
    Property  DataPreparerIdentifier      : String   Index 4  Read  GetString
                                                              Write SetString;
    Property  ApplicationIdentifier       : String   Index 5  Read  GetString
                                                              Write SetString;
    Property  CopyrightFileIdentifier     : String   Index 6  Read  GetString
                                                              Write SetString;
    Property  AbstractFileIdentifier      : String   Index 7  Read  GetString
                                                              Write SetString;
    Property  BibliographicFileIdentifier : String   Index 8  Read  GetString
                                                              Write SetString;
    Property  VolumeCreationDateAndTime   : TVolumeDateTime   Read  fDescriptor.Supplementary.VolumeCreationDateAndTime
                                                              Write fDescriptor.Supplementary.VolumeCreationDateAndTime;
    Property  VolumeModificationDateAndTime : TVolumeDateTime
                                                              Read  fDescriptor.Supplementary.VolumeModificationDateAndTime
                                                              Write fDescriptor.Supplementary.VolumeModificationDateAndTime;
    Property  VolumeExpirationDateAndTime : TVolumeDateTime   Read  fDescriptor.Supplementary.VolumeExpirationDateAndTime
                                                              Write fDescriptor.Supplementary.VolumeExpirationDateAndTime;
    Property  VolumeEffectiveDateAndTime  : TVolumeDateTime   Read  fDescriptor.Supplementary.VolumeEffectiveDateAndTime
                                                              Write fDescriptor.Supplementary.VolumeEffectiveDateAndTime;
    Property  VolumeSetSize               : TBothEndianWord   Read  fDescriptor.Supplementary.VolumeSetSize
                                                              Write fDescriptor.Supplementary.VolumeSetSize;
    Property  VolumeSequenceNumber        : TBothEndianWord   Read  fDescriptor.Supplementary.VolumeSequenceNumber
                                                              Write fDescriptor.Supplementary.VolumeSequenceNumber;
    Property  LogicalBlockSize            : TBothEndianWord   Read  fDescriptor.Supplementary.LogicalBlockSize
                                                              Write fDescriptor.Supplementary.LogicalBlockSize;
    Property  PathTableSize               : TBothEndianDWord  Read  fDescriptor.Supplementary.PathTableSize
                                                              Write fDescriptor.Supplementary.PathTableSize;
    Property  VolumeSpaceSize             : TBothEndianDWord  Read  fDescriptor.Supplementary.VolumeSpaceSize
                                                              Write fDescriptor.Supplementary.VolumeSpaceSize;
    Property  RootDirectory               : TRootDirectoryRecord
                                                              Read  fDescriptor.Supplementary.RootDirectory
                                                              Write fDescriptor.Supplementary.RootDirectory;
    Property  LocationOfTypeLPathTable    : LongWord          Read  fDescriptor.Supplementary.LocationOfTypeLPathTable
                                                              Write fDescriptor.Supplementary.LocationOfTypeLPathTable;
    Property  LocationOfOptionalTypeLPathTable : LongWord     Read  fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable
                                                              Write fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable;
    Property  LocationOfTypeMPathTable    : LongWord          Read  fDescriptor.Supplementary.LocationOfTypeMPathTable
                                                              Write fDescriptor.Supplementary.LocationOfTypeMPathTable;
    Property  LocationOfOptionalTypeMPathTable : LongWord     Read  fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable
                                                              Write fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable;
    Property  VolumeFlags                      : Byte         Read  fDescriptor.Supplementary.VolumeFlags
                                                              Write fDescriptor.Supplementary.VolumeFlags;
  End;

  TBootRecordVolumeDescriptor = Class
  Private
    Function  GetString(Const AIndex : Integer): String;
    Procedure SetString(const AIndex : Integer; Const Value: String);

  Protected
    fDescriptor : TVolumeDescriptor;

  Public
    Constructor Create; Overload; Virtual;
    Constructor Create(Const ABootRecordVolumeDescriptor : TVolumeDescriptor); Overload; Virtual;
    Destructor  Destroy; Override;

    Procedure   Dump(AOutput : TStrings);

  Published
    Property  Descriptor : TVolumeDescriptor  Read  fDescriptor;

    Property  BootSystemIdentifier        : String   Index 0  Read  GetString
                                                              Write SetString;
    Property  BootIdentifier              : String   Index 1  Read  GetString
                                                              Write SetString;
    Property  BootCatalogPointer          : LongWord          Read  fDescriptor.BootRecord.BootCatalogPointer
                                                              Write fDescriptor.BootRecord.BootCatalogPointer;
  End;

Implementation

Uses
  GlobalDefs,
  ISOToolBox;

{ TPrimaryVolumeDescriptor }

Constructor TPrimaryVolumeDescriptor.Create;
Begin
  Inherited Create;

  FillChar(fDescriptor, SizeOf(fDescriptor), 0);

  fDescriptor.DescriptorType := vdtPVD;

  With fDescriptor.Primary Do
  Begin
    StandardIdentifier      := 'CD001';
    VolumeDescriptorVersion := $01;
    VolumeSetSize           := BuildBothEndianWord(1);
    ApplicationIdentifier   := 'ISOLibrary ' + coISOLibVersion;
    FileStructureVersion    := $01;
  End;
End;

Constructor TPrimaryVolumeDescriptor.Create(Const APrimaryVolumeDescriptor: TVolumeDescriptor);
Begin
  Inherited Create;

  If ( APrimaryVolumeDescriptor.DescriptorType <> vdtPVD ) Then
    Raise EVDWrongDescriptorType.Create('Descriptor type mismatch');

  fDescriptor := APrimaryVolumeDescriptor;
End;

Destructor TPrimaryVolumeDescriptor.Destroy;
Begin

  Inherited Destroy;
End;

Procedure TPrimaryVolumeDescriptor.Dump(AOutput: TStrings);
Begin
  If Assigned(AOutput) Then
  Begin
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.StandardIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'StandardIdentifier = ' +
                String(fDescriptor.Primary.StandardIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeDescriptorVersion) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeDescriptorVersion = ' +
                IntToHex( fDescriptor.Primary.VolumeDescriptorVersion,
                          SizeOf(fDescriptor.Primary.VolumeDescriptorVersion)*2) + 'h');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.SystemIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'SystemIdentifier = ' +
                String(fDescriptor.Primary.SystemIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeIdentifier = ' +
                String(fDescriptor.Primary.VolumeIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeSpaceSize) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSpaceSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.VolumeSpaceSize.LittleEndian,
                          SizeOf(fDescriptor.Primary.VolumeSpaceSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.VolumeSpaceSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.VolumeSpaceSize.BigEndian,
                          SizeOf(fDescriptor.Primary.VolumeSpaceSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.VolumeSpaceSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeSetSize) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSetSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.VolumeSetSize.LittleEndian,
                          SizeOf(fDescriptor.Primary.VolumeSetSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.VolumeSetSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.VolumeSetSize.BigEndian,
                          SizeOf(fDescriptor.Primary.VolumeSetSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.VolumeSetSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.LogicalBlockSize) - Integer(@fDescriptor), 4) + 'h ' +
                'LogicalBlockSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.LogicalBlockSize.LittleEndian,
                          SizeOf(fDescriptor.Primary.LogicalBlockSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LogicalBlockSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.LogicalBlockSize.BigEndian,
                          SizeOf(fDescriptor.Primary.LogicalBlockSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LogicalBlockSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.PathTableSize) - Integer(@fDescriptor), 4) + 'h ' +
                'PathTableSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.PathTableSize.LittleEndian,
                          SizeOf(fDescriptor.Primary.PathTableSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.PathTableSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.PathTableSize.BigEndian,
                          SizeOf(fDescriptor.Primary.PathTableSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.PathTableSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.LocationOfTypeLPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfTypeLPathTable = ' +
                IntToHex( fDescriptor.Primary.LocationOfTypeLPathTable,
                          SizeOf(fDescriptor.Primary.LocationOfTypeLPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LocationOfTypeLPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.LocationOfOptionalTypeLPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfOptionalTypeLPathTable = ' +
                IntToHex( fDescriptor.Primary.LocationOfOptionalTypeLPathTable,
                          SizeOf(fDescriptor.Primary.LocationOfOptionalTypeLPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LocationOfOptionalTypeLPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.LocationOfTypeMPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfTypeMPathTable = ' +
                IntToHex( fDescriptor.Primary.LocationOfTypeMPathTable,
                          SizeOf(fDescriptor.Primary.LocationOfTypeMPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LocationOfTypeMPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.LocationOfOptionalTypeMPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfOptionalTypeMPathTable = ' +
                IntToHex( fDescriptor.Primary.LocationOfOptionalTypeMPathTable,
                          SizeOf(fDescriptor.Primary.LocationOfOptionalTypeMPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.LocationOfOptionalTypeMPathTable) + 'd');

    // Root Directory Entry
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.LengthOfDirectoryRecord) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: LengthOfDirectoryRecord = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.LengthOfDirectoryRecord,
                          SizeOf(fDescriptor.Primary.RootDirectory.LengthOfDirectoryRecord)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.LengthOfDirectoryRecord) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.ExtendedAttributeRecordLength) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: ExtendedAttributeRecordLength = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.ExtendedAttributeRecordLength,
                          SizeOf(fDescriptor.Primary.RootDirectory.ExtendedAttributeRecordLength)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.ExtendedAttributeRecordLength) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.LocationOfExtent) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: LocationOfExtent = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.LocationOfExtent.LittleEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.LocationOfExtent.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.LocationOfExtent.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.LocationOfExtent.BigEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.LocationOfExtent.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.LocationOfExtent.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.DataLength) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: DataLength = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.DataLength.LittleEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.DataLength.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.DataLength.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.DataLength.BigEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.DataLength.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.DataLength.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.FileFlags) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: FileFlags = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.FileFlags,
                          SizeOf(fDescriptor.Primary.RootDirectory.FileFlags)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.FileFlags ) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.FileUnitSize) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: FileUnitSize = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.FileUnitSize,
                          SizeOf(fDescriptor.Primary.RootDirectory.FileUnitSize)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.FileUnitSize) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.InterleaveGapSize) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: InterleaveGapSize = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.InterleaveGapSize,
                          SizeOf(fDescriptor.Primary.RootDirectory.InterleaveGapSize)*2) + 'h '+
                IntToStr( fDescriptor.Primary.RootDirectory.InterleaveGapSize) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.VolumeSequenceNumber) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: VolumeSequenceNumber = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.LittleEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.BigEndian,
                          SizeOf(fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.VolumeSequenceNumber.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.LengthOfFileIdentifier) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: LengthOfFileIdentifier = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.LengthOfFileIdentifier,
                          SizeOf(fDescriptor.Primary.RootDirectory.LengthOfFileIdentifier)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.LengthOfFileIdentifier) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.RootDirectory.FileIdentifier) - Integer(@fDescriptor.Primary.RootDirectory), 4) + 'h ' +
                'RD: FileIdentifier = ' +
                IntToHex( fDescriptor.Primary.RootDirectory.FileIdentifier,
                          SizeOf(fDescriptor.Primary.RootDirectory.FileIdentifier)*2) + 'h ' +
                IntToStr( fDescriptor.Primary.RootDirectory.FileIdentifier) + 'd');

    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeSetIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSetIdentifier = ' +
                String(fDescriptor.Primary.VolumeSetIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.PublisherIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'PublisherIdentifier = ' +
                String(fDescriptor.Primary.PublisherIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.DataPreparerIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'DataPreparerIdentifier = ' +
                String(fDescriptor.Primary.DataPreparerIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.ApplicationIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'ApplicationIdentifier = ' +
                String(fDescriptor.Primary.ApplicationIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.CopyrightFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'CopyrightFileIdentifier = ' +
                String(fDescriptor.Primary.CopyrightFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.AbstractFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'AbstractFileIdentifier = ' +
                String(fDescriptor.Primary.AbstractFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.BibliographicFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'BibliographicFileIdentifier = ' +
                String(fDescriptor.Primary.BibliographicFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeCreationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeCreationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Primary.VolumeCreationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeModificationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeModificationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Primary.VolumeModificationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeExpirationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeExpirationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Primary.VolumeExpirationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.VolumeEffectiveDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'h VolumeEffectiveDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Primary.VolumeEffectiveDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Primary.FileStructureVersion) - Integer(@fDescriptor), 4) + 'h ' +
                'FileStructureVersion = ' +
                IntToHex(fDescriptor.Primary.FileStructureVersion, 2) + 'h ' +
                IntToStr(fDescriptor.Primary.FileStructureVersion) + 'd');
  End;
End;

Function TPrimaryVolumeDescriptor.GetString(Const AIndex : Integer): String;
Begin
  Case AIndex Of
    0 : Result := fDescriptor.Primary.SystemIdentifier;
    1 : Result := fDescriptor.Primary.VolumeIdentifier;
    2 : Result := fDescriptor.Primary.VolumeSetIdentifier;
    3 : Result := fDescriptor.Primary.PublisherIdentifier;
    4 : Result := fDescriptor.Primary.DataPreparerIdentifier;
    5 : Result := fDescriptor.Primary.ApplicationIdentifier;
    6 : Result := fDescriptor.Primary.CopyrightFileIdentifier;
    7 : Result := fDescriptor.Primary.AbstractFileIdentifier;
    8 : Result := fDescriptor.Primary.BibliographicFileIdentifier;
  End;
End;

Procedure TPrimaryVolumeDescriptor.SetString(Const AIndex: Integer; Const Value: String);
Begin
  // Since StrPCopy() is the easiest method to fill in a array of char, we use it
  // here, but we have to care about the length of the record, because StrPCopy()
  // will copy the given string completly, overwriting the following fields...

  Case AIndex Of
    0 : StrPCopy(fDescriptor.Primary.SystemIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.SystemIdentifier)));
    1 : StrPCopy(fDescriptor.Primary.VolumeIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.VolumeIdentifier)));
    2 : StrPCopy(fDescriptor.Primary.VolumeSetIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.VolumeSetIdentifier)));
    3 : StrPCopy(fDescriptor.Primary.PublisherIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.PublisherIdentifier)));
    4 : StrPCopy(fDescriptor.Primary.DataPreparerIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.DataPreparerIdentifier)));
    5 : StrPCopy(fDescriptor.Primary.ApplicationIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.ApplicationIdentifier)));
    6 : StrPCopy(fDescriptor.Primary.CopyrightFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.CopyrightFileIdentifier)));
    7 : StrPCopy(fDescriptor.Primary.AbstractFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.AbstractFileIdentifier)));
    8 : StrPCopy(fDescriptor.Primary.BibliographicFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Primary.BibliographicFileIdentifier)));
  End;
End;

{ TSupplementaryVolumeDescriptor }

Constructor TSupplementaryVolumeDescriptor.Create;
Begin
  Inherited Create;

  FillChar(fDescriptor, SizeOf(fDescriptor), 0);

  fDescriptor.DescriptorType := vdtSVD;

  With fDescriptor.Supplementary Do
  Begin
    StandardIdentifier      := 'CD001';
    VolumeDescriptorVersion := $01;
    VolumeSetSize           := BuildBothEndianWord(1);
    ApplicationIdentifier   := 'ISOLibrary ' + coISOLibVersion;
    FileStructureVersion    := $01;
  End;
End;

Constructor TSupplementaryVolumeDescriptor.Create(Const ASupplementaryVolumeDescriptor: TVolumeDescriptor);
Begin
  Inherited Create;

  If ( ASupplementaryVolumeDescriptor.DescriptorType <> vdtSVD ) Then
    Raise EVDWrongDescriptorType.Create('Descriptor type mismatch');

  fDescriptor := ASupplementaryVolumeDescriptor;
End;

Destructor TSupplementaryVolumeDescriptor.Destroy;
Begin

  Inherited;
End;

Procedure TSupplementaryVolumeDescriptor.Dump(AOutput: TStrings);
Begin
  If Assigned(AOutput) Then
  Begin
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.StandardIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'StandardIdentifier = ' +
                String(fDescriptor.Supplementary.StandardIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeDescriptorVersion) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeDescriptorVersion = ' +
                IntToHex( fDescriptor.Supplementary.VolumeDescriptorVersion,
                          SizeOf(fDescriptor.Supplementary.VolumeDescriptorVersion)*2) + 'h');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeFlags) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeFlags = ' +
                IntToHex(fDescriptor.Supplementary.VolumeFlags, 2) + 'h ' +
                IntToStr(fDescriptor.Supplementary.VolumeFlags) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.SystemIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'SystemIdentifier = ' +
                String(fDescriptor.Supplementary.SystemIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeIdentifier = ' +
                String(fDescriptor.Supplementary.VolumeIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeSpaceSize) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSpaceSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.VolumeSpaceSize.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.VolumeSpaceSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.VolumeSpaceSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.VolumeSpaceSize.BigEndian,
                          SizeOf(fDescriptor.Supplementary.VolumeSpaceSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.VolumeSpaceSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeSetSize) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSetSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.VolumeSetSize.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.VolumeSetSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.VolumeSetSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.VolumeSetSize.BigEndian,
                          SizeOf(fDescriptor.Supplementary.VolumeSetSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.VolumeSetSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.LogicalBlockSize) - Integer(@fDescriptor), 4) + 'h ' +
                'LogicalBlockSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.LogicalBlockSize.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.LogicalBlockSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LogicalBlockSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.LogicalBlockSize.BigEndian,
                          SizeOf(fDescriptor.Supplementary.LogicalBlockSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LogicalBlockSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.PathTableSize) - Integer(@fDescriptor), 4) + 'h ' +
                'PathTableSize = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.PathTableSize.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.PathTableSize.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.PathTableSize.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.PathTableSize.BigEndian,
                          SizeOf(fDescriptor.Supplementary.PathTableSize.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.PathTableSize.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.LocationOfTypeLPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfTypeLPathTable = ' +
                IntToHex( fDescriptor.Supplementary.LocationOfTypeLPathTable,
                          SizeOf(fDescriptor.Supplementary.LocationOfTypeLPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LocationOfTypeLPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfOptionalTypeLPathTable = ' +
                IntToHex( fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable,
                          SizeOf(fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LocationOfOptionalTypeLPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.LocationOfTypeMPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfTypeMPathTable = ' +
                IntToHex( fDescriptor.Supplementary.LocationOfTypeMPathTable,
                          SizeOf(fDescriptor.Supplementary.LocationOfTypeMPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LocationOfTypeMPathTable) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable) - Integer(@fDescriptor), 4) + 'h ' +
                'LocationOfOptionalTypeMPathTable = ' +
                IntToHex( fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable,
                          SizeOf(fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.LocationOfOptionalTypeMPathTable) + 'd');

    // Root Directory Entry
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.LengthOfDirectoryRecord) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: LengthOfDirectoryRecord = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.LengthOfDirectoryRecord,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.LengthOfDirectoryRecord)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.LengthOfDirectoryRecord) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.ExtendedAttributeRecordLength) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: ExtendedAttributeRecordLength = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.ExtendedAttributeRecordLength,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.ExtendedAttributeRecordLength)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.ExtendedAttributeRecordLength) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.LocationOfExtent) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: LocationOfExtent = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.LocationOfExtent.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.LocationOfExtent.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.LocationOfExtent.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.LocationOfExtent.BigEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.LocationOfExtent.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.LocationOfExtent.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.DataLength) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: DataLength = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.DataLength.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.DataLength.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.DataLength.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.DataLength.BigEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.DataLength.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.DataLength.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.FileFlags) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: FileFlags = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.FileFlags,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.FileFlags)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.FileFlags ) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.FileUnitSize) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: FileUnitSize = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.FileUnitSize,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.FileUnitSize)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.FileUnitSize) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.InterleaveGapSize) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: InterleaveGapSize = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.InterleaveGapSize,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.InterleaveGapSize)*2) + 'h '+
                IntToStr( fDescriptor.Supplementary.RootDirectory.InterleaveGapSize) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: VolumeSequenceNumber = ' +
                'Intel: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.LittleEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.LittleEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.LittleEndian) + 'd ' +
                'Motorola: ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.BigEndian,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.BigEndian)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.VolumeSequenceNumber.BigEndian) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.LengthOfFileIdentifier) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: LengthOfFileIdentifier = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.LengthOfFileIdentifier,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.LengthOfFileIdentifier)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.LengthOfFileIdentifier) + 'd');
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.RootDirectory.FileIdentifier) - Integer(@fDescriptor.Supplementary.RootDirectory), 4) + 'h ' +
                'RD: FileIdentifier = ' +
                IntToHex( fDescriptor.Supplementary.RootDirectory.FileIdentifier,
                          SizeOf(fDescriptor.Supplementary.RootDirectory.FileIdentifier)*2) + 'h ' +
                IntToStr( fDescriptor.Supplementary.RootDirectory.FileIdentifier) + 'd');

    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeSetIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeSetIdentifier = ' +
                String(fDescriptor.Supplementary.VolumeSetIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.PublisherIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'PublisherIdentifier = ' +
                String(fDescriptor.Supplementary.PublisherIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.DataPreparerIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'DataPreparerIdentifier = ' +
                String(fDescriptor.Supplementary.DataPreparerIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.ApplicationIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'ApplicationIdentifier = ' +
                String(fDescriptor.Supplementary.ApplicationIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.CopyrightFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'CopyrightFileIdentifier = ' +
                String(fDescriptor.Supplementary.CopyrightFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.AbstractFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'AbstractFileIdentifier = ' +
                String(fDescriptor.Supplementary.AbstractFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.BibliographicFileIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'BibliographicFileIdentifier = ' +
                String(fDescriptor.Supplementary.BibliographicFileIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeCreationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeCreationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Supplementary.VolumeCreationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeModificationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeModificationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Supplementary.VolumeModificationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeExpirationDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'VolumeExpirationDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Supplementary.VolumeExpirationDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.VolumeEffectiveDateAndTime) - Integer(@fDescriptor), 4) + 'h ' +
                'h VolumeEffectiveDateAndTime = ' +
                VolumeDateTimeToStr(fDescriptor.Supplementary.VolumeEffectiveDateAndTime));
    AOutput.Add(IntToHex(Integer(@fDescriptor.Supplementary.FileStructureVersion) - Integer(@fDescriptor), 4) + 'h ' +
                'FileStructureVersion = ' +
                IntToHex(fDescriptor.Supplementary.FileStructureVersion, 2) + 'h ' +
                IntToStr(fDescriptor.Supplementary.FileStructureVersion) + 'd');
  End;
End;

Function TSupplementaryVolumeDescriptor.GetString(Const AIndex: Integer): String;
Begin
  Case AIndex Of
    0 : Result := fDescriptor.Supplementary.SystemIdentifier;
    1 : Result := fDescriptor.Supplementary.VolumeIdentifier;
    2 : Result := fDescriptor.Supplementary.VolumeSetIdentifier;
    3 : Result := fDescriptor.Supplementary.PublisherIdentifier;
    4 : Result := fDescriptor.Supplementary.DataPreparerIdentifier;
    5 : Result := fDescriptor.Supplementary.ApplicationIdentifier;
    6 : Result := fDescriptor.Supplementary.CopyrightFileIdentifier;
    7 : Result := fDescriptor.Supplementary.AbstractFileIdentifier;
    8 : Result := fDescriptor.Supplementary.BibliographicFileIdentifier;
  End;
End;

Procedure TSupplementaryVolumeDescriptor.SetString(Const AIndex: Integer; Const Value: String);
Begin
  // Since StrPCopy() is the easiest method to fill in a array of char, we use it
  // here, but we have to care about the length of the record, because StrPCopy()
  // will copy the given string completly, overwriting the following fields...

  Case AIndex Of
    0 : StrPCopy(fDescriptor.Supplementary.SystemIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.SystemIdentifier)));
    1 : StrPCopy(fDescriptor.Supplementary.VolumeIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.VolumeIdentifier)));
    2 : StrPCopy(fDescriptor.Supplementary.VolumeSetIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.VolumeSetIdentifier)));
    3 : StrPCopy(fDescriptor.Supplementary.PublisherIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.PublisherIdentifier)));
    4 : StrPCopy(fDescriptor.Supplementary.DataPreparerIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.DataPreparerIdentifier)));
    5 : StrPCopy(fDescriptor.Supplementary.ApplicationIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.ApplicationIdentifier)));
    6 : StrPCopy(fDescriptor.Supplementary.CopyrightFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.CopyrightFileIdentifier)));
    7 : StrPCopy(fDescriptor.Supplementary.AbstractFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.AbstractFileIdentifier)));
    8 : StrPCopy(fDescriptor.Supplementary.BibliographicFileIdentifier,
                  Copy(Value, 1, Length(fDescriptor.Supplementary.BibliographicFileIdentifier)));
  End;
End;

{ TBootRecordVolumeDescriptor }

Constructor TBootRecordVolumeDescriptor.Create;
Begin
  Inherited Create;

  FillChar(fDescriptor, SizeOf(fDescriptor), 0);

  fDescriptor.DescriptorType := vdtBR;

  With fDescriptor.BootRecord Do
  Begin
    StandardIdentifier      := 'CD001';
    VersionOfDescriptor     := $01;
  End;
End;

Constructor TBootRecordVolumeDescriptor.Create(Const ABootRecordVolumeDescriptor: TVolumeDescriptor);
Begin
  Inherited Create;

  If ( ABootRecordVolumeDescriptor.DescriptorType <> vdtBR ) Then
    Raise EVDWrongDescriptorType.Create('Descriptor type mismatch');

  fDescriptor := ABootRecordVolumeDescriptor;
End;

Destructor TBootRecordVolumeDescriptor.Destroy;
Begin

  Inherited;
End;

Procedure TBootRecordVolumeDescriptor.Dump(AOutput: TStrings);
Begin
  If Assigned(AOutput) Then
  Begin
    AOutput.Add(IntToHex(Integer(@fDescriptor.BootRecord.StandardIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'StandardIdentifier = ' +
                String(fDescriptor.BootRecord.StandardIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.BootRecord.VersionOfDescriptor) - Integer(@fDescriptor), 4) + 'h ' +
                'VersionOfDescriptor = ' +
                IntToHex( fDescriptor.BootRecord.VersionOfDescriptor,
                          SizeOf(fDescriptor.BootRecord.VersionOfDescriptor)*2) + 'h');
    AOutput.Add(IntToHex(Integer(@fDescriptor.BootRecord.BootSystemIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'BootSystemIdentifier = ' +
                String(fDescriptor.BootRecord.BootSystemIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.BootRecord.BootIdentifier) - Integer(@fDescriptor), 4) + 'h ' +
                'BootIdentifier = ' +
                String(fDescriptor.BootRecord.BootIdentifier));
    AOutput.Add(IntToHex(Integer(@fDescriptor.BootRecord.BootCatalogPointer) - Integer(@fDescriptor), 4) + 'h ' +
                'BootCatalogPointer = ' +
                IntToHex( fDescriptor.BootRecord.BootCatalogPointer,
                          SizeOf(fDescriptor.BootRecord.BootCatalogPointer)*2) + 'h ' +
                IntToStr( fDescriptor.BootRecord.BootCatalogPointer) + 'd');
  End;
End;

Function TBootRecordVolumeDescriptor.GetString(Const AIndex: Integer): String;
Begin
  Case AIndex Of
    0 : Result := fDescriptor.BootRecord.BootSystemIdentifier;
    1 : Result := fDescriptor.BootRecord.BootIdentifier;
  End;
End;

Procedure TBootRecordVolumeDescriptor.SetString(Const AIndex: Integer; Const Value: String);
Begin
  // Since StrPCopy() is the easiest method to fill in a array of char, we use it
  // here, but we have to care about the length of the record, because StrPCopy()
  // will copy the given string completly, overwriting the following fields...

  Case AIndex Of
    0 : StrPCopy(fDescriptor.BootRecord.BootSystemIdentifier,
                  Copy(Value, 1, Length(fDescriptor.BootRecord.BootSystemIdentifier)));
    1 : StrPCopy(fDescriptor.BootRecord.BootIdentifier,
                  Copy(Value, 1, Length(fDescriptor.BootRecord.BootIdentifier)));
  End;
End;

End.

//  Log List
//
// $Log: VolumeDescriptors.pas,v $
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//
//

