program ServerHorse;

{$APPTYPE CONSOLE}

{$R *.res}

uses
  System.SysUtils,
  Horse,
  Horse.Jhonson,
  Controller.Produtos in 'Controller\Controller.Produtos.pas',
  Model.Connection in 'Model\Model.Connection.pas',
  Controller.Produtos in 'Controller.Produtos.pas',
  Model.Produtos in 'Model.Produtos.pas';

begin
    THorse.Use(Jhonson());

    Controller.Produtos.Registry;
    //Controller.Produto.Registry;
    //Controller.Usuario.Registry;

    THorse.Listen(9000);
end.
