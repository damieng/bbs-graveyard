unit RegisterNv;

{*******************************************************************************
  Envy Development Pack for Delphi 6
  Copyright (c) 1996-2002 Envy Technologies Ltd.  All rights reserved.

  Unit:     RegisterNv          "Register all non-DB aware components"
  Type:     Registration
  Contains: Code to register components in the Delphi IDE
  Version:  v2.0

  Changes:  13-Oct-2002   DPG   New Delphi 6 packages with source.
*******************************************************************************}

interface

uses Classes;

procedure Register;

implementation

uses NvAboutDlg, NvCheckBox, NvColorListBox, NvColorPick,
        NvFontCombo, NvFrame, NvGradient, NvImageView, NvLabel, NvListView,
        NvMenuBtn, NvProgressBar, NvShade, NvSplitter, NvTileBitmap,
        NvTipOfTheDay;

{ Modify if you wish to use only selected components instead of whole package }
procedure Register;
begin
  RegisterComponents('Envy',
          [TNvAboutDlg,              { Windows 95/NT style Help > About }
           TNvCheckBox,              { Checkbox with ReadOnly option }
           TNvColorListBox,          { Listbox color selector }
           TNvColorPickBtn,          { Color pick button as in IE 3 properties }
           TNvFontCombo,             { Font combo box }
           TNvFrame,                 { Windows 95/NT frame }
           TNvGradient,              { Color shading gradient }
           TNvImageView,             { TImage component for ImageLists }
           TNvLabel,                 { Label with execute, ellipses and 3D }
           TNvListView,              { ListView with automatic sorting }
           TNvMenuBtn,               { Button to display a popup menu }
           TNvProgressBar,           { Progress bar with image support }
           TNvShade,                 { Borland C++ style shading }
           TNvSplitter,              { Panel resizer/splitter }
           TNvTileBitmap,            { Tile area with a bitmap }
           TNvTipOfTheDay]);         { Developer Studio style tip-of-the-day }
end;

end.

