unit NvOS8Routines;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  TNvOS8Routines - Common routines used by the controls

  Amendment Log
  =============
  10/Feb/1997  DamienG    New unit created to share colour-shading code
  26/Jul/1998  DamienG    Changed TShade to record type for C++Builder compatibility

  Notes
  -----
  1. C++ Builder does not like passing back an array....
  }

interface

uses Classes, Graphics;

type
   TShade = record
     C: Array[0..15] of TColor;
   end;

function LoadShades(BaseColor: TColor): TShade;
function ShadeColor(BaseColor: TColor; Offset: Integer): TColor;
function AccentShades(BaseColor: TColor; Distance: Integer): TShade;

implementation

function AccentShades(BaseColor: TColor; Distance: Integer): TShade;
var
  Index: Integer;
begin
  for Index := 0 to 7 do
      Result.C[Index] := ShadeColor(BaseColor, -(7-Index)*30);
  for Index := 8 to 15 do
      Result.C[Index] := ShadeColor(BaseColor, (Index-7)*30);
end;

function LoadShades(BaseColor: TColor): TShade;
var
  Index: Integer;
begin
  for Index := 0 to 7 do
      Result.C[Index] := ShadeColor(BaseColor, -(7-Index)*17);
  for Index := 8 to 15 do
      Result.C[Index] := ShadeColor(BaseColor, (Index-7)*17);
end;

{ Take the base colour and apply desire shade-offset from base }
function ShadeColor(BaseColor: TColor; Offset: Integer): TColor;
var
  Red, Green, Blue: Integer;
begin
  Red := (BaseColor and $FF) + Offset;
  Green := ((BaseColor and $FF00) div 256) + Offset;
  Blue := ((BaseColor and $FF0000) div 65536) + Offset;
  if (Red > $FF) then Red := $FF;
  if (Red < $00) then Red := $00;
  if (Green > $FF) then Green := $FF;
  if (Green < $00) then Green := $00;
  if (Blue > $FF) then Blue := $FF;
  if (Blue < $00) then Blue := $00;
  Result := (Blue*65536) + (Green*256) + Red;
end;

end.
