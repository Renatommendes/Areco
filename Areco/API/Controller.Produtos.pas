unit Controller.Produtos;

interface

uses Horse, System.JSON, System.SysUtils, Model.Produtos,
     FireDAC.Comp.Client, Data.DB, DataSet.Serialize;

procedure Registry;

implementation

procedure ListarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    cli : TProdutos;
    qry : TFDQuery;
    erro : string;
    arrayProdutos : TJSONArray;
begin
    try
        cli := TProdutos.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        qry := cli.ListarProdutos('', erro);

        arrayProdutos := qry.ToJSONArray();

        res.Send<TJSONArray>(arrayProdutos);

    finally
        qry.Free;
        cli.Free;
    end;
end;

procedure ListarProdutosID(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    cli : TProdutos;
    objClientes: TJSONObject;
    qry : TFDQuery;
    erro : string;
begin
    try
        cli := TProdutos.Create;
        cli.fCOD_PRODUTO := Req.Params['id'].ToInteger;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        qry := cli.ListarProdutos('', erro);

        if qry.RecordCount > 0 then
        begin
            objProdutos := qry.ToJSONObject;
            res.Send<TJSONObject>(objClientes)
        end
        else
            res.Send('Cliente não encontrado').Status(404);
    finally
        qry.Free;
        cli.Free;
    end;
end;

procedure AddProduto(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    cli : TProdutos;
    objProdutos: TJSONObject;
    erro : string;
    body  : TJsonValue;
begin
    // Conexao com o banco...
    try
        cli := TProdutos.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;


    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

            cli.fNOME_PRODUTO := body.GetValue<string>('nome_produto', '');
            cli.fPRECO := body.GetValue<string>('preco', '');
            cli.fMARCA := body.GetValue<string>('marca', '');
            cli.Inserir(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                res.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objProdutos := TJSONObject.Create;
        objProdutos.AddPair('cod_produto', cli.fCOD_PRODUTO.ToString);

        res.Send<TJSONObject>(objProdutos).Status(201);
    finally
        cli.Free;
    end;
end;

procedure DeleteProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    cli : TProdutos;
    objProdutos: TJSONObject;
    erro : string;
begin
    // Conexao com o banco...
    try
        cli := TProdutos.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            cli.fCOD_PRODUTO := Req.Params['id'].ToInteger;

            if NOT cli.Excluir(erro) then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                res.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objProdutos := TJSONObject.Create;
        objProdutos.AddPair('cod_produto', cli.fCOD_PRODUTO.ToString);

        res.Send<TJSONObject>(objProdutos);
    finally
        cli.Free;
    end;
end;

procedure EditarProdutos(Req: THorseRequest; Res: THorseResponse; Next: TProc);
var
    cli : TProdutos;
    objProdutos: TJSONObject;
    erro : string;
    body : TJsonValue;
begin
    // Conexao com o banco...
    try
        cli := TProdutos.Create;
    except
        res.Send('Erro ao conectar com o banco').Status(500);
        exit;
    end;

    try
        try
            body := TJSONObject.ParseJSONValue(TEncoding.UTF8.GetBytes(req.Body), 0) as TJsonValue;

            cli.fCOD_PRODUTO := body.GetValue<integer>('cod_produto', 0);
            cli.fNOME_PRODUTO.GetValue<string>('nome_produto', '');
            cli.fPRECO := body.GetValue<string>('preco', '');
            cli.fMARCA := body.GetValue<string>('marca', '');
            cli.Editar(erro);

            body.Free;

            if erro <> '' then
                raise Exception.Create(erro);

        except on ex:exception do
            begin
                res.Send(ex.Message).Status(400);
                exit;
            end;
        end;


        objProdutos := TJSONObject.Create;
        objProdutos.AddPair('cod_produto', cli.fCOD_PRODUTO.ToString);

        res.Send<TJSONObject>(objProdutos).Status(200);
    finally
        cli.Free;
    end;
end;

procedure Registry;
begin
    THorse.Get('/produtos', ListarProdutos);
    THorse.Get('/produtos/:id', ListarProdutosID);
    THorse.Post('/produtos', AddProduto);
    THorse.Put('/produtos', EditarProdutos);
    THorse.Delete('/produtos/:id', DeleteProdutos);
end;

end.
