//
//  TISOImage - SCSI structure definitions
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOSCSIStructs.pas,v 1.5 2004/07/15 21:09:16 nalilord Exp $
//

Unit ISOSCSIStructs;

Interface

Uses
  Windows,
  ISOSCSIConsts;

Type
  TSendASPI32Command      = Function(Cmd:Pointer): LongWord; Cdecl;
  TGetASPI32SupportInfo   = Function: LongWord; Cdecl;
  TGetASPI32Buffer        = Function(Buffer:Pointer): LongWord; Cdecl;
  TFreeASPI32Buffer       = Function(Buffer:Pointer): Boolean; Cdecl;
  TTranslateASPI32Address = Function(Path:Pointer;DevNode:Pointer): Boolean; Cdecl;

  SRB_HAInquiry = Packed Record
    SRB_Cmd       : Byte; // ASPI command code = SC_HA_INQUIRY
    SRB_Status    : Byte; // ASPI command status byte
    SRB_HaId      : Byte; // ASPI host adapter number
    SRB_Flags     : Byte; // ASPI request flags
    SRB_Hdr_Rsvd  : DWORD; // Reserved, MUST = 0
    HA_Count      : Byte; // Number of host adapters present
    HA_SCSI_ID    : Byte; // SCSI ID of host adapter
    HA_ManagerId  : Array[0..15] of Byte; // String describing the manager
    HA_Identifier : Array[0..15] of Byte; // String describing the host adapter
    HA_Unique     : Array[0..15] of Byte; // Host Adapter Unique parameters
    HA_Rsvd1      : Word;
  End;

  PSRB_HAInquiry = ^SRB_HAInquiry;
  TSRB_HAInquiry = SRB_HAInquiry;

  SRB_GDEVBlock = Packed Record
    SRB_Cmd         : Byte; // ASPI command code = SC_GET_DEV_TYPE
    SRB_Status      : Byte; // ASPI command status byte
    SRB_HaId        : Byte; // ASPI host adapter number
    SRB_Flags       : Byte; // Reserved
    SRB_Hdr_Rsvd    : DWORD; // Reserved
    SRB_Target      : Byte; // Target's SCSI ID
    SRB_Lun         : Byte; // Target's LUN number
    SRB_DeviceType  : Byte; // Target's peripheral device type
    SRB_Rsvd1       : Byte;
  End;

  TSRB_GDEVBlock = SRB_GDEVBlock;
  PSRB_GDEVBlock = ^SRB_GDEVBlock;

  SRB_ExecSCSICmd = Packed Record
    SRB_Cmd         : Byte; // ASPI command code = SC_EXEC_SCSI_CMD
    SRB_Status      : Byte; // ASPI command status byte
    SRB_HaId        : Byte; // ASPI host adapter number
    SRB_Flags       : Byte; // ASPI request flags
    SRB_Hdr_Rsvd    : DWORD; // Reserved
    SRB_Target      : Byte; // Target's SCSI ID
    SRB_Lun         : Byte; // Target's LUN number
    SRB_Rsvd1       : Word; // Reserved for Alignment
    SRB_BufLen      : DWORD; // Data Allocation Length
    SRB_BufPointer  : Pointer; // Data Buffer Pointer
    SRB_SenseLen    : Byte; // Sense Allocation Length
    SRB_CDBLen      : Byte; // CDB Length
    SRB_HaStat      : Byte; // Host Adapter Status
    SRB_TargStat    : Byte; // Target Status
    SRB_PostProc    : Pointer; // Post routine
    SRB_Rsvd2       : Pointer; // Reserved
    SRB_Rsvd3       : Array[0..15] of Byte; // Reserved for alignment
    CDBByte         : Array[0..15] of Byte; // SCSI CDB
    SenseArea       : Array[0..SENSE_LEN + 1] of Byte; // Request Sense buffer
  End;

  TSRB_ExecSCSICmd = SRB_ExecSCSICmd;
  PSRB_ExecSCSICmd = ^SRB_ExecSCSICmd;

  SRB_Abort = Packed Record
    SRB_Cmd       : Byte; // ASPI command code = SC_EXEC_SCSI_CMD
    SRB_Status    : Byte; // ASPI command status byte
    SRB_HaId      : Byte; // ASPI host adapter number
    SRB_Flags     : Byte; // Reserved
    SRB_Hdr_Rsvd  : DWORD; // Reserved
    SRB_ToAbort   : Pointer; // Pointer to SRB to abort
  End;

  TSRB_Abort = SRB_Abort;
  PSRB_Abort = ^SRB_Abort;

  SRB_BusDeviceReset = Packed Record
    SRB_Cmd       : Byte; // ASPI command code = SC_EXEC_SCSI_CMD
    SRB_Status    : Byte; // ASPI command status byte
    SRB_HaId      : Byte; // ASPI host adapter number
    SRB_Flags     : Byte; // Reserved
    SRB_Hdr_Rsvd  : DWORD; // Reserved
    SRB_Target    : Byte; // Target's SCSI ID
    SRB_Lun       : Byte; // Target's LUN number
    SRB_Rsvd1     : Array[0..11] of Byte; // Reserved for Alignment
    SRB_HaStat    : Byte; // Host Adapter Status
    SRB_TargStat  : Byte; // Target Status
    SRB_PostProc  : Pointer; // Post routine
    SRB_Rsvd2     : Pointer; // Reserved
    SRB_Rsvd3     : Array[0..15] of Byte; // Reserved
    CDBByte       : Array[0..15] of Byte; // SCSI CDB
  End;

  TSRB_BusDeviceReset = SRB_BusDeviceReset;
  PSRB_BusDeviceReset = ^SRB_BusDeviceReset;

  SRB_GetDiskInfo = Packed Record
    SRB_Cmd             : Byte; // ASPI command code = SC_EXEC_SCSI_CMD
    SRB_Status          : Byte; // ASPI command status byte
    SRB_HaId            : Byte; // ASPI host adapter number
    SRB_Flags           : Byte; // Reserved
    SRB_Hdr_Rsvd        : DWORD; // Reserved
    SRB_Target          : Byte; // Target's SCSI ID
    SRB_Lun             : Byte; // Target's LUN number
    SRB_DriveFlags      : Byte; // Driver flags
    SRB_Int13HDriveInfo : Byte; // Host Adapter Status
    SRB_Heads           : Byte; // Preferred number of heads translation
    SRB_Sectors         : Byte; // Preferred number of sectors translation
    SRB_Rsvd1           : Array[0..9] of Byte; // Reserved
  End;

  TSRB_GetDiskInfo = SRB_GetDiskInfo;
  PSRB_GetDiskInfo = ^SRB_GetDiskInfo;

  SRB_RescanPort = Packed Record
    SRB_Cmd       :Byte; // 00/000 ASPI command code = SC_RESCAN_SCSI_BUS
    SRB_Status    :Byte; // 01/001 ASPI command status byte
    SRB_HaId      :Byte; // 02/002 ASPI host adapter number
    SRB_Flags     :Byte; // 03/003 Reserved, MUST = 0
    SRB_Hdr_Rsvd  : DWORD; // 04/004 Reserved, MUST = 0
  End;

  TSRB_RescanPort = SRB_RescanPort;
  PSRB_RescanPort = ^SRB_RescanPort;

  SRB_GetSetTimeouts = Packed Record
    SRB_Cmd       : Byte; // 00/000 ASPI command code = SC_GETSET_TIMEOUTS
    SRB_Status    : Byte; // 01/001 ASPI command status byte
    SRB_HaId      : Byte; // 02/002 ASPI host adapter number
    SRB_Flags     : Byte; // 03/003 ASPI request flags
    SRB_Hdr_Rsvd  : DWORD; // 04/004 Reserved, MUST = 0
    SRB_Target    : Byte; // 08/008 Target's SCSI ID
    SRB_Lun       : Byte; // 09/009 Target's LUN number
    SRB_Timeout   : DWORD; // 0A/010 Timeout in half seconds
  End;

  TSRB_GetSetTimeouts = SRB_GetSetTimeouts;
  PSRB_GetSetTimeouts = ^SRB_GetSetTimeouts;

  ASPI32BUFF = Packed Record
    AB_BufPointer : Pointer; // 00/000 Pointer to the ASPI allocated buffer
    AB_BufLen     : DWORD; // 04/004 Length in bytes of the buffer
    AB_ZeroFill   : DWORD; // 08/008 Flag set to 1 if buffer should be zeroed
    AB_Reserved   : DWORD; // 0C/012 Reserved
  End;

  TASPI32BUFF = ASPI32BUFF;
  PASPI32BUFF = ^ASPI32BUFF;

  TSenseData = Packed Record
    ErrorCode     : Byte;                   // Error Code (70H or 71H)
    SegmentNum    : Byte;                   // Number of current segment descriptor
    SenseKey      : Byte;                   // Sense Key(See bit definitions too)
    InfoByte0     : Byte;                   // Information MSB
    InfoByte1     : Byte;                   // Information MID
    InfoByte2     : Byte;                   // Information MID
    InfoByte3     : Byte;                   // Information LSB
    AddSenLen     : Byte;                   // Additional Sense Length
    ComSpecInf0   : Byte;                   // Command Specific Information MSB
    ComSpecInf1   : Byte;                   // Command Specific Information MID
    ComSpecInf2   : Byte;                   // Command Specific Information MID
    ComSpecInf3   : Byte;                   // Command Specific Information LSB
    AddSenseCode  : Byte;                   // Additional Sense Code
    AddSenQual    : Byte;                   // Additional Sense Code Qualifier
    FieldRepUCode : Byte;                   // Field Replaceable Unit Code
    SenKeySpec15  : Byte;                   // Sense Key Specific 15th byte
    SenKeySpec16  : Byte;                   // Sense Key Specific 16th byte
    SenKeySpec17  : Byte;                   // Sense Key Specific 17th byte
    AddSenseBytes : Array[18..31] of Byte;  // Additional Sense Bytes
  End;

  TASPI32Buffer = Packed Record
    AB_BufPointer : Pointer;
    AB_BufLen     : LongInt;
    AB_ZeroFill   : LongInt;
    AB_Reserved   : LongInt;
  End;

  TSCSIDrive = Packed Record
    HA            : Byte;
    Target        : Byte;
    LUN           : Byte;
    Drive         : Byte;
    Used          : Boolean;
    DeviceHandle  : THandle;
    Data          : Array[0..64] of Char;
  End;

  TSCSIDrives = Packed Record
    NumAdapters : Byte;
    Drive       : Array[0..26] of TSCSIDrive;
  End;

  SCSI_ADDRESS = Packed Record
    Length      : Cardinal;
    PortNumber  : Byte;
    PathId      : Byte;
    TargetId    : Byte;
    Lun         : Byte;
  End;

  TDeviceConfigHeader = Packed Record
    DataLength        : Cardinal;
    Reserved          : Word;
    CurrentProfile    : Word;
    FeatureCode       : Word;
    Version           : Byte;
    AdditionalLength  : Byte;
    OtherData         : Array[0..101] of Byte;
  End;

  TTOCData0000 = Packed Record
    DataLength        : Word;
    FirstTrackNumber  : Byte;
    LastTrackNumber   : Byte;
    Reserved1         : Byte;
    ADR_CONTROL       : Byte;
    TrackNumber       : Byte;
    Reserved3         : Byte;
    TrackStartAddress : Cardinal;
  end;

  TTOCData0001 = Packed Record
    DataLength                            : Word;
    FirstTrackNumber                      : Byte;
    LastTrackNumber                       : Byte;
    Reserved1                             : Byte;
    ADR_CONTROL                           : Byte;
    FirstTrackNumberInLastCompleteSession : Byte;
    Reserved3                             : Byte;
    StartAddressOfFirstTrackInLastSession : Cardinal;
  end;

  TTOCData0010 = Packed Record
    DataLength        : Word;
    FirstTrackNumber  : Byte;
    LastTrackNumber   : Byte;
    SessionNumberHex  : Byte;
    ADR_CONTROL       : Byte;
    TNO               : Byte;
    POINT             : Byte;
    MIN               : Byte;
    SEC               : Byte;
    FRAME             : Byte;
    ZERO_HOUR_PHOUR   : Byte;
    PMIN              : Byte;
    PSEC              : Byte;
    PFRAME            : Byte;
  end;

  TTOCData0011 = Packed Record
    DataLength        : Word;
    FirstTrackNumber  : Byte;
    LastTrackNumber   : Byte;
    Reserved          : Byte;
    ADR_CONTROL       : Byte;
    TNO               : Byte;
    POINT             : Byte;
    MIN               : Byte;
    SEC               : Byte;
    FRAME             : Byte;
    ZERO_HOUR_PHOUR   : Byte;
    PMIN              : Byte;
    PSEC              : Byte;
    PFRAME            : Byte;
  end;

  TTOCData0100 = Packed Record
    DataLength                                        : Word;
    Reserved1                                         : Byte;
    Reserved2                                         : Byte;
    IndicativeTargetWritingPower_DDCD_ReferenceSpeed  : Byte;
    URU                                               : Byte;
    DiscType_DiscSubType_A1Valid_A2Valid_A3Valid      : Byte;
    Reserved3                                         : Byte;
    ATIPStartTimeOfLeadIn_Min                         : Byte;
    ATIPStartTimeOfLeadIn_Sec                         : Byte;
    ATIPStartTimeOfLeadIn_Frame                       : Byte;
    Reserved4                                         : Byte;
    ATIPStartTimeOfLeadOut_Min                        : Byte;
    ATIPStartTimeOfLeadOut_Sec                        : Byte;
    ATIPStartTimeOfLeadOut_Frame                      : Byte;
    Reserved5                                         : Byte;
    A1Values                                          : Array [0..2] of Byte;
    Reserved6                                         : Byte;
    A2Values                                          : Array [0..2] of Byte;
    Reserved7                                         : Byte;
    A3Values                                          : Array [0..2] of Byte;
    Reserved8                                         : Byte;
    S4Values                                          : Array [0..2] of Byte;
    Reserved9                                         : Byte;
  end;

  TTOCData0101 = Packed Record
    DataLength  : Word;
    Reserved1   : Byte;
    Reserved2   : Byte;
    Data        : Array [0..17] of Byte;
  end;

  TTrackInformation = Packed Record
    DataLength           : Word;
    TrackNumber          : Byte;
    SessionNumber        : Byte;
    Reserved             : Byte;
    TrackMode            : Byte;
    DataMode             : Byte;
    Reserved2            : Byte;
    TrackStartAddress    : LongWord;
    NextWritableAddress  : LongWord;
    FreeBlocks           : LongWord;
    FixedPacketSize      : LongWord;
    TrackSize            : LongWord;
    LastRecordedAddress  : LongWord;
    TrackNumber2         : Byte;
    SessionNumber2       : Byte;
    Reserved3            : Byte;
    Reserved4            : Byte;
    Reserved5            : Byte;
    Reserved6            : Byte;
  End;

  TFormattableCD = Packed Record
    NumberOfBlocks        : Cardinal;
    FormatType            : Byte;
    TypeDependentParamter : Array [0..2] of Byte;
  End;

  TCapacityListHeader = Packed Record
    Reserved1           : Byte;
    Reserved2           : Byte;
    Reserved3           : Byte;
    CapacityListLength  : Byte;
  end;

  TCurrentMaximumCapacityDescriptor = Packed Record
    NumberOfBlocks      : Cardinal;
    DescriptorType      : Byte;
    BlockLength         : Array [0..2] of Byte;
  end;

  TFormatCapacity = Packed Record
    CapacityListHeader  : TCapacityListHeader;
    CapacityDescriptor  : TCurrentMaximumCapacityDescriptor;
    FormattableCD       : Array [0..32] of TFormattableCD;
    Unused              : Byte;
  End;

  PSCSI_PASS_THROUGH = ^SCSI_PASS_THROUGH;
  SCSI_PASS_THROUGH = Record
    Length              : Word;
    ScsiStatus          : Byte;
    PathId              : Byte;
    TargetId            : Byte;
    Lun                 : Byte;
    CdbLength           : Byte;
    SenseInfoLength     : Byte;
    DataIn              : Byte;
    DataTransferLength  : ULONG;
    TimeOutValue        : ULONG;
    DataBufferOffset    : ULONG;
    SenseInfoOffset     : ULONG;
    Cdb                 : Array[0..15] of Byte;
  End;

  PSCSI_PASS_THROUGH_DIRECT = ^SCSI_PASS_THROUGH_DIRECT;
  SCSI_PASS_THROUGH_DIRECT = Record
    Length              : Word;
    ScsiStatus          : Byte;
    PathId              : Byte;
    TargetId            : Byte;
    Lun                 : Byte;
    CdbLength           : Byte;
    SenseInfoLength     : Byte;
    DataIn              : Byte;
    DataTransferLength  : ULONG;
    TimeOutValue        : ULONG;
    DataBuffer          : Pointer;
    SenseInfoOffset     : ULONG;
    Cdb                 : Array[0..15] of Byte;
  End;

  PSCSI_PASS_THROUGH_DIRECT_WITH_BUFFER = ^SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER;
  SCSI_PASS_THROUGH_DIRECT_WITH_BUFFER = Record
    Spt      : SCSI_PASS_THROUGH_DIRECT;
    Filler   : ULONG;
    SenseBuf : Array[0..31] of Byte;
  End;

  SENSE_DATA_FMT = Packed Record
    ErrorCode     : Byte; // Error Code (70H or 71H)End;
    SegmentNum    : Byte; // Number of current segment descriptor
    SenseKey      : Byte; // Sense Key(See bit definitions too)
    InfoByte0     : Byte; // Information MSB
    InfoByte1     : Byte; // Information MID
    InfoByte2     : Byte; // Information MID
    InfoByte3     : Byte; // Information LSB
    AddSenLen     : Byte; // Additional Sense Length
    ComSpecInf0   : Byte; // Command Specific Information MSB
    ComSpecInf1   : Byte; // Command Specific Information MID
    ComSpecInf2   : Byte; // Command Specific Information MID
    ComSpecInf3   : Byte; // Command Specific Information LSB
    AddSenseCode  : Byte; // Additional Sense Code
    AddSenQual    : Byte; // Additional Sense Code Qualifier
    FieldRepUCode : Byte; // Field Replaceable Unit Code
    SenKeySpec15  : Byte; // Sense Key Specific 15th byte
    SenKeySpec16  : Byte; // Sense Key Specific 16th byte
    SenKeySpec17  : Byte; // Sense Key Specific 17th byte
    AddSenseBytes : Byte; // Additional Sense Bytes
  End;

  TSENSE_DATA_FMT = SENSE_DATA_FMT;
  PSENSE_DATA_FMT = ^SENSE_DATA_FMT;

  SCSI_INQUIRY_DATA_RESULT = Packed Record
    Peripheral          : Byte;
    RMB                 : Byte;
    Version             : Byte;
    InterfaceDependent1 : Byte;
    AdditionalLength    : Byte;
    InterfaceDependent2 : Byte;
    InterfaceDependent3 : Byte;
    InterfaceDependent4 : Byte;
    VendorId            : Array [0..7] of Char;
    ProductId           : Array [0..15] of Char;
    Reversion           : Array [0..3] of Char;
    VendorSpecific1     : Array [0..19] of Byte;
    Reserved1           : Byte;
    Reserved2           : Byte;
    VersionDescriptor1  : Word;
    VersionDescriptor2  : Word;
    VersionDescriptor3  : Word;
    VersionDescriptor4  : Word;
    VersionDescriptor5  : Word;
    VersionDescriptor6  : Word;
    VersionDescriptor7  : Word;
    VersionDescriptor8  : Word;
    Reserved3           : Array [0..21] of Byte;
    VendorSpecific2     : Array [0..157] of Byte;
  End;

  TDrive = Packed Record
    Letter    : Char;
    HaId      : Byte;
    TargetId  : Byte;
    LunID     : Byte;
    VendorId  : PChar;
    ProductId : PChar;
    Reversion : PChar;
  End;

  TDriveList = Packed Record
    NoOfDrives  : Byte;
    Drives      : Array [0..26] of TDrive;
  End;

  TDiscInformation = Packed Record
    DiscInformationLength           : Word;
    Status                          : Byte;
    NumberOfFirstTrack              : Byte;
    NumberOfSessionsLSB             : Byte;
    FirstTrackInLastSessionLSB      : Byte;
    LastTrackInLastSessionLSB       : Byte;
    DiscInfo                        : Byte;
    DiscType                        : Byte;
    NumberOfSessionsMSB             : Byte;
    FirstTrackInLastSessionMSB      : Byte;
    LastTrackInLastSessionMSB       : Byte;
    DiscIdentification              : Cardinal;
    LastSessionLeadinStartAddress   : Cardinal;
    LastPossibleLeadoutStartAddress : Cardinal;
    DiscBarCode                     : Array [0..7] of Byte;
    DiscApplicationCode             : Byte;
    NumberOfOPCTables               : Byte;
  End;

  TOPCTableEntry = Packed Record
    Speed     : Word;
    OPCValues : Array [0..5] of Byte;
  End;

  TDiscInformationBlockWithOPC = Packed Record
    DiscInformation : TDiscInformation;
    OPCTableEntries : Array of TOPCTableEntry; // don't know the count or max count??
  End;

  SCSI_INQUIRY_DATA = Packed Record
    PathId                : Byte;
    TargetId              : Byte;
    Lun                   : Byte;
    DeviceClaimed         : Boolean;
    InquiryDataLength     : ULONG;
    NextInquiryDataOffset : ULONG;
    InquiryData           : Byte;
  End;

  SCSI_BUS_DATA = Packed Record
    NumberOfLogicalUnits  : Byte;
    InitiatorBusId        : Byte;
    InquiryDataOffset     : ULONG;
  End;

  SCSI_ADAPTER_BUS_INFO = Packed Record
    NumberOfBuses : Byte;
    BusData       : SCSI_BUS_DATA;
  End;

  TDVDLayerDescriptor = Packed Record
    DataLength                          : Word;
    Reserved1                           : Byte;
    Reserved2                           : Byte;
    BookType_PartVersion                : Byte; // BookType Nibble
                                                //    0000    = DVD-ROM = $00
                                                //    0001    = DVD-RAM = $01
                                                //    0010    = DVD-R   = $02
                                                //    0011    = DVD-RW  = $03
                                                //    1001    = DVD+RW  = $09
                                                //    1010    = DVD+R   = $0A
                                                //    Others  = Reserved
    DiscSize_MaximumRate                : Byte; // DiscSize Nibble
                                                //    0000    = 120mm   = $00
                                                //    0001    = 80mm    = $01
                                                // MaximumRate Nibble
                                                //    0000    = 2.52 Mbps     = $00
                                                //    0001    = 5.04 Mbps     = $01
                                                //    0010    = 10.08 Mbps    = $02
                                                //    1111    = Not Specified = $0F
                                                //    Others  = Reserved
    NumberOfLayers_TrackPath_LayerType  : Byte; // LayerType Bit
                                                //    0 = Layer contains embossed data    = $01
                                                //    1 = Layer contains recordable area  = $02
                                                //    2 = Layer contains rewritable area  = $04
                                                //    3 = Reserved                        = $08
    LinearDensity_TrackDensity          : Byte; // LinearDensity Nibble
                                                //    0000    = 0.267 um/bit          = $00
                                                //    0001    = 0.293 um/bit          = $01
                                                //    0010    = 0.409 to 0.435 um/bit = $02
                                                //    0100    = 0.280 to 0.291 um/bit = $04
                                                //    1000    = 0.353 um/bit          = $08
                                                //    Others  = Reserved
                                                // TrackDensity Nibble
                                                //    0000    = 0.74 um/track   = $00
                                                //    0001    = 0.80 um/track   = $01
                                                //    0010    = 0.615 um/track  = $02
                                                //    Others  = Reserved
    StartingPhysicalSector              : DWORD;
    EndPhysicalSector                   : DWORD;
    EndPhysicalSectorInLayerZero        : DWORD;
