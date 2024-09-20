unit Projeto_Areco;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, FireDAC.Stan.Intf, FireDAC.Stan.Option,
  FireDAC.Stan.Error, FireDAC.UI.Intf, FireDAC.Phys.Intf, FireDAC.Stan.Def,
  FireDAC.Stan.Pool, FireDAC.Stan.Async, FireDAC.Phys, FireDAC.VCLUI.Wait,
  FireDAC.Phys.PGDef, FireDAC.Phys.PG, Data.DB, FireDAC.Comp.Client,
  FireDAC.Stan.Param, FireDAC.DatS, FireDAC.DApt.Intf, FireDAC.DApt,
  FireDAC.Comp.DataSet, Vcl.Grids, Vcl.DBGrids, Vcl.StdCtrls;

type
  TfrMain = class(TForm)
    FDConnection1: TFDConnection;
    FDPhysPgDriverLink1: TFDPhysPgDriverLink;
    DBGrid1: TDBGrid;
    DataSource1: TDataSource;
    FDTable1: TFDTable;
    Label1: TLabel;
    Label2: TLabel;
    Label3: TLabel;
    EdtItemName: TEdit;
    EdtPreco: TEdit;
    EdtMarca: TEdit;
    btnSalvar: TButton;
    btnEditar: TButton;
    btnExcluir: TButton;

    procedure btnSalvarClick(Sender: TObject);
    procedure btnEditarClick(Sender: TObject);
    procedure DBGrid1CellClick(Column: TColumn);
    procedure btnExcluirClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frMain: TfrMain;

implementation

{$R *.dfm}

procedure TfrMain.btnEditarClick(Sender: TObject);
begin
  if FDTable1.IsEmpty then
  begin
    ShowMessage('Nenhum registro selecionado para edição.');
    Exit;
  end;

  // Validação dos campos
  if Trim(EdtItemName.Text) = '' then
  begin
    ShowMessage('Por favor insira o nome do produto.');
    Exit;
  end;

  if Trim(EdtPreco.Text) = '' then
  begin
    ShowMessage('Por favor insira o preço.');
    Exit;
  end;

  if Trim(EdtMarca.Text) = '' then
  begin
    ShowMessage('Por favor insira a marca.');
    Exit;
  end;

  // Atualiza o registro no banco de dados
  FDTable1.Edit;
  FDTable1.FieldByName('nome_produto').AsString := Trim(EdtItemName.Text);
  FDTable1.FieldByName('preco').AsFloat := StrToFloat(EdtPreco.Text);
  FDTable1.FieldByName('marca').AsString := Trim(EdtMarca.Text);
  FDTable1.Post;

  ShowMessage('Registro atualizado com sucesso!');
  FDTable1.Refresh; // Atualiza a visualização no DBGrid
end;




procedure TfrMain.btnExcluirClick(Sender: TObject);
begin
  if FDTable1.IsEmpty then
  begin
    ShowMessage('Nenhum registro selecionado para exclusão.');
    Exit;
  end;

  // Exibe uma mensagem de confirmação antes de excluir
  if MessageDlg('Tem certeza que deseja excluir este item?', mtConfirmation, [mbYes, mbNo], 0) = mrYes then
  begin
    try
      FDTable1.Delete;  // Remove o registro selecionado
      FDTable1.Refresh; // Atualiza o DBGrid para refletir a exclusão
      ShowMessage('Registro excluído com sucesso.');
    except
      on E: Exception do
        ShowMessage('Erro ao excluir o registro: ' + E.Message);
    end;
  end;
end;


procedure TfrMain.btnSalvarClick(Sender: TObject);
begin
  if Trim(EdtItemName.Text) = '' then
  begin
    ShowMessage('Por favor insira o nome');
  end
  else if EdtPreco.Text = '' then
    begin
         ShowMessage('Por favor insira o Preço!');
    end
    else
    if EdtMarca.Text = '' then
    begin
      ShowMessage('Por favor insira a marca!');
    end
    else
    begin
      FDTable1.Insert;
      FDTable1.FieldByName('nome_produto').AsString:=Trim(EdtItemName.Text);
      FDTable1.FieldByName('preco').AsFloat:= StrToFloat(EdtPreco.Text);
      FDTable1.FieldByName('marca').AsString:=Trim(EdtMarca.Text);
      FDTable1.Post;
      FDTable1.Refresh;
    end;

end;



procedure TfrMain.DBGrid1CellClick(Column: TColumn);
begin
  // Carrega os valores selecionados no DBGrid para os Edits
  EdtItemName.Text := FDTable1.FieldByName('nome_produto').AsString;
  EdtPreco.Text := FloatToStr(FDTable1.FieldByName('preco').AsFloat);
  EdtMarca.Text := FDTable1.FieldByName('marca').AsString;
end;

end.


