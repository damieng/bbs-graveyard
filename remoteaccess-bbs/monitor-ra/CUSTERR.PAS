unit custerr;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ComCtrls, Main;

type
  TfrmCustomErr = class(TForm)
    lERR: TLabel;
    edtError: TEdit;
    udError: TUpDown;
    cmdOK: TButton;
    cmdCancel: TButton;
    procedure cmdOKClick(Sender: TObject);
  private
    { Private declarations }
  public
    { Public declarations }
  end;

var
  frmCustomErr: TfrmCustomErr;

implementation

{$R *.DFM}

procedure TfrmCustomErr.cmdOKClick(Sender: TObject);
begin
   frmMain.ExitLevel(udError.Position,'Exit at error level ' + IntToStr(udError.Position) + ' on');
end;

end.
