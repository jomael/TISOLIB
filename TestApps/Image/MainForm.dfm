object Form1: TForm1
  Left = 296
  Top = 163
  Width = 870
  Height = 640
  Caption = 'Form1'
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  Menu = MainMenu1
  OldCreateOrder = False
  OnCreate = FormCreate
  OnDestroy = FormDestroy
  PixelsPerInch = 96
  TextHeight = 13
  object StatusBar1: TStatusBar
    Left = 0
    Top = 575
    Width = 862
    Height = 19
    Panels = <>
    SimplePanel = False
  end
  object PageControl1: TPageControl
    Left = 0
    Top = 0
    Width = 862
    Height = 575
    ActivePage = TabSheet1
    Align = alClient
    TabOrder = 1
    TabPosition = tpBottom
    object TabSheet1: TTabSheet
      Caption = 'Log'
      object pnl_BorderBG: TPanel
        Left = 0
        Top = 0
        Width = 854
        Height = 547
        Align = alClient
        BevelInner = bvLowered
        BevelOuter = bvLowered
        TabOrder = 0
        object mem_DebugOut: TMemo
          Left = 2
          Top = 2
          Width = 850
          Height = 543
          Align = alClient
          BorderStyle = bsNone
          Font.Charset = DEFAULT_CHARSET
          Font.Color = clWindowText
          Font.Height = -11
          Font.Name = 'Courier New'
          Font.Pitch = fpFixed
          Font.Style = []
          ParentFont = False
          ReadOnly = True
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
    object TabSheet2: TTabSheet
      Caption = 'Path Table'
      ImageIndex = 1
      object tv_PathTable: TTreeView
        Left = 0
        Top = 0
        Width = 854
        Height = 547
        Align = alClient
        Indent = 19
        TabOrder = 0
      end
    end
    object TabSheet3: TTabSheet
      Caption = 'Directory'
      ImageIndex = 2
      object Splitter1: TSplitter
        Left = 666
        Top = 0
        Width = 3
        Height = 547
        Cursor = crHSplit
        Align = alRight
      end
      object pnl_Info: TPanel
        Left = 669
        Top = 0
        Width = 185
        Height = 547
        Align = alRight
        Constraints.MinHeight = 300
        Constraints.MinWidth = 160
        TabOrder = 0
        object gbx_ItemInfo: TGroupBox
          Left = 8
          Top = 16
          Width = 169
          Height = 529
          Anchors = [akLeft, akTop, akRight, akBottom]
          Caption = ' Entry Info '
          TabOrder = 0
          object lb_EntType_Info: TLabel
            Left = 16
            Top = 24
            Width = 54
            Height = 13
            Caption = 'Entry Type:'
          end
          object lb_EntType: TLabel
            Left = 96
            Top = 24
            Width = 54
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'lb_EntType'
          end
          object lb_EntName_Info: TLabel
            Left = 16
            Top = 48
            Width = 31
            Height = 13
            Caption = 'Name:'
          end
          object lb_EntName: TLabel
            Left = 94
            Top = 48
            Width = 58
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'lb_EntName'
          end
          object Label5: TLabel
            Left = 16
            Top = 72
            Width = 32
            Height = 13
            Caption = 'Label5'
            Visible = False
          end
          object Label6: TLabel
            Left = 120
            Top = 72
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label6'
            Visible = False
          end
          object Label7: TLabel
            Left = 16
            Top = 96
            Width = 32
            Height = 13
            Caption = 'Label7'
            Visible = False
          end
          object Label8: TLabel
            Left = 120
            Top = 96
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label8'
            Visible = False
          end
          object Label9: TLabel
            Left = 16
            Top = 120
            Width = 32
            Height = 13
            Caption = 'Label9'
            Visible = False
          end
          object Label11: TLabel
            Left = 16
            Top = 144
            Width = 38
            Height = 13
            Caption = 'Label11'
            Visible = False
          end
          object Label12: TLabel
            Left = 16
            Top = 168
            Width = 38
            Height = 13
            Caption = 'Label12'
            Visible = False
          end
          object Label14: TLabel
            Left = 16
            Top = 192
            Width = 38
            Height = 13
            Caption = 'Label14'
            Visible = False
          end
          object Label15: TLabel
            Left = 16
            Top = 216
            Width = 38
            Height = 13
            Caption = 'Label15'
            Visible = False
          end
          object Label16: TLabel
            Left = 16
            Top = 240
            Width = 38
            Height = 13
            Caption = 'Label16'
            Visible = False
          end
          object Label1: TLabel
            Left = 120
            Top = 120
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
          object Label10: TLabel
            Left = 120
            Top = 144
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
          object Label13: TLabel
            Left = 120
            Top = 168
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
          object Label17: TLabel
            Left = 120
            Top = 192
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
          object Label18: TLabel
            Left = 120
            Top = 216
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
          object Label19: TLabel
            Left = 120
            Top = 240
            Width = 32
            Height = 13
            Alignment = taRightJustify
            Anchors = [akTop, akRight]
            Caption = 'Label9'
            Visible = False
          end
        end
      end
      object pnl_FileTree: TPanel
        Left = 0
        Top = 0
        Width = 666
        Height = 547
        Align = alClient
        BevelOuter = bvNone
        TabOrder = 1
        object tv_Directory: TTreeView
          Left = 0
          Top = 0
          Width = 666
          Height = 547
          Align = alClient
          Indent = 19
          RightClickSelect = True
          TabOrder = 0
          OnChange = tv_DirectoryChange
          OnDblClick = tv_DirectoryDblClick
        end
      end
    end
  end
  object MainMenu1: TMainMenu
    Left = 8
    Top = 8
    object mm_File: TMenuItem
      Caption = 'File'
      object sm_File_Open: TMenuItem
        Caption = 'Open Image'
        OnClick = sm_File_OpenClick
      end
      object sm_File_SaveAs: TMenuItem
        Caption = 'Save Image As ...'
        Enabled = False
      end
      object sm_File_Close: TMenuItem
        Caption = 'Close Image'
        Enabled = False
        OnClick = sm_File_CloseClick
      end
      object sm_File_Break1: TMenuItem
        Caption = '-'
      end
      object sm_File_Quit: TMenuItem
        Caption = 'Quit'
        OnClick = sm_File_QuitClick
      end
    end
  end
  object dlg_OpenImage: TOpenDialog
    Filter = 'All Files (*.*)|*.*'
    Title = 'Select image to open....'
    Left = 40
    Top = 8
  end
  object SaveDialog1: TSaveDialog
    Left = 72
    Top = 8
  end
end
