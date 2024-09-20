object frMain: TfrMain
  Left = 0
  Top = 0
  Caption = 'frMain'
  ClientHeight = 441
  ClientWidth = 624
  Color = clBtnFace
  Font.Charset = DEFAULT_CHARSET
  Font.Color = clWindowText
  Font.Height = -12
  Font.Name = 'Segoe UI'
  Font.Style = []
  Position = poDesktopCenter
  TextHeight = 15
  object Label1: TLabel
    Left = 8
    Top = 24
    Width = 99
    Height = 15
    Caption = 'Nome do produto:'
  end
  object Label2: TLabel
    Left = 8
    Top = 56
    Width = 33
    Height = 15
    Caption = 'Pre'#231'o:'
  end
  object Label3: TLabel
    Left = 8
    Top = 88
    Width = 36
    Height = 15
    Caption = 'Marca:'
  end
  object DBGrid1: TDBGrid
    Left = 0
    Top = 224
    Width = 616
    Height = 209
    DataSource = DataSource1
    TabOrder = 0
    TitleFont.Charset = DEFAULT_CHARSET
    TitleFont.Color = clWindowText
    TitleFont.Height = -12
    TitleFont.Name = 'Segoe UI'
    TitleFont.Style = []
    OnCellClick = DBGrid1CellClick
    Columns = <
      item
        Expanded = False
        FieldName = 'id_produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'nome_produto'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'preco'
        Visible = True
      end
      item
        Expanded = False
        FieldName = 'marca'
        Visible = True
      end>
  end
  object EdtItemName: TEdit
    Left = 113
    Top = 21
    Width = 225
    Height = 23
    TabOrder = 1
  end
  object EdtPreco: TEdit
    Left = 50
    Top = 53
    Width = 169
    Height = 23
    TabOrder = 2
  end
  object EdtMarca: TEdit
    Left = 50
    Top = 85
    Width = 169
    Height = 23
    TabOrder = 3
  end
  object btnSalvar: TButton
    Left = 24
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Salvar'
    TabOrder = 4
    OnClick = btnSalvarClick
  end
  object btnEditar: TButton
    Left = 128
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Editar'
    TabOrder = 5
    OnClick = btnEditarClick
  end
  object btnExcluir: TButton
    Left = 232
    Top = 144
    Width = 75
    Height = 25
    Caption = 'Excluir'
    TabOrder = 6
    OnClick = btnExcluirClick
  end
  object FDConnection1: TFDConnection
    Params.Strings = (
      'Database=produtos'
      'Password=12345678'
      'User_Name=postgres'
      'Port=5433'
      'DriverID=PG')
    Connected = True
    LoginPrompt = False
    Left = 400
    Top = 288
  end
  object FDPhysPgDriverLink1: TFDPhysPgDriverLink
    VendorLib = 'C:\Program Files (x86)\PostgreSQL\10\bin\libpq.dll'
    Left = 400
    Top = 352
  end
  object DataSource1: TDataSource
    DataSet = FDTable1
    Left = 512
    Top = 296
  end
  object FDTable1: TFDTable
    Active = True
    IndexFieldNames = 'id_produto'
    Connection = FDConnection1
    ResourceOptions.AssignedValues = [rvEscapeExpand]
    TableName = 'itens'
    Left = 512
    Top = 368
  end
end
