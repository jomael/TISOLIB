//
//  TISOLib - Volume Descriptors
//
//  refer to http://isolib.xenome.info/
//

//
// $Id: DataTree.pas,v 1.4 2004/06/15 15:32:32 muetze1 Exp $
//

Unit DataTree;

Interface

Uses
  ISOStructs,     // for TDirectoryRecord
  ISOException,   // for EISOLibContainerException
  Contnrs;         // for TObjectList

Type
  TDataTree = Class;  // forward declaration
  TFileEntry = Class; // forward declaration

  TDataSourceFlag = (dsfFromImage, dsfFromLocal, dsfOldSession);
  TEntryFlags     = (efNone, efAdded, efDeleted, efModified);
  TDirectoryEntry = Class
  Private
    Function GetDirCount: Integer;
    Function GetFileCount: Integer;
    Function GetDirEntry(Index: Integer): TDirectoryEntry;
    Function GetFileEntry(Index: Integer): TFileEntry;

  Protected
      // management
    fDataTree    : TDataTree;
    fParent      : TDirectoryEntry;
    fDirectories : TObjectList;
    fFiles       : TObjectList;

      // handling
    fSource      : TDataSourceFlag;
    fFlags       : TEntryFlags;

      // ISO
    fISOData     : TDirectoryRecord;

      // helper
    fName        : String;

    Function    AddFile(AFileEntry : TFileEntry): Integer;
    Function    DelFile(AFileEntry : TFileEntry): Boolean;
    Function    AddDirectory(ADirEntry : TDirectoryEntry): Integer;
    Function    DelDirectory(ADirEntry : TDirectoryEntry): Boolean;

  Public
    Constructor Create(ADataTree : TDataTree; AParentDir : TDirectoryEntry; Const ASource : TDataSourceFlag); Virtual;
    Destructor  Destroy; Override;

    Procedure   MoveDirTo(ANewDirectory : TDirectoryEntry);

    Property    Files[Index: Integer]: TFileEntry             Read GetFileEntry;
    Property    Directories[Index: Integer]: TDirectoryEntry  Read GetDirEntry;

  Published
    Property    FileCount      : Integer           Read  GetFileCount;
    Property    DirectoryCount : Integer           Read  GetDirCount;
    Property    Parent         : TDirectoryEntry   Read  fParent;
    Property    Name           : String            Read  fName
                                                   Write fName;
    Property    ISOData        : TDirectoryRecord  Read  fISOData
                                                   Write fISOData;
    Property    SourceOfData   : TDataSourceFlag   Read  fSource;
    Property    Flags          : TEntryFlags       Read  fFlags;         
  End;

  TFileEntry = Class
  Private
    Function    GetFullPath: String;

  Protected
      // management
    fDirectory   : TDirectoryEntry;
    fName        : String;

      // handling
    fSource      : TDataSourceFlag;
    fFlags       : TEntryFlags;

      // ISO
    fISOData     : TDirectoryRecord;

      // local filesystem
    fSourceFile  : String; // or TFileName

  Public
    Constructor Create(ADirectoryEntry : TDirectoryEntry; Const ASource : TDataSourceFlag); Virtual;
    Destructor  Destroy; Override;

    Procedure   MoveTo(ANewDirectoryEntry: TDirectoryEntry);

      // only valid, if SourceOfData = dsfFromLocal
    Procedure   FillISOData;

  Published
    Property    Name            : String              Read  fName
                                                      Write fName;
    Property    Path            : String              Read  GetFullPath;

      // ISO Data
    Property    ISOData         : TDirectoryRecord    Read  fISOData
                                                      Write fISOData;

    Property    SourceOfData    : TDataSourceFlag     Read  fSource;
    Property    Flags           : TEntryFlags         Read  fFlags;

    Property    SourceFileName  : String              Read  fSourceFile
                                                      Write fSourceFile; 
  End;

  TDataTree = Class
  Private
  Protected
    fRootDir : TDirectoryEntry;
  Public
    Constructor Create; Virtual;
    Destructor  Destroy; Override;

  Published
    Property    RootDirectory : TDirectoryEntry   Read  fRootDir;

  End;

Implementation

Uses
  ISOToolBox,
  SysUtils;          // for FreeAndNil()

{ TFileEntry }

Constructor TFileEntry.Create(ADirectoryEntry: TDirectoryEntry; Const ASource : TDataSourceFlag);
Begin
  Inherited Create;

  fSource     := ASource;
  fSourceFile := '';

  fDirectory  := ADirectoryEntry;
  fDirectory.AddFile(Self);

  fFlags      := efNone;
End;

Destructor TFileEntry.Destroy;
Begin

  Inherited;
End;

Procedure TFileEntry.FillISOData;
Begin
  If ( fSource <> dsfFromLocal ) Then
    Raise EISOLibImageException.Create('not a local file entry, can not fill ISO structure...');

  fName := ExtractFileName(fSourceFile);

  With fISOData Do
  Begin
    DataLength.LittleEndian       := RetrieveFileSize(fSourceFile);
    DataLength.BigEndian          := SwapDWord(DataLength.LittleEndian);
//    RecordingDateAndTime          : TDirectoryDateTime;

//    LocationOfExtent              : TBothEndianDWord;
//    VolumeSequenceNumber          : TBothEndianWord;

//    ExtendedAttributeRecordLength := 0; // ???

//    LengthOfDirectoryRecord       := 0; // think of padding bytes !

//    FileFlags                     : Byte;
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

