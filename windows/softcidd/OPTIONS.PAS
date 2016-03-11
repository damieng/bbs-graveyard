unit options;

interface

uses
  SysUtils, Windows, Messages, Classes, Graphics, Controls,
  StdCtrls, ExtCtrls, Forms, ComCtrls;

type
  TOptionsForm = class(TForm)
    PageCtl: TPageControl;
    TabGeneral: TTabSheet;
    TabModem: TTabSheet;
    BtnOK: TButton;
    btnCancel: TButton;
    BtnApply: TButton;
  end;

var
  OptionsForm: TOptionsForm;

implementation

{$R *.DFM}


end.
