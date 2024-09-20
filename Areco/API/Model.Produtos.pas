unit Model.Produtos;

interface

uses FireDAC.Comp.Client, Data.DB, System.SysUtils, Model.Connection;

type
    TProdutos = class
    private
        cod_produto: Integer;
        nome_produto: string;
        preco: string;
        marca: string;
    public
        constructor Create;
        destructor Destroy; override;
        property fCOD_PRODUTO : Integer read cod_produto write cod_produto;
        property fNOME_PRODUTO: string read NOME_PRODUTO write NOME_PRODUTO;
        property fPRECO : string read PRECO write PRECO;
        property fMARCA : string read MARCA write MARCA;

        function ListarProdutos(order_by: string; out erro: string): TFDQuery;
        function Inserir(out erro: string): Boolean;
        function Excluir(out erro: string): Boolean;
        function Editar(out erro: string): Boolean;
end;

implementation

{ TCliente }

constructor TProdutos.Create;
begin
    Model.Connection.Connect;
end;

destructor TProdutos.Destroy;
begin
    Model.Connection.Disconect;
end;

function TProdutos.Excluir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('DELETE FROM itens WHERE cod_produto=:cod_produto');
            ParamByName('cod_produto').Value := fCOD_PRODUTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao excluir cliente: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TProdutos.Editar(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if fCOD_PRODUTO <= 0 then
    begin
        Result := false;
        erro := 'Informe o id. cliente';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('UPDATE item SET NOME_PRODUTO=:NOME_PRODUTO, PRECO=:PRECO, MARCA=:MARCA');
            SQL.Add('WHERE COD_PRODUTO=:COD_PRODUTO');
            ParamByName('NOME_PRODUTO').Value := fNOME_PRODUTO;
            ParamByName('PRECO').Value := fPRECO;
            ParamByName('MACAR').Value := fMARCA;
            ParamByName('COD_PRODUTO').Value := fCOD_PRODUTO;
            ExecSQL;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao alterar cliente: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TProduto.Inserir(out erro: string): Boolean;
var
    qry : TFDQuery;
begin
    // Validacoes...
    if fNOME_PRODUTO.IsEmpty then
    begin
        Result := false;
        erro := 'Informe o nome do cliente';
        exit;
    end;

    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            sql.Clear;
            SQL.Add('INSERT INTO iten(NOME_PRODUTO, PRECO, MARCA)');
            SQL.Add('VALUES(:NOME_PRODUTO, :PRECO, :MARCA)');

            ParamByName('NOME_PRODUTO').Value := fNOME_PRODUTO;
            ParamByName('PRECO').Value := fPRECO;
            ParamByName('MARCA').Value := fMARCA;

            ExecSQL;

            // Busca ID inserido...
            Params.Clear;
            SQL.Clear;
            SQL.Add('SELECT MAX(COD_PRODUTO) AS COD_PRODUTO FROM iten');
            SQL.Add('WHERE NOME_PRODUTO=:NOME_PRODUTO');
            ParamByName('NOME_PRODUTO').Value := fNOME_PRODUTO;
            active := true;

            fCOD_PRODUTO := FieldByName('cod_produto').AsInteger;
        end;

        qry.Free;
        erro := '';
        result := true;

    except on ex:exception do
        begin
            erro := 'Erro ao cadastrar cliente: ' + ex.Message;
            Result := false;
        end;
    end;
end;

function TCliente.ListarCliente(order_by: string;
                                out erro: string): TFDQuery;
var
    qry : TFDQuery;
begin
    try
        qry := TFDQuery.Create(nil);
        qry.Connection := Model.Connection.FConnection;

        with qry do
        begin
            Active := false;
            SQL.Clear;
            SQL.Add('SELECT * FROM item WHERE 1 = 1');

            if fCOD_PRODUTO > 0 then
            begin
                SQL.Add('AND COD_PRODUTO = :COD_PRODUTO');
                ParamByName('COD_PRODUTO').Value := fCOD_PRODUTO;
            end;

            if order_by = '' then
                SQL.Add('ORDER BY NOME_PRODUTO')
            else
                SQL.Add('ORDER BY ' + order_by);

            Active := true;
        end;

        erro := '';
        Result := qry;
    except on ex:exception do
        begin
            erro := 'Erro ao consultar clientes: ' + ex.Message;
            Result := nil;
        end;
    end;
end;

end.
