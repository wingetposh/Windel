object Form1: TForm1
  Left = 0
  Top = 0
  Caption = 'Form1'
  ClientHeight = 712
  ClientWidth = 1002
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poScreenCenter
  TextHeight = 15
  object ActivityIndicator1: TActivityIndicator
    Left = 744
    Top = 328
    IndicatorColor = aicWhite
    IndicatorSize = aisLarge
    IndicatorType = aitRotatingSector
  end
  object pnlToolbar: TPanel
    Left = 0
    Top = 0
    Width = 1002
    Height = 41
    Align = alTop
    BevelOuter = bvNone
    Caption = 'pnlToolbar'
    ShowCaption = False
    TabOrder = 1
    object btnQuit: TBitBtn
      Left = 911
      Top = 0
      Width = 91
      Height = 41
      Align = alRight
      Caption = 'Quit'
      TabOrder = 0
      OnClick = btnQuitClick
    end
    object btnOptions: TBitBtn
      Left = 0
      Top = 0
      Width = 75
      Height = 41
      Align = alLeft
      Caption = 'Options'
      TabOrder = 1
      OnClick = btnOptionsClick
    end
    object btn1: TBitBtn
      Left = 75
      Top = 0
      Width = 75
      Height = 41
      Align = alLeft
      Caption = 'btn1'
      TabOrder = 2
      OnClick = btn1Click
    end
  end
  object pnlFooter: TPanel
    Left = 0
    Top = 671
    Width = 1002
    Height = 41
    Align = alBottom
    BevelOuter = bvNone
    Caption = 'pnlFooter'
    ShowCaption = False
    TabOrder = 2
  end
  object pnlMain: TPanel
    Left = 0
    Top = 41
    Width = 1002
    Height = 630
    Align = alClient
    BevelOuter = bvNone
    Caption = 'pnlMain'
    ShowCaption = False
    TabOrder = 3
    object PageControl1: TPageControl
      Left = 0
      Top = 6
      Width = 993
      Height = 618
      ActivePage = tsList
      TabOrder = 0
      object tsList: TTabSheet
        Caption = 'tsList'
      end
      object tsSearch: TTabSheet
        Caption = 'tsSearch'
        ImageIndex = 1
      end
      object TabSheet3: TTabSheet
        Caption = 'TabSheet3'
        ImageIndex = 2
        object Memo1: TMemo
          Left = 0
          Top = 0
          Width = 985
          Height = 588
          Align = alClient
          Font.Charset = ANSI_CHARSET
          Font.Color = clWindowText
          Font.Height = -12
          Font.Name = 'Source Code Pro'
          Font.Style = []
          Lines.Strings = (
            'Memo1')
          ParentFont = False
          ScrollBars = ssVertical
          TabOrder = 0
        end
      end
    end
  end
  object DosCommand1: TDosCommand
    CommandLine = 'winget upgrade'
    InputToOutput = False
    MaxTimeAfterBeginning = 0
    MaxTimeAfterLastOutput = 0
    OnCharDecoding = DosCommand1CharDecoding
    OnNewLine = DosCommand1NewLine
    OnTerminated = DosCommand1Terminated
    Left = 508
    Top = 124
  end
end
