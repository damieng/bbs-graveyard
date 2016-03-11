unit RegisterCool;

{ EnvyDP      Envy Technologies Delphi Pack-32
  Written by: Damien Guard, Envy Technologies <envy@guernsey.net>
  Version:    1.1 (21-May-97)   http://www.guernsey.net/~envy
  Status:     FREEWARE for non-commercial use.
              MUST BE REGISTERED FOR SHAREWARE/COMMERCIAL SOFTWARE.
              Component source provided on registration.
              No warranty expressed or implied.  Use at your own risk.
  Copyright:  Copyright © 1996-1997 Envy Technologies.
  Notes:      This component library is now Delphi 3 compatible at source level.
              Please note that Delphi 2 and 3 DCU's are NOT compatible.  }

interface

uses Classes;

procedure Register;

implementation

uses CoolListView, CoolCheckBox, CoolAboutDlg, CoolShade, CoolColorCombo,
     CoolTileBitmap, CoolMenuBtn, CoolColorPick, CoolTipOfTheDay,
     CoolLabel, CoolFontCombo, CoolApplication, CoolSplitter,
     CoolGradient;

{ Register the components with the IDE - Modify if you wish to use only
  selected components instead of the entire package. }
procedure Register;
begin
  RegisterComponents('Envy',
          [TCoolAboutDlg,              { Windows 95/NT style Help > About }
           TCoolApplication,           { Application wrapper }
           TCoolCheckBox,              { Checkbox with ReadOnly option }
           TCoolColorCombo,            { Drop-down color combo selector }
           TCoolColorPickBtn,          { Color pick button as in IE 3 properties }
           TCoolFontCombo,             { Font combo box }
           TCoolGradient,              { Color shading gradient }
           TCoolLabel,                 { Label with execute, ellipses and 3D }
           TCoolListView,              { ListView with automatic sorting }
           TCoolMenuBtn,               { Button to display a popup menu }
           TCoolShade,                 { Borland C++ style shading }
           TCoolSplitter,              { Panel resizer/splitter }
           TCoolTileBitmap,            { Tile area with a bitmap }
           TCoolTipOfTheDay]);         { Developer Studio style tip-of-the-day }
end;

end.

