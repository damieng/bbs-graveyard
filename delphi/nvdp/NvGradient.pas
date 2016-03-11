unit NvGradient;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvGradient
  Type:     Component
  Contains: TNvGradient         "Gradual color changing gradient fill component"
                                Inspired by setup programs everywhere.
  Version:  v1.0

  Changes:  11-Apr-1997   DPG   New component.
            14-Apr-1997   DPG   Code tidy, changed Position to FillPercent.
                                Ensure FillPercent between 0 and 100.
            28-Apr-1997   DPG   Corrected default values & evaluate color first.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            26-Jun-1997   DPG   Optimized repaint for increasing percent fill.
            05-Aug-1997   DPG   Renamed to TNvGradient, source tidy.
            07-Aug-1997   DPG   Changed default colors to match SETUP.EXE's.

  Future:   Any angle gradients.
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NvRoutines;

type
  TNvGradientDirection = (gdUp, gdDown, gdLeft, gdRight);

  TNvGradient = class(TGraphicControl)
  private
    FColorEnd: TColor;
    FColorStart: TColor;
    FDirection: TNvGradientDirection;
    FFillPercent: Integer;
    procedure SetColorEnd(Value: TColor);
    procedure SetColorStart(Value: TColor);
    procedure SetDirection(Value: TNvGradientDirection);
    procedure SetFillPercent(Value: Integer);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align default alClient;
    property ColorStart: TColor read FColorStart write SetColorStart
             default clBlue;
    property ColorEnd: TColor read FColorEnd write SetColorEnd default clBlack;
    property Direction: TNvGradientDirection read FDirection
             write SetDirection default gdDown;
    property FillPercent: Integer read FFillPercent
             write SetFillPercent default 100;
  end;

implementation

{ Create object, assign defaults }
constructor TNvGradient.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
  ControlStyle := ControlStyle + [csOpaque];

  FColorEnd := clBlack;
  FColorStart := clBlue;
  FDirection := gdDown;
  FFillPercent := 100;
end;

{ Repaint area }
procedure TNvGradient.Paint;
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
procedure TNvGradient.SetColorStart(Value: TColor);
begin
  if (Value <> FColorStart) then
     begin
       FColorStart := Value;
       Invalidate;
     end;
end;

{ ColorEnd property handler }
procedure TNvGradient.SetColorEnd(Value: TColor);
begin
  if (Value <> FColorEnd) then
     begin
       FColorEnd := Value;
       Invalidate;
     end;
end;

{ Direction property handler }
procedure TNvGradient.SetDirection(Value: TNvGradientDirection);
begin
  if (Value <> FDirection) then
     begin
       FDirection := Value;
       Invalidate;
     end;
end;

{ Position property handler }
procedure TNvGradient.SetFillPercent(Value: Integer);
begin
  if (Value <> FFillPercent) and (Value >= 0) and (Value <= 100) then
     begin
       FFillPercent := Value;
       Repaint;
     end;
end;

end.

