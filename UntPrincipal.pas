unit UntPrincipal;

interface

uses
  Winapi.Windows, Winapi.Messages, System.SysUtils, System.Variants, System.Classes, Vcl.Graphics,
  Vcl.Controls, Vcl.Forms, Vcl.Dialogs, Vcl.StdCtrls, Vcl.Mask, Vcl.ExtCtrls,
  Vcl.NumberBox, Vcl.Imaging.GIFImg;

type

  TMinhoca = class

    private
      AlturaAtual, VezesSubidas,

      AlturaQueda, AlturaSubida,

      TamanhoBuraco : Integer;

    public

      function GetAlturaAtual : Integer;
      function GetTamanhoBuraco : Integer;
      function GetQtdMovimetos : Integer;

      procedure Descer;
      procedure Subir;



      constructor Create(AlturaQueda : Integer = 3; AlturaSubida : Integer = 5; TamanhoBuraco : Integer = 20);
  end;


  TFrmPrincipal = class(TForm)
    edtProfundidade: TNumberBox;
    Label1: TLabel;
    edtAvanco: TNumberBox;
    Label2: TLabel;
    edtQueda: TNumberBox;
    Label3: TLabel;
    btnIniciar: TButton;
    pnSimulacao: TPanel;
    pnInfo: TPanel;
    Label4: TLabel;
    lblAltura: TLabel;
    Label5: TLabel;
    lblMovimentos: TLabel;
    timerMinhoca: TTimer;
    imgMinhoca: TImage;
    lblAviso: TLabel;
    pnBackground: TPanel;
    procedure btnIniciarClick(Sender: TObject);
    procedure timerMinhocaTimer(Sender: TObject);
    procedure FormShow(Sender: TObject);
  private
    { Private declarations }

    Minhoca : TMinhoca;

  public
    { Public declarations }
  end;

var
  FrmPrincipal: TFrmPrincipal;

implementation

{$R *.dfm}

constructor TMinhoca.Create(AlturaQueda : Integer = 3; AlturaSubida : Integer = 5; TamanhoBuraco : Integer = 20);
begin
  Self.AlturaAtual   := 0;
  Self.VezesSubidas  := 0;

  Self.AlturaQueda   := AlturaQueda;
  Self.AlturaSubida  := AlturaSubida;
  Self.TamanhoBuraco := TamanhoBuraco;
end;

function TMinhoca.GetAlturaAtual: Integer;
begin
  Result := Self.AlturaAtual;
end;

function TMinhoca.GetQtdMovimetos : Integer;
begin
  Result := Self.VezesSubidas;
end;

function TMinhoca.GetTamanhoBuraco: Integer;
begin
  Result := Self.TamanhoBuraco;
end;

procedure TMinhoca.Descer;
begin
  Self.AlturaAtual := AlturaAtual - AlturaQueda;
end;

procedure TMinhoca.Subir;
begin
  Self.AlturaAtual := AlturaAtual + AlturaSubida;
  Inc(Self.VezesSubidas);
end;

procedure TFrmPrincipal.btnIniciarClick(Sender: TObject);
var
  Queda, Subida, Profundidade : Integer;
begin
  Queda := StrToIntDef(edtQueda.Text, 3);
  Subida := StrToIntDef(edtAvanco.Text, 5);
  Profundidade := StrToIntDef(edtProfundidade.Text, 20);

  if (Queda > Subida) OR (Profundidade < 1) then
  begin
    ShowMessage('A minhoca não poderá sair do buraco :(. Por favor, verifique os valores inseridos e tente novamente.');
    Exit;
  end;

  Self.Minhoca := TMinhoca.Create(
    Queda,
    Subida,
    Profundidade
  );

  (imgMinhoca.Picture.Graphic as TGIFImage).Animate := True;
  (imgMinhoca.Picture.Graphic as TGIFImage).AnimationSpeed := 12;

  pnSimulacao.Visible := True;
  timerMinhoca.Enabled := True;
end;

procedure TFrmPrincipal.FormShow(Sender: TObject);
begin
  pnSimulacao.Visible := False;
end;

procedure TFrmPrincipal.timerMinhocaTimer(Sender: TObject);
begin

  if Minhoca.GetAlturaAtual >= Minhoca.GetTamanhoBuraco div 2 then
  begin
    lblAviso.Visible := True;
    lblAviso.Caption := 'A minhoca passou da metade do buraco!';
    lblAviso.Font.Color := clYellow;
    pnBackground.Color  := clYellow;
  end;

  if Minhoca.GetAlturaAtual >= Minhoca.GetTamanhoBuraco then
  begin
    lblAviso.Visible := True;
    lblAviso.Caption := 'A minhoca saiu do buraco! :)';
    lblAviso.Font.Color   := clOlive;

    pnBackground.Color := clGreen;

    timerMinhoca.Enabled := False;

    ShowMessage('A minhoca saiu do buraco! :)');

    (imgMinhoca.Picture.Graphic as TGIFImage).Animate := False;
    Exit;
  end;

  Minhoca.Subir;
  Minhoca.Descer;

  (imgMinhoca.Picture.Graphic as TGIFImage).Animate := True;
  (imgMinhoca.Picture.Graphic as TGIFImage).AnimateLoop := GIFImageDefaultAnimationLoop;
  (imgMinhoca.Picture.Graphic as TGIFImage).AnimationSpeed := 500;

  lblAltura.Caption := IntToStr(Minhoca.AlturaAtual);
  lblMovimentos.Caption := IntToStr(Minhoca.GetQtdMovimetos);
end;

end.
