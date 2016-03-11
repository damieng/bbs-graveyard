unit NvRoutines;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvRoutines          "Various routines used internally"
  Type:     Routines
  Contains:
  Version:  v1.0

  Changes:  22-Jul-1997   DPG   New unit from existing routines.
            05-Aug-1997   DPG   Renamed to NvRoutines, source tidy.

  Future:
*******************************************************************************}

interface

uses Graphics, Windows;

type
  TRGB = record
    Red: Integer;
    Green: Integer;
    Blue: Integer;
  end;

function GetItemHeight(Font: TFont): Integer;
function  RGBToColor(Red, Green, Blue: Integer): TColor;
function  ColorToTRGB(Color: TColor): TRGB;
procedure CenterText(Canvas: TCanvas; Area: TRect; const Text: String);
procedure DrawSmartFrame(Canvas: TCanvas; R: TRect; IsDown:
          Boolean; IsFocused: Boolean);

implementation

{ Get minimum item height for this font }
function GetItemHeight(Font: TFont): Integer;
var
  DC: HDC;
  SaveFont: HFont;
  Metrics: TTextMetric;
begin
  DC := GetDC(0);
  SaveFont := SelectObject(DC, Font.Handle);
  GetTextMetrics(DC, Metrics);
  SelectObject(DC, SaveFont);
  ReleaseDC(0, DC);
  Result := Metrics.tmHeight;
end;

{ Function to convert RGB values to a TColor }
function RGBToColor(Red, Green, Blue: Integer): TColor;
begin
  Result := Red + (Green * 256) + (Blue * 65536);
end;

{ Convert color to RGB elements }
function ColorToTRGB(Color: TColor): TRGB;
var
  RGB: Integer;
begin
  RGB := ColorToRGB(Color);
  with Result do
    begin
      Red   := Byte(RGB);
      Green := Byte(RGB shr 8);
      Blue  := Byte(RGB shr 16);
    end;
end;

{ Center text on a canvas/trect }
procedure CenterText(Canvas: TCanvas; Area: TRect; const Text: String);
var
  TextX, TextY: Integer;
begin
  with Canvas do
    begin
      TextX := TextWidth(Text);
      TextY := TextHeight(Text);
      TextOut(((Area.Right - Area.Left) div 2) - (TextX div 2) + Area.Left,
              ((Area.Bottom - Area.Top) div 2) - (TextY div 2) + Area.Top,
              Text);
    end;
end;

{ Custom routine for drawing a button frame (New style only) }
procedure DrawSmartFrame(Canvas: TCanvas; R: TRect; IsDown: Boolean;
          IsFocused: Boolean);
var
  High1, High2, Shad1, Shad2: TColor;
begin
  { Windows API version Req. NT4/Win95}
  if IsDown then
     DrawEdge(Canvas.Handle, R, EDGE_SUNKEN, BF_RECT or BF_MIDDLE)
   else
     DrawEdge(Canvas.Handle, R, EDGE_RAISED, BF_RECT or BF_MIDDLE);
end;

end.
