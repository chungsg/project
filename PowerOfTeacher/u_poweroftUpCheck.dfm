object fm_AutoUpdate: Tfm_AutoUpdate
  Left = 0
  Top = 0
  Caption = #49688#50629#51652#54665' '#50545' '#51088#46041' '#50629#45936#51060#53944
  ClientHeight = 250
  ClientWidth = 635
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -11
  Font.Name = 'Tahoma'
  Font.Style = []
  Position = poScreenCenter
  OnClose = FormClose
  OnShow = FormShow
  PixelsPerInch = 96
  TextHeight = 13
  object GridPanel1: TGridPanel
    Left = 0
    Top = 0
    Width = 635
    Height = 250
    Margins.Left = 10
    Margins.Right = 10
    Align = alClient
    ColumnCollection = <
      item
        Value = 100.000000000000000000
      end>
    ControlCollection = <
      item
        Column = 0
        Control = Label1
        Row = 0
      end
      item
        Column = 0
        Control = pgbar_down
        Row = 1
      end
      item
        Column = 0
        Control = btn_Start
        Row = 3
      end
      item
        Column = 0
        Control = lbl_notice
        Row = 2
      end>
    RowCollection = <
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end
      item
        Value = 25.000000000000000000
      end>
    TabOrder = 0
    DesignSize = (
      635
      250)
    object Label1: TLabel
      Left = 1
      Top = 1
      Width = 633
      Height = 62
      Align = alClient
      Alignment = taCenter
      Caption = #49688#50629#51652#54665' '#50545' '#51088#46041' '#50629#45936#51060#53944'(Ver 1.0)'
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 397
      ExplicitHeight = 21
    end
    object pgbar_down: TProgressBar
      Left = 1
      Top = 108
      Width = 633
      Height = 17
      Margins.Left = 10
      Margins.Top = 0
      Margins.Right = 10
      Margins.Bottom = 0
      Align = alBottom
      State = pbsPaused
      TabOrder = 0
    end
    object btn_Start: TButton
      Left = 257
      Top = 197
      Width = 121
      Height = 41
      Anchors = []
      Caption = #49884#51089
      Enabled = False
      Font.Charset = ANSI_CHARSET
      Font.Color = clWindowText
      Font.Height = -21
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      TabOrder = 1
      OnClick = btn_StartClick
    end
    object lbl_notice: TLabel
      Left = 1
      Top = 125
      Width = 633
      Height = 62
      Align = alClient
      Alignment = taCenter
      Font.Charset = ANSI_CHARSET
      Font.Color = clBlue
      Font.Height = -21
      Font.Name = #44404#47548#52404
      Font.Style = [fsBold]
      ParentFont = False
      Layout = tlCenter
      ExplicitWidth = 12
      ExplicitHeight = 21
    end
  end
  object IdHTTP_swgbdown: TIdHTTP
    OnWork = IdHTTP_swgbdownWork
    OnWorkBegin = IdHTTP_swgbdownWorkBegin
    ProxyParams.BasicAuthentication = False
    ProxyParams.ProxyPort = 0
    Request.ContentLength = -1
    Request.ContentRangeEnd = -1
    Request.ContentRangeStart = -1
    Request.ContentRangeInstanceLength = -1
    Request.Accept = 'text/html,application/xhtml+xml,application/xml;q=0.9,*/*;q=0.8'
    Request.BasicAuthentication = False
    Request.UserAgent = 'Mozilla/3.0 (compatible; Indy Library)'
    Request.Ranges.Units = 'bytes'
    Request.Ranges = <>
    HTTPOptions = [hoForceEncodeParams]
    Left = 544
    Top = 24
  end
  object tmr_CloseNOpen: TTimer
    Enabled = False
    OnTimer = tmr_CloseNOpenTimer
    Left = 584
    Top = 72
  end
end
