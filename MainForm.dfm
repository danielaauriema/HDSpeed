object frmMain: TfrmMain
  Left = 0
  Top = 0
  Caption = 'HD Speed !'
  ClientHeight = 331
  ClientWidth = 454
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  OldCreateOrder = False
  OnCreate = FormCreate
  DesignSize = (
    454
    331)
  PixelsPerInch = 96
  TextHeight = 13
  object btnStart: TButton
    Left = 40
    Top = 280
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Start'
    TabOrder = 0
    OnClick = btnStartClick
  end
  object Memo1: TMemo
    Left = 40
    Top = 56
    Width = 360
    Height = 218
    Anchors = [akLeft, akTop, akRight, akBottom]
    Lines.Strings = (
      'Memo1')
    TabOrder = 1
    ExplicitWidth = 362
  end
  object DriveComboBox1: TDriveComboBox
    Left = 40
    Top = 24
    Width = 145
    Height = 19
    TabOrder = 2
  end
  object btnClear: TButton
    Left = 121
    Top = 280
    Width = 75
    Height = 25
    Anchors = [akLeft, akBottom]
    Caption = 'Clear'
    TabOrder = 3
    OnClick = btnClearClick
  end
  object ComboBox1: TComboBox
    Left = 216
    Top = 24
    Width = 99
    Height = 21
    Style = csDropDownList
    ItemIndex = 4
    TabOrder = 4
    Text = '1024'
    Items.Strings = (
      '4'
      '64'
      '256'
      '512'
      '1024'
      '2048')
  end
end
