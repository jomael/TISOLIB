object MainForm: TMainForm
  Left = 678
  Top = 443
  BorderStyle = bsDialog
  Caption = 'DeviceIO Test Application'
  ClientHeight = 89
  ClientWidth = 321
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'MS Sans Serif'
  Font.Style = []
  OldCreateOrder = False
  Position = poScreenCenter
  OnCreate = FormCreate
  PixelsPerInch = 96
  TextHeight = 13
  object Label1: TLabel
    Left = 16
    Top = 8
    Width = 74
    Height = 13
    Caption = 'CD/DVD Drive:'
  end
  object Button1: TButton
    Left = 16
    Top = 56
    Width = 137
    Height = 25
    Caption = 'Show disc Information'
    TabOrder = 0
    OnClick = Button1Click
  end
  object ComboBox1: TComboBox
    Left = 16
    Top = 24
    Width = 105
    Height = 21
    Style = csDropDownList
    ItemHeight = 13
    TabOrder = 1
  end
end
