program Cadastro_Produtos;

uses
  Vcl.Forms,
  Projeto_Areco in 'Projeto_Areco.pas' {frMain};

{$R *.res}

begin
  Application.Initialize;
  Application.MainFormOnTaskbar := True;
  Application.CreateForm(TfrMain, frMain);
  Application.Run;
end.
