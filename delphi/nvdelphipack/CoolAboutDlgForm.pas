unit CoolAboutDlgForm;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolAboutDlgForm v0.9 - Help > About Dialog Form

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2.0 version.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
*******************************************************************************}

interface

uses Classes, Forms, Controls, StdCtrls, ExtCtrls;

type
  TCoolAboutDlgForm = class(TForm)
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
