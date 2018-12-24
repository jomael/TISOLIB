unit MainForm;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  Menus, ExtCtrls, ComCtrls, StdCtrls, ISOImage, ISOStructs, DataTree;

type
  TForm1 = class(TForm)
    StatusBar1: TStatusBar;
    MainMenu1: TMainMenu;
    mm_File: TMenuItem;
    sm_File_Open: TMenuItem;
    sm_File_Close: TMenuItem;
    sm_File_Break1: TMenuItem;
    sm_File_Quit: TMenuItem;
    dlg_OpenImage: TOpenDialog;
    SaveDialog1: TSaveDialog;
    PageControl1: TPageControl;
    TabSheet1: TTabSheet;
    pnl_BorderBG: TPanel;
    mem_DebugOut: TMemo;
    TabSheet2: TTabSheet;
    tv_PathTable: TTreeView;
    TabSheet3: TTabSheet;
    pnl_Info: TPanel;
    sm_File_SaveAs: TMenuItem;
    gbx_ItemInfo: TGroupBox;
    pnl_FileTree: TPanel;
    tv_Directory: TTreeView;
    Splitter1: TSplitter;
    lb_EntType_Info: TLabel;
    lb_EntType: TLabel;
    lb_EntName_Info: TLabel;
    lb_EntName: TLabel;
    Label5: TLabel;
    Label6: TLabel;
    Label7: TLabel;
    Label8: TLabel;
    Label9: TLabel;
    Label11: TLabel;
    Label12: TLabel;
    Label14: TLabel;
    Label15: TLabel;
    Label16: TLabel;
    Label1: TLabel;
    Label10: TLabel;
    Label13: TLabel;
    Label17: TLabel;
    Label18: TLabel;
    Label19: TLabel;
    procedure sm_File_QuitClick(Sender: TObject);
    procedure sm_File_OpenClick(Sender: TObject);
    procedure FormCreate(Sender: TObject);
    procedure FormDestroy(Sender: TObject);
    procedure tv_DirectoryDblClick(Sender: TObject);
    procedure sm_File_CloseClick(Sender: TObject);
    procedure tv_DirectoryChange(Sender: TObject; Node: TTreeNode);
  private
    { Private-Deklarationen }

    fISOImage  : TISOImage;

    Procedure  BuildStructureTree(ATV: TTreeView; RootNode : TTreeNode; ADirEntry : TDirectoryEntry);

  public
    { Public-Deklarationen }
  end;

var
  Form1: TForm1;

implementation

{$R *.DFM}

procedure TForm1.sm_File_QuitClick(Sender: TObject);
begin
  Close;
end;

procedure TForm1.sm_File_OpenClick(Sender: TObject);
Var
  Node : TTreeNode;
begin
  If ( dlg_OpenImage.Execute ) Then
  Begin
    If ( Assigned(fISOImage) ) Then
      FreeAndNil(fISOImage);

    mem_DebugOut.Clear;
    tv_Directory.Items.Clear;
    tv_PathTable.Items.Clear;

    fISOImage := TISOImage.Create(dlg_OpenImage.FileName, mem_DebugOut.Lines);

    Try
      fISOImage.OpenImage;

        // only for debugging, later not needed - will be recreated on
        // save...
      fISOImage.ParsePathTable(tv_PathTable);

      Node := tv_Directory.Items.Add(Nil, '/');
      Node.Data := fISOImage.Structure.RootDirectory;
      BuildStructureTree(tv_Directory, Node, fISOImage.Structure.RootDirectory);

      // sm_File_SaveAs.Enabled := True; not yet ready
      sm_File_Close.Enabled := True;

    Except
      mem_DebugOut.Lines.Add('Exception: ' + Exception(ExceptObject).ClassName + ' -> ' + Exception(ExceptObject).Message);
      Raise;

      fISOImage.CloseImage;
    End;
  End;
end;

procedure TForm1.FormCreate(Sender: TObject);
begin
  fISOImage := Nil;   // not necessary, but safety first...
end;

procedure TForm1.FormDestroy(Sender: TObject);
begin
  If ( Assigned(fISOImage) ) Then
    FreeAndNil(fISOImage);
end;

procedure TForm1.tv_DirectoryDblClick(Sender: TObject);
Var
  Node : TTreeNode;
  Obj  : TObject;
begin
  Node := TTreeView(Sender).Selected;

  If Assigned(Node.Data) Then
  Begin
    Obj := TObject(Node.Data);
    If ( Obj Is TFileEntry ) And ( SaveDialog1.Execute ) Then
      fISOImage.ExtractFile(TFileEntry(Obj), SaveDialog1.FileName);
  End;
end;

Procedure TForm1.BuildStructureTree(ATV: TTreeView; RootNode : TTreeNode; ADirEntry : TDirectoryEntry);
Var
  i : Integer;
  Node : TTreeNode;
  Dir  : TDirectoryEntry;
  Fil  : TFileEntry;
Begin
  For i:=0 To ADirEntry.DirectoryCount-1 Do
  Begin
    Dir := ADirEntry.Directories[i];

    Node := ATV.Items.AddChild(RootNode, Dir.Name + '/');
    Node.Data := Pointer(Dir);

    BuildStructureTree(ATV, Node, Dir);
  End;

  For i:=0 To ADirEntry.FileCount-1 Do
  Begin
    Fil := ADirEntry.Files[i];

    Node := ATV.Items.AddChild(RootNode, Fil.Name);
    Node.Data := Pointer(Fil);
  End;
End;

procedure TForm1.sm_File_CloseClick(Sender: TObject);
begin
  If ( Assigned(fISOImage) ) Then
    fISOImage.CloseImage;

  sm_File_Close.Enabled  := False;
  sm_File_SaveAs.Enabled := False;
end;

procedure TForm1.tv_DirectoryChange(Sender: TObject; Node: TTreeNode);
Var
  Obj : TObject;
begin
  If Assigned(Node) Then
  Begin
    Obj := TObject(Node.Data);

    lb_EntType.Caption := 'unknown';

    If Assigned(Obj) Then
    Begin
      If ( Obj Is TDirectoryEntry ) Then
      Begin
        lb_EntType.Caption  := 'directory';
        lb_EntName.Caption  := TDirectoryEntry(Obj).Name;
        lb_EntName.Hint     := '';
        lb_EntName.ShowHint := False;
      End;

      If ( Obj Is TFileEntry ) Then
      Begin
        lb_EntType.Caption  := 'file';
        lb_EntName.Caption  := TFileEntry(Obj).Name;
        lb_EntName.Hint     := TFileEntry(Obj).Path;
        lb_EntName.ShowHint := True;
      End;
    End;
  End;
end;

end.
