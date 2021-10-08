unit u_poweroftUpCheck;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, ShellApi, Vcl.ExtCtrls,
  Vcl.ComCtrls, IdBaseComponent, IdComponent, IdTCPConnection, IdTCPClient,
  IdHTTP;

type
  Tfm_AutoUpdate = class(TForm)
    GridPanel1: TGridPanel;
    Label1: TLabel;
    pgbar_down: TProgressBar;
    btn_Start: TButton;
    IdHTTP_swgbdown: TIdHTTP;
    lbl_notice: TLabel;
    tmr_CloseNOpen: TTimer;
    procedure btn_StartClick(Sender: TObject);
    procedure FormShow(Sender: TObject);
    procedure IdHTTP_swgbdownWorkBegin(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCountMax: Int64);
    procedure IdHTTP_swgbdownWork(ASender: TObject; AWorkMode: TWorkMode;
      AWorkCount: Int64);
    procedure FormClose(Sender: TObject; var Action: TCloseAction);
    procedure DownLoadFile(Sender: TObject);
    procedure tmr_CloseNOpenTimer(Sender: TObject);
  private
    { Private declarations }

  public
    { Public declarations }
  end;

//---------------------------------------------------------------------------
 { TRunThread }

 TRunThread = class(TThread)
 private
 OnEvent: TNotifyEvent;
 Sender: TObject;
 public
 constructor Create(event: TNotifyEvent; _sender: TObject);
 procedure Execute(); override;
 end;
 //---------------------------------------------------------------------------

var
  fm_AutoUpdate: Tfm_AutoUpdate;

  VersionStream : TMemoryStream;
  VersionStr : TStringStream;
  LocalVersion, ServerVersion : TStringList;
  DownCheck : TStringList;
  DownCnt : Integer = 0;
  FileSize : Int64;

implementation

{$R *.dfm}

constructor TRunThread.Create(event: TNotifyEvent; _sender: TObject);
begin
  inherited Create(false);
  FreeOnTerminate := true;
  OnEvent := event;
  Sender := _sender;
end;

procedure TRunThread.Execute;
begin
  OnEvent(Sender);
end;

procedure Tfm_AutoUpdate.btn_StartClick(Sender: TObject);
var
  MyThread : TRunThread;
  I: Integer;
  TmpStr: TStringList;
begin
  pgBar_down.State := pbsNormal;

  TmpStr:= TStringList.Create;
  for I := 0 to DownCheck.Count - 1 do
  begin
    ExtractStrings(['='],[' '],PChar(DownCheck.Strings[i]), TmpStr);
    if FileExists(TmpStr.Strings[0]) and (TmpStr.Strings[1] = 'incomplete') then
    begin
      DeleteFile(TmpStr.Strings[0]);
    end;
    TmpStr.Clear;
  end;

  Mythread := TRunThread.Create(DownLoadFile, Sender);
  Btn_Start.Enabled := False;
end;

procedure Tfm_AutoUpdate.DownLoadFile(Sender: TObject);
var
  i: Integer;
  TmpStr : TStringList;
begin
  TmpStr := TStringList.Create;
  for i := 0 to DownCheck.Count - 1 do
  begin
    ExtractStrings(['='],[' '],PChar(DownCheck.Strings[i]), TmpStr);
    if TmpStr.Strings[1] = 'incomplete' then
    begin
      VersionStream.Clear;
      IdHTTP_swgbdown.Get('http://210.218.83.97:8088/fileupdate/'+TmpStr.Strings[0], VersionStream);
      VersionStream.Position := 0;
      VersionStream.SaveToFile(TmpStr.Strings[0]);
      LocalVersion.Values[TmpStr.Strings[0]] := ServerVersion.Values[TmpStr.Strings[0]];
    end;
    TmpStr.Clear;
  end;

  LocalVersion.SaveToFile('PowerOfTeacher.ini');
  tmr_CloseNOpen.Enabled := True;
end;

procedure Tfm_AutoUpdate.FormClose(Sender: TObject; var Action: TCloseAction);
begin
  if FileExists('ServerPowerOfTeacher.ini') then DeleteFile('ServerPowerOfTeacher.ini');
  FreeAndNil(VersionStream);
  FreeAndNil(VersionStr);
  FreeAndNil(LocalVersion);
  FreeAndNil(DownCheck);
  FreeAndNil(ServerVersion);
end;

procedure Tfm_AutoUpdate.FormShow(Sender: TObject);
 var
  TmpStr : TStringList;
  i : integer;
begin
  if FileExists('powerofteacher.ini') then
  begin
    VersionStream := TMemoryStream.Create;
    LocalVersion := TStringList.Create;
    ServerVersion := TStringList.Create;
    DownCheck := TStringList.Create;

    LocalVersion.LoadFromFile('powerofteacher.ini');

    IdHTTP_swgbdown.Get('http://210.218.83.97:8088/fileupdate/powerofteacher.ini', VersionStream);
    VersionStream.Position := 0;
    VersionStream.SaveToFile('ServerPowerOfTeacher.ini');
    if FileExists('ServerPowerOfTeacher.ini') then ServerVersion.LoadFromFile('ServerPowerOfTeacher.ini');

    TmpStr := TStringList.Create;
    for i := 0 to ServerVersion.Count - 1 do
    begin
      ExtractStrings(['='],[' '],PChar(ServerVersion.Strings[i]), TmpStr);
//       Showmessage(TmpStr[0]);
      if Copy(ServerVersion.Values[TmpStr.Strings[0]],0,10) > Copy(LocalVersion.Values[TmpStr.Strings[0]],0,10) then
      begin
        DownCheck.Values[TmpStr.Strings[0]] := 'incomplete';
        DownCnt := DownCnt + 1;
      end
      else
      begin
        DownCheck.Values[TmpStr.Strings[0]] := 'complete';
      end;
      TmpStr.Clear;
    end;
//    DownCheck.SaveToFile('Down.txt');
    FreeAndNil(TmpStr);
    if DownCnt > 0 then
    begin
      lbl_notice.Caption := '새로운 버전이 있습니다. 아래 [시작]버튼을 클릭하세요.';
      Btn_Start.Enabled := True;
    end
    else
    begin
      Showmessage('현재 버전이 최신 버전입니다.');
      if FileExists('ServerPowerOfTeacher.ini') then DeleteFile('ServerPowerOfTeacher.ini');
      ShellExecute(handle, 'open','poweroftmain.exe',PChar('1032jsg'),nil,SW_NORMAL);
      Application.Terminate;
    end;
  end else
  begin
    Showmessage('powerofteacher.ini이 없습니다. 학교 관리자에게 문의바랍니다.(062-360-5591)');
    close;
  end;



end;

procedure Tfm_AutoUpdate.IdHTTP_swgbdownWork(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCount: Int64);
begin
   if AWorkMode = wmRead then
   begin
     pgBar_down.Position := aWorkCount;
   end;
end;

procedure Tfm_AutoUpdate.IdHTTP_swgbdownWorkBegin(ASender: TObject;
  AWorkMode: TWorkMode; AWorkCountMax: Int64);
begin
   if AWorkMode = wmRead then
   begin
      pgBar_down.Position := 0;
      pgBar_down.Max := AWorkCountMax;
   end;
end;

procedure Tfm_AutoUpdate.tmr_CloseNOpenTimer(Sender: TObject);
begin
  tmr_CloseNOpen.Enabled := False;
  ShellExecute(handle, 'open','poweroftmain.exe',PChar('1032jsg'),nil,SW_NORMAL);
  Application.Terminate;
end;

end.
