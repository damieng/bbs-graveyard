unit NvTipOfDayForm;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvTipOfTheDayForm
  Type:     Component
  Contains: TNvTipOfTheDayForm  "TNvTipOfTheDay component form"
  Version:  v1.0

  Changes:  03-Mar-1997   DPG   Created from existing EnvyDCP.
            01-Apr-1997   DPG   Final code tidy.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            25-May-1997   DPG   New Title caption to change
                                'Did you know...'.
            05-Aug-1997   DPG   Renamed to TNvTipOfTheDay, source tidy.

  Future:
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ExtCtrls;

type
  TNvTipOfTheDayForm = class(TForm)
    chkShowTips: TCheckBox;
    CloseBtn: TButton;
    NextTipBtn: TButton;
    TipPanel: TPanel;
    Shape1: TShape;
    BulbImage: TImage;
    LineShape: TShape;
    DidYouLabel: TLabel;
    TipLabel: TLabel;
    procedure CloseBtnClick(Sender: TObject);
  end;

implementation

{$R *.DFM}

procedure TNvTipOfTheDayForm.CloseBtnClick(Sender: TObject);
begin
  Close;
end;

end.