//    FileUnitSize                  := 0; // ???
//    InterleaveGapSize             := 0; // ???
    LengthOfFileIdentifier        := Length(fName);
      // padding bytes
  End;
End;

Function TFileEntry.GetFullPath: String;
Var
  ADir : TDirectoryEntry;
Begin
  ADir := fDirectory;
  Result := '';

  While ( Assigned(ADir) ) Do
  Begin
    Result := ADir.Name + '/' + Result;
    ADir   := ADir.Parent;
  End;
End;

Procedure TFileEntry.MoveTo(ANewDirectoryEntry: TDirectoryEntry);
Begin
  fDirectory.DelFile(Self);
  fDirectory := ANewDirectoryEntry;
  ANewDirectoryEntry.AddFile(Self);
End;

{ TDirectoryEntry }

Function TDirectoryEntry.AddDirectory(ADirEntry: TDirectoryEntry): Integer;
Begin
  If ( fDirectories.IndexOf(ADirEntry) > -1 ) Then
    Raise EISOLibContainerException.Create('directory entry already added');
  If ( Assigned(ADirEntry.fParent) ) And
     ( ADirEntry.fParent <> Self ) Then
    Raise EISOLibContainerException.Create('directory entry already added - use MoveDirTo() instead!');

  Assert(ADirEntry.fParent = Self, 'Assertion: directory entry on AddDirectory() has different parent directory');
  //  ADirEntry.fParent := Self; // normal case: it is already assign

  Result := fDirectories.Add(ADirEntry);
End;

Function TDirectoryEntry.AddFile(AFileEntry: TFileEntry): Integer;
Begin
  If ( fFiles.IndexOf(AFileEntry) > -1 ) Then
    Raise EISOLibContainerException.Create('file entry already added');
  If ( Assigned(AFileEntry.fDirectory) ) And
     ( AFileEntry.fDirectory <> Self ) Then
    Raise EISOLibContainerException.Create('file entry already listed in different directory');

  Assert(AFileEntry.fDirectory <> Nil, 'Assertion: file entry on AddFile() has no directory assigned');
  //  AFileEntry.fDirectory := Self; // normal case: it is already assign

  Result := fFiles.Add(AFileEntry);
End;

Constructor TDirectoryEntry.Create(ADataTree: TDataTree; AParentDir : TDirectoryEntry; Const ASource : TDataSourceFlag);
Begin
  Inherited Create;

  fDataTree    := ADataTree;
  fParent      := AParentDir;
  fFiles       := TObjectList.Create(True);
  fDirectories := TObjectList.Create(True);

  If Assigned(fParent) Then
    fParent.AddDirectory(Self);

  fSource      := ASource;
  fFlags       := efNone;         
End;

Function TDirectoryEntry.DelDirectory(ADirEntry: TDirectoryEntry): Boolean;
Begin
  Result := False;

  If ( fDirectories.IndexOf(ADirEntry) = -1 ) Then
    Exit;
    
  fDirectories.Extract(ADirEntry);
  ADirEntry.fParent := Nil;

  Result := True;
End;

Function TDirectoryEntry.DelFile(AFileEntry: TFileEntry): Boolean;
Begin
  Result := False;

  If ( fFiles.IndexOf(AFileEntry) = -1 ) Then
    Exit;

  fFiles.Extract(AFileEntry);
  AFileEntry.fDirectory := Nil;

  Result := True;
End;

Destructor TDirectoryEntry.Destroy;
Begin
  If ( Assigned(fFiles) ) Then
    FreeAndNil(fFiles);
  If ( Assigned(fDirectories) ) Then
    FreeAndNil(fDirectories);

  Inherited;
End;

Function TDirectoryEntry.GetDirCount: Integer;
Begin
  If ( Assigned(fDirectories) ) Then
    Result := fDirectories.Count
  Else
    Result := 0;
End;

Function TDirectoryEntry.GetDirEntry(Index: Integer): TDirectoryEntry;
Begin
  Result := fDirectories[Index] As TDirectoryEntry;
End;

Function TDirectoryEntry.GetFileCount: Integer;
Begin
  If ( Assigned(fFiles) ) Then
    Result := fFiles.Count
  Else
    Result := 0;
End;

Function TDirectoryEntry.GetFileEntry(Index: Integer): TFileEntry;
Begin
  Result := fFiles[Index] As TFileEntry;
End;

Procedure TDirectoryEntry.MoveDirTo(ANewDirectory: TDirectoryEntry);
Begin
  If ( Self = ANewDirectory ) Then
    Raise EISOLibContainerException.Create('can not move directory to itself');
  If ( fParent = ANewDirectory ) Then
  Begin
    Assert(False, 'senseless move of directory');
    Exit; // this we have already
  End;

  fParent.DelDirectory(Self); // hoffentlich kein Absturz hier, da DelDirectory Parent auf Nil setzt
  fParent := ANewDirectory;
  ANewDirectory.AddDirectory(Self);
End;

{ TDataTree }

Constructor TDataTree.Create;
Begin
  Inherited Create;

  fRootDir := TDirectoryEntry.Create(Self, Nil, dsfFromImage);  // Root hat keinen Parent
End;

Destructor TDataTree.Destroy;
Begin
  If ( Assigned(fRootDir) ) Then
    FreeAndNil(fRootDir);

  Inherited;
End;

End.

//  Log List
//
// $Log: DataTree.pas,v $
// Revision 1.4  2004/06/15 15:32:32  muetze1
// bug fix for GetFullPath
//
// Revision 1.3  2004/06/07 02:24:41  nalilord
// first isolib cvs check-in
//
//
//
//
//
//
