unit CoolGradient;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolGradient - Gradual color changing gradient fill component

  Change Log
  ----------
  11-Apr-1997   DPG   New component.
  14-Apr-1997   DPG   Code tidy, changed Position to FillPercent.
                      Ensure FillPercent between 0 and 100.
  28-Apr-1997   DPG   Corrected default values & evaluate color first.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
  Any angle gradients.
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TCoolGradientDirection = (gdUp, gdDown, gdLeft, gdRight);
  TCoolGradient = class(TGraphicControl)
  private
    FDirection: TCoolGradientDirection;
    FFillPercent: Integer;
    FColorStart: TColor;
    FColorEnd: TColor;
    procedure SetDirection(Value: TCoolGradientDirection);
    procedure SetColorStart(Value: TColor);
    procedure SetColorEnd(Value: TColor);
    procedure SetFillPercent(Value: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align default alClient;
    property Direction: TCoolGradientDirection read FDirection write SetDirection
             default gdDown;
    property ColorStart: TColor read FColorStart write SetColorStart default clBlack;
    property ColorEnd: TColor read FColorEnd write SetColorEnd default clBlue;
    property FillPercent: Integer read FFillPercent write SetFillPercent default 100;
  end;

type
  TRGB = record
    Red: Integer;
    Green: Integer;
    Blue: Integer;
  end;

function ColorToTRGB(Color: TColor): TRGB;

implementation

{ Create, assign defaults }
constructor TCoolGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
  FDirection := gdDown;
  FFillPercent := 100;
  FColorStart := clBlack;
  FColorEnd := clBlue;
end;

{ Repaint area }
procedure TCoolGradient.Paint;
var
  StartC: TRGB;
  EndC: TRGB;
  DiffC: TRGB;
  GradLen: Integer;
  Index: Integer;
  Steps: Integer;
  BandSize: Single;
  Client: TRect;
  Band: TRect;
  Position: Single;
  Red, Green, Blue: Integer;
begin
  if (FillPercent < 0) or (FillPercent > 100) then Exit;
  
  StartC := ColorToTRGB(FColorStart);
  EndC := ColorToTRGB(FColorEnd);

  { Work out differences }
  DiffC.Red := EndC.Red - StartC.Red;
  DiffC.Green := EndC.Green - StartC.Green;
  DiffC.Blue := EndC.Blue - StartC.Blue;

  { Work out number of steps }
  Client := ClientRect;
  if (FDirection = gdDown) or (FDirection = gdUp) then
     GradLen := Client.Bottom - Client.Top
   else
     GradLen := Client.Right - Client.Left;

  Steps := Abs(DiffC.Red);
  if (Abs(DiffC.Green) > Steps) then Steps := Abs(DiffC.Green);
  if (Abs(DiffC.Blue) > Steps) then Steps := Abs(DiffC.Blue);

  if (Steps > GradLen) then
     Steps := GradLen;

  if Steps = 0 then Steps := 1;

  BandSize := GradLen / Steps;

  Index := 1;
  Position := 0;

  { Draw }
  while (Position < FFillPercent * GradLen div 100) do
    begin
      Canvas.Brush.Color := (StartC.Red + (DiffC.Red * Index div Steps)) +
                            ((StartC.Green + (DiffC.Green * Index div Steps)) * 256) +
                            ((StartC.Blue + (DiffC.Blue * Index div Steps)) * 65536);
      case FDirection of
           gdDown : Band := Rect(Client.Left, Client.Top+Round(Position), Client.Right, Client.Top + Round(Position + BandSize));
           gdUp   : Band := Rect(Client.Left, Client.Bottom-Round(Position), Client.Right, Client.Bottom-Round(Position + BandSize));
           gdRight: Band := Rect(Client.Left+Round(Position), Client.Top, Client.Left+Round(Position + BandSize), Client.Bottom);
           gdLeft : Band := Rect(Client.Right-Round(Position), Client.Top, Client.Right-Round(Position + BandSize), Client.Bottom);
      end;
      Canvas.FillRect(Band);
      inc(Index);
      Position := Position + BandSize;
    end;

end;

{ ColorStart property handler }
procedure TCoolGradient.SetColorStart(Value: TColor);
begin
  if (Value <> FColorStart) then
     begin
       FColorStart := Value;
       Invalidate;
     end;
end;

{ ColorEnd property handler }
procedure TCoolGradient.SetColorEnd(Value: TColor);
begin
  if (Value <> FColorEnd) then
     begin
       FColorEnd := Value;
       Invalidate;
     end;
end;

{ Direction property handler }
procedure TCoolGradient.SetDirection(Value: TCoolGradientDirection);
begin
  if (Value <> FDirection) then
     begin
       FDirection := Value;
       Invalidate;
     end;
end;

{ Position property handler }
procedure TCoolGradient.SetFillPercent(Value: Integer);
begin
  if (Value <> FFillPercent) and (Value >= 0) and (Value <= 100) then
     begin
       FFillPercent := Value;
       Invalidate;
     end;
end;

{ Convert color to RGB elements }
function ColorToTRGB(Color: TColor): TRGB;
var
  RGB: Integer;
begin
  RGB := ColorToRGB(Color);
  with Result do
   begin
    Red := Byte(RGB);
    Green := Byte(RGB shr 8);
    Blue := Byte(RGB shr 16);
   end;
end;

end.

