program PowerOfTeacher;

uses
  Vcl.Forms,
  u_poweroftUpCheck in 'u_poweroftUpCheck.pas' {fm_AutoUpdate},
  Vcl.Themes,
  Vcl.Styles;

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  TStyleManager.TrySetStyle('Sapphire Kamri');
  Application.CreateForm(Tfm_AutoUpdate, fm_AutoUpdate);
  Application.Run;
end.