(*
    Reserved3                           : Byte;
    StartingPhysicalSector              : Array [0..2] of Byte;
                                                //    30000h DVD-ROM, DVD-R/-RW, DVD+RW
                                                //    31000h DVD-RAM
                                                //    Others Reserved
    Reserved4                           : Byte;
    EndPhysicalSector                   : Array [0..2] of Byte;
    Reserved5                           : Byte;
    EndPhysicalSectorInLayerZero        : Array [0..2] of Byte;
*)
    BCA                                 : Byte;
  End;

  TLogicalUnitWriteSpeedPerformanceDescriptorTable = Packed Record
    Reserved:Byte;
    RotationControl:Byte;
    WriteSpeedSupported:Word;
  End;

  TModeParametersHeader = packed record
    ModeDataLength        : Word;
    Reserved1             : Byte;
    Reserved2             : Byte;
    Reserved3             : Byte;
    Reserved4             : Byte;
    BlockDescriptorLength : Word;
  end;

  TMode10Capabilities = packed record
    ModeParametersHeader        : TModeParametersHeader;
    PageCode                    : Byte;
    PageLength                  : Byte;
    ReadCapabilities            : Byte;
    WriteCapabilities           : Byte;
    Capabilities1               : Byte;
    Capabilities2               : Byte;
    Capabilities3               : Byte;
    Capabilities4               : Byte;
    MaxReadSpeed                : Word;
    VolumeLevelsSupported       : Word;
    BufferSizeSupported         : Word;
    CurrentReadSpeed            : Word;
    Reserved1                   : Byte;
    Length_LSBF_RCK_BCKF        : Byte;
    MaxWriteSpeed               : Word;
    CurWriteSpeed_Res           : Word;
    CopyManagemnetRevSupported  : Word;
    Reserved2                   : Array [0..2] of Byte;
    RotationControlSpeed        : Byte;
    CurrentWriteSpeed           : Word;
    NoWriteSpeedDescTables      : Word;
    WriteSpeeds                 : Array [0..99] of TLogicalUnitWriteSpeedPerformanceDescriptorTable;
  end;

  TCapabilities = ( caReadCDR,
                    caReadCDRW,
                    caReadMethod2,
                    caReadDVDROM,
                    caReadDVDR,
                    caReadDVDRW,
                    caReadDVDRAM,
                    caReadDVDPLUSR,
                    caReadDVDPLUSRW,
                    caReadBarcode,
                    caWriteCDR,
                    caWriteCDRW,
                    caWriteTest,
                    caWriteDVDR,
                    caWriteDVDRW,
                    caWriteDVDRAM,
                    caWriteDVDPLUSR,
                    caWriteDVDPLUSRW,
                    caUPC,
                    caISRC,
                    caBufferUnderrunProtection);

  TDeviceCapabilities = set of TCapabilities;

  TMechanismStatusHeader = packed record
    Fault_ChangerState_CurrentSlot      : Byte; // Bit(s)
                                                //   7  = Fault
                                                //
                                                // 6-5  = Changer State
                                                //  +-- 0h  = Ready
                                                //  +-- 1h  = Load in Progress
                                                //  +-- 2h  = Unload in Progress
                                                //  +-- 3h  = Initializing
                                                //
                                                // 4-0  = Current Slot (Low order 5 bits)
    MechanismState_DoorOpen_CurrentSlot : Byte; // Bit(s)
                                                //
                                                // 7-5  = Mechanism State
                                                //  +-- 0h  = Idle
                                                //  +-- 1h  = Playing (Audio or Data)
                                                //  +-- 2h  = Scanning
                                                //  +-- 3h  = Active with Initiator, Composite or Other Ports in use (i.e. READ)
                                                //  +-- 7h  = No State Information Available
                                                //
                                                //   4  = Door open
                                                // 2-0  = Current Slot (High order 3 bits)
    CurrentLBA                          : Array [0..2] of Byte;
    NumberOfSlots                       : Byte;
    LengthOfSlot                        : Word;
  end;

  TSlotTable = packed record
    DiscPresent_Change  : Byte; // Bit(s)
                                // 7  = Disc Present
                                // 0  = Change
    CWPV_CWP            : Byte; // Bit(s)
                                // 1  = CWP_V
                                // 0  = CWP
    Reserved1           : Byte;
    Reserved2           : Byte;
  end;

  TMechanismStatus = packed record
    MechanismStatusHeader : TMechanismStatusHeader;
    SlotTables            : Array [0..9] of TSlotTable;
  end;

  TUnitReturned = 0..2;

Implementation

End.

//  Log List
//
// $Log: ISOSCSIStructs.pas,v $
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

