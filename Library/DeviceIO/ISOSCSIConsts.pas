//
//  TISOLib - SCSI definitions
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: ISOSCSIConsts.pas,v 1.3 2004/06/07 02:24:41 nalilord Exp $
//

Unit ISOSCSIConsts;

Interface

Const
  WM_ASPIPOST        = $4D42; // ASPI Post message

  SRB_DATA_SG_LIST   = $0002; // Data buffer points to scatter-gather list

  METHOD_BUFFERED   = 0;
  METHOD_IN_DIRECT  = 1;
  METHOD_OUT_DIRECT = 2;
  METHOD_NEITHER    = 3;

  FILE_ANY_ACCESS   = 0;
  FILE_READ_ACCESS  = $0001;
  FILE_WRITE_ACCESS = $0002;
  IOCTL_CDROM_BASE  = $00000002;
  IOCTL_SCSI_BASE   = $00000004;

  SCSI_IOCTL_DATA_OUT         = 0;
  SCSI_IOCTL_DATA_IN          = 1;
  SCSI_IOCTL_DATA_UNSPECIFIED = 2;

  IOCTL_CDROM_READ_TOC            = $24000;
  IOCTL_CDROM_GET_LAST_SESSION    = $24038;
  IOCTL_SCSI_PASS_THROUGH         = $4D004;
  IOCTL_SCSI_MINIPORT             = $4D008;
  IOCTL_SCSI_GET_INQUIRY_DATA     = $4100C;
  IOCTL_SCSI_GET_CAPABILITIES     = $41010;
  IOCTL_SCSI_PASS_THROUGH_DIRECT  = $4D014;
  IOCTL_SCSI_GET_ADDRESS          = $41018;

  SENSE_LEN                 = 14;  { Default sense buffer length}
  SRB_DIR_SCSI              = $00; { Direction determined by SCSI}
  SRB_POSTING               = $01; { Enable ASPI posting}
  SRB_ENABLE_RESIDUAL_COUNT = $04; { Enable residual byte count reporting}
  SRB_DIR_IN                = $08; { Transfer from SCSI target to host}
  SRB_DIR_OUT               = $10; { Transfer from host to SCSI target}
  SRB_EVENT_NOTIFY          = $40; { Enable ASPI event notification}
  RESIDUAL_COUNT_SUPPORTED  = $02; { Extended buffer flag}
  MAX_SRB_TIMEOUT           = 108000; { 30 hour maximum timeout in sec}
  DEFAULT_SRB_TIMEOUT       = 108000; { Max timeout by default}

  SC_HA_INQUIRY             = $00; { Host adapter inquiry}
  SC_GET_DEV_TYPE           = $01; { Get device type}
  SC_EXEC_SCSI_CMD          = $02; { Execute SCSI command}
  SC_ABORT_SRB              = $03; { Abort an SRB}
  SC_RESET_DEV              = $04; { SCSI bus device reset}
  SC_SET_HA_PARMS           = $05; { Set HA parameters}
  SC_GET_DISK_INFO          = $06; { Get Disk information}
  SC_RESCAN_SCSI_BUS        = $07; { ReBuild SCSI device map}
  SC_GETSET_TIMEOUTS        = $08; { Get/Set target timeouts}

  SS_PENDING                = $00; { SRB being processed}
  SS_COMP                   = $01; { SRB completed without error}
  SS_ABORTED                = $02; { SRB aborted}
  SS_ABORT_FAIL             = $03; { Unable to abort SRB}
  SS_ERR                    = $04; { SRB completed with error}

  SS_INVALID_CMD            = $80; { Invalid ASPI command}
  SS_INVALID_HA             = $81; { Invalid host adapter number}
  SS_NO_DEVICE              = $82; { SCSI device not installed}

  SS_INVALID_SRB            = $E0; { Invalid parameter set in SRB}
  SS_OLD_MANAGER            = $E1; { ASPI manager doesn't support Windows}
  SS_BUFFER_ALIGN           = $E1; { Buffer not aligned (replaces OLD_MANAGER in Win32)}
  SS_ILLEGAL_MODE           = $E2; { Unsupported Windows mode}
  SS_NO_ASPI                = $E3; { No ASPI managers resident}
  SS_FAILED_INIT            = $E4; { ASPI for windows failed init}
  SS_ASPI_IS_BUSY           = $E5; { No resources available to execute cmd}
  SS_BUFFER_TO_BIG          = $E6; { Buffer size to big to handle!}
  SS_MISMATCHED_COMPONENTS  = $E7; { The DLLs/EXEs of ASPI don't version check}
  SS_NO_ADAPTERS            = $E8; { No host adapters to manage}
  SS_INSUFFICIENT_RESOURCES = $E9; { Couldn't allocate resources needed to init}
  SS_ASPI_IS_SHUTDOWN       = $EA; { Call came to ASPI after PROCESS_DETACH}
  SS_BAD_INSTALL            = $EB; { The DLL or other components are installed wrong}

  HASTAT_OK                   = $00; { Host adapter did not detect an  error}
  HASTAT_SEL_TO               = $11; { Selection Timeout}
  HASTAT_DO_DU                = $12; { Data overrun data underrun}
  HASTAT_BUS_FREE             = $13; { Unexpected bus free}
  HASTAT_PHASE_ERR            = $14; { Target bus phase sequence  failure}
  HASTAT_TIMEOUT              = $09; { Timed out while SRB was waiting to beprocessed.}
  HASTAT_COMMAND_TIMEOUT      = $0B; { Adapter timed out processing SRB.}
  HASTAT_MESSAGE_REJECT       = $0D; { While processing SRB, the  adapter received a MESSAGE}
  HASTAT_BUS_RESET            = $0E; { A bus reset was detected.}
  HASTAT_PARITY_ERROR         = $00; { A parity error was detected.}
  HASTAT_REQUEST_SENSE_FAILED = $10; { The adapter failed in issuing}

  DTYPE_DASD                  = $00;   { Disk Device               }
  DTYPE_SEQD                  = $01;   { Tape Device               }
  DTYPE_PRNT                  = $02;   { Printer                   }
  DTYPE_PROC                  = $03;   { Processor                 }
  DTYPE_WORM                  = $04;   { Write-once read-multiple  }
  DTYPE_CROM                  = $05;   { CD-ROM device             }
  DTYPE_CDROM                 = $05;   { CD-ROM device             }
  DTYPE_SCAN                  = $06;   { Scanner device            }
  DTYPE_OPTI                  = $07;   { Optical memory device     }
  DTYPE_JUKE                  = $08;   { Medium Changer device     }
  DTYPE_COMM                  = $09;   { Communications device     }
  DTYPE_RESL                  = $0A;   { Reserved (low)            }
  DTYPE_RESH                  = $1E;   { Reserved (high)           }
  DTYPE_UNKNOWN               = $1F;   { Unknown or no device type }

  SCG_RECV_DATA               = $0001;	{ DMA direction to Sun }
  SCG_DISRE_ENA               = $0002;	{ enable disconnect/reconnect }
  SCG_SILENT                  = $0004;	{ be silent on errors }
  SCG_CMD_RETRY               = $0008;	{ enable retries }
  SCG_NOPARITY                = $0010;	{ disable parity for this command }
  SC_G0_CDBLEN                = 06;        { Len of Group 0 commands }
  SC_G1_CDBLEN                = 10;        { Len of Group 1 commands }
  SC_G5_CDBLEN                = 12;        { Len of Group 5 commands }
  DEF_SENSE_LEN               = 16;        { Default Sense Len }
  CCS_SENSE_LEN               = 18;        { Sense Len for CCS compatible devices }

  STATUS_GOOD     = $00; // Status Good
  STATUS_CHKCOND  = $02; // Check Condition
  STATUS_CONDMET  = $04; // Condition Met
  STATUS_BUSY     = $08; // Busy
  STATUS_INTERM   = $10; // Intermediate
  STATUS_INTCDMET = $14; // Intermediate-condition met
  STATUS_RESCONF  = $18; // Reservation conflict
  STATUS_COMTERM  = $22; // Command Terminated
  STATUS_QFULL    = $28; // Queue full

  MAXLUN          = $07; // Maximum Logical Unit Id
  MAXTARG         = $07; // Maximum Target Id
  MAX_SCSI_LUNS   = $40; // Maximum Number of SCSI LUNs
  MAX_NUM_HA      = $08; // Maximum Number of SCSI HA's

  SCSI_CHANGE_DEF = $40; // Change Definition (Optional)
  SCSI_COMPARE    = $39; // Compare (O)
  SCSI_COPY       = $18; // Copy (O)
  SCSI_COP_VERIFY = $3A; // Copy and Verify (O)
  SCSI_INQUIRY    = $12; // Inquiry (MANDATORY)
  SCSI_LOG_SELECT = $4C; // Log Select (O)
  SCSI_LOG_SENSE  = $4D; // Log Sense (O)
  SCSI_MODE_SEL6  = $15; // Mode Select 6-byte (Device Specific)
  SCSI_MODE_SEL10 = $55; // Mode Select 10-byte (Device Specific)
  SCSI_MODE_SEN6  = $1A; // Mode Sense 6-byte (Device Specific)
  SCSI_MODE_SEN10 = $5A; // Mode Sense 10-byte (Device Specific)
  SCSI_READ_BUFF  = $3C; // Read Buffer (O)
  SCSI_REQ_SENSE  = $03; // Request Sense (MANDATORY)
  SCSI_SEND_DIAG  = $1D; // Send Diagnostic (O)
  SCSI_TST_U_RDY  = $00; // Test Unit Ready (MANDATORY)
  SCSI_WRITE_BUFF = $3B; // Write Buffer (O)

  SCSI_FORMAT     = $04; // Format Unit (MANDATORY)
  SCSI_LCK_UN_CAC = $36; // Lock Unlock Cache (O)
  SCSI_PREFETCH   = $34; // Prefetch (O)
  SCSI_MED_REMOVL = $1E; // Prevent/Allow medium Removal (O)
  SCSI_READ6      = $08; // Read 6-byte (MANDATORY)
  SCSI_READ10     = $28; // Read 10-byte (MANDATORY)
  SCSI_RD_CAPAC   = $25; // Read Capacity (MANDATORY)
  SCSI_RD_DEFECT  = $37; // Read Defect Data (O)
  SCSI_READ_LONG  = $3E; // Read Long (O)
  SCSI_REASS_BLK  = $07; // Reassign Blocks (O)
  SCSI_RCV_DIAG   = $1C; // Receive Diagnostic Results (O)
  SCSI_RELEASE    = $17; // Release Unit (MANDATORY)
  SCSI_REZERO     = $01; // Rezero Unit (O)
  SCSI_SRCH_DAT_E = $31; // Search Data Equal (O)
  SCSI_SRCH_DAT_H = $30; // Search Data High (O)
  SCSI_SRCH_DAT_L = $32; // Search Data Low (O)
  SCSI_SEEK6      = $0B; // Seek 6-Byte (O)
  SCSI_SEEK10     = $2B; // Seek 10-Byte (O)
  SCSI_SET_LIMIT  = $33; // Set Limits (O)
  SCSI_START_STP  = $1B; // Start/Stop Unit (O)
  SCSI_SYNC_CACHE = $35; // Synchronize Cache (O)
  SCSI_VERIFY     = $2F; // Verify (O)
  SCSI_WRITE6     = $0A; // Write 6-Byte (MANDATORY)
  SCSI_WRITE10    = $2A; // Write 10-Byte (MANDATORY)
  SCSI_WRT_VERIFY = $2E; // Write and Verify (O)
  SCSI_WRITE_LONG = $3F; // Write Long (O)
  SCSI_WRITE_SAME = $41; // Write Same (O)

  SCSI_ERASE      = $19; // Erase (MANDATORY)
  SCSI_LOAD_UN    = $1B; // Load/Unload (O)
  SCSI_LOCATE     = $2B; // Locate (O)
  SCSI_RD_BLK_LIM = $05; // Read Block Limits (MANDATORY)
  SCSI_READ_POS   = $34; // Read Position (O)
  SCSI_READ_REV   = $0F; // Read Reverse (O)
  SCSI_REC_BF_DAT = $14; // Recover Buffer Data (O)
  SCSI_RESERVE    = $16; // Reserve Unit (MANDATORY)
  SCSI_REWIND     = $01; // Rewind (MANDATORY)
  SCSI_SPACE      = $11; // Space (MANDATORY)
  SCSI_VERIFY_T   = $13; // Verify (Tape) (O)
  SCSI_WRT_FILE   = $10; // Write Filemarks (MANDATORY)

  SCSI_PRINT      = $0A; // Print (MANDATORY)
  SCSI_SLEW_PNT   = $0B; // Slew and Print (O)
  SCSI_STOP_PNT   = $1B; // Stop Print (O)
  SCSI_SYNC_BUFF  = $10; // Synchronize Buffer (O)

  SCSI_RECEIVE    = $08; // Receive (O)
  SCSI_SEND       = $0A; // Send (O)

  SCSI_MEDIUM_SCN = $38; // Medium Scan (O)
  SCSI_SRCHDATE10 = $31; // Search Data Equal 10-Byte (O)
  SCSI_SRCHDATE12 = $B1; // Search Data Equal 12-Byte (O)
  SCSI_SRCHDATH10 = $30; // Search Data High 10-Byte (O)
  SCSI_SRCHDATH12 = $B0; // Search Data High 12-Byte (O)
  SCSI_SRCHDATL10 = $32; // Search Data Low 10-Byte (O)
  SCSI_SRCHDATL12 = $B2; // Search Data Low 12-Byte (O)
  SCSI_SET_LIM_10 = $33; // Set Limits 10-Byte (O)
  SCSI_SET_LIM_12 = $B3; // Set Limits 10-Byte (O)
  SCSI_VERIFY10   = $2F; // Verify 10-Byte (O)
  SCSI_VERIFY12   = $AF; // Verify 12-Byte (O)
  SCSI_WRITE12    = $AA; // Write 12-Byte (O)
  SCSI_WRT_VER10  = $2E; // Write and Verify 10-Byte (O)
  SCSI_WRT_VER12  = $AE; // Write and Verify 12-Byte (O)

  SCSI_PLAYAUD_10   = $45; // Play Audio 10-Byte (O)
  SCSI_PLAYAUD_12   = $A5; // Play Audio 12-Byte 12-Byte (O)
  SCSI_PLAYAUDMSF   = $47; // Play Audio MSF (O)
  SCSI_PLAYA_TKIN   = $48; // Play Audio Track/Index (O)
  SCSI_PLYTKREL10   = $49; // Play Track Relative 10-Byte (O)
  SCSI_PLYTKREL12   = $A9; // Play Track Relative 12-Byte (O)
  SCSI_READCDCAP    = $25; // Read CD-ROM Capacity (MANDATORY)
  SCSI_READHEADER   = $44; // Read Header (O)
  SCSI_SUBCHANNEL   = $42; // Read Subchannel (O)
  SCSI_READ_TOC     = $43; // Read TOC (O)
  SCSI_STOP         = $4E;
  SCSI_PAUSERESUME  = $4B;
  SCSI_GETDBSTAT    = $34; // Get Data Buffer Status (O)
  SCSI_GETWINDOW    = $25; // Get Window (O)
  SCSI_OBJECTPOS    = $31; // Object Postion (O)
  SCSI_SCAN         = $1B; // Scan (O)
  SCSI_SETWINDOW    = $24; // Set Window (MANDATORY)

  SCSI_UPDATEBLK    = $3D; // Update Block (O)

  SCSI_EXCHMEDIUM   = $A6; // Exchange Medium (O)
  SCSI_INITELSTAT   = $07; // Initialize Element Status (O)
  SCSI_POSTOELEM    = $2B; // Position to Element (O)
  SCSI_REQ_VE_ADD   = $B5; // Request Volume Element Address (O)
  SCSI_SENDVOLTAG   = $B6; // Send Volume Tag (O)

  SCSI_GET_MSG_6    = $08; // Get Message 6-Byte (MANDATORY)
  SCSI_GET_MSG_10   = $28; // Get Message 10-Byte (O)
  SCSI_GET_MSG_12   = $A8; // Get Message 12-Byte (O)
  SCSI_SND_MSG_6    = $0A; // Send Message 6-Byte (MANDATORY)
  SCSI_SND_MSG_10   = $2A; // Send Message 10-Byte (O)
  SCSI_SND_MSG_12   = $AA; // Send Message 12-Byte (O)

  SERROR_CURRENT  = $70; // Current Errors
  SERROR_DEFERED  = $71; // Deferred Errors

  SENSE_VALID     = $80; // Byte 0 Bit 7
  SENSE_FILEMRK   = $80; // Byte 2 Bit 7
  SENSE_EOM       = $40; // Byte 2 Bit 6
  SENSE_ILI       = $20; // Byte 2 Bit 5

  KEY_NOSENSE     = $00; // No Sense
  KEY_RECERROR    = $01; // Recovered Error
  KEY_NOTREADY    = $02; // Not Ready
  KEY_MEDIUMERR   = $03; // Medium Error
  KEY_HARDERROR   = $04; // Hardware Error
  KEY_ILLGLREQ    = $05; // Illegal Request
  KEY_UNITATT     = $06; // Unit Attention
  KEY_DATAPROT    = $07; // Data Protect
  KEY_BLANKCHK    = $08; // Blank Check
  KEY_VENDSPEC    = $09; // Vendor Specific
  KEY_COPYABORT   = $0A; // Copy Abort
  KEY_EQUAL       = $0C; // Equal (Search)
  KEY_VOLOVRFLW   = $0D; // Volume Overflow
  KEY_MISCOMP     = $0E; // Miscompare (Search)
  KEY_RESERVED    = $0F; // Reserved

  ANSI_MAYBE      = $0; // Device may or may not be ANSI approved stand
  ANSI_SCSI1      = $1; // Device complies to ANSI X3.131-1986 (SCSI-1)
  ANSI_SCSI2      = $2; // Device complies to SCSI-2
  ANSI_RESLO      = $3; // Reserved (low)
  ANSI_RESHI      = $7; // Reserved (high)

  DiscTypes : Array [0..19] of String = ('No Current Profile',
                                         'Non Removable Disk',
                                         'Removable Disk',
                                         'Magneto Optical Erasable',
                                         'Optical Write Once',
                                         'AS-MO',
                                         'CD-ROM',
                                         'CD-R',
                                         'CD-RW',
                                         'DVD-ROM',
                                         'DVD-R SequentialRecording,',
                                         'DVD-RAM',
                                         'DVD-RW Restricted Overwrite',
                                         'DVD-RW Sequential Recording',
                                         'DVD+RW',
                                         'DVD+R',
                                         'DDCD-ROM',
                                         'DDCD-R',
                                         'DDCD-RW',
                                         'UNKNOWN');

Implementation

End.

//  Log List
//
// $Log: ISOSCSIConsts.pas,v $
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//

