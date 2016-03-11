unit NvAboutDlgForm;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvAboutDlgForm
  Type:     Component Form
  Contains: TNvAboutDlgForm     "Help > About dialog form"
                                Inspired by Windows 95/NT system about dialog.
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2.0 version.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvAboutDlgForm, source tidy.

  Future:
*******************************************************************************}

interface

uses Classes, Forms, Controls, StdCtrls, ExtCtrls;

type
  TNvAboutDlgForm = class(TForm)
    imgPro: TImage;
    b1: TBevel;
    cmdOK: TButton;
    lPhy: TLabel;
    lRAM: TLabel;
    lPro: TLabel;
    lVer: TLabel;
    lCop: TLabel;
    lReg: TLabel;
    lUsr: TLabel;
    lCom: TLabel;
    lWVe: TLabel;
  end;

implementation

{$R *.DFM}

end.
