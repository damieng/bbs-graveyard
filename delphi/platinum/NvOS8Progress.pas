unit NvOS8Progress;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  TNvOS8Progress - Progress Control v0.5

  Amendment Log
  =============
  10/Feb/1998  DamienG    New control
  16/Mar/1998  DamienG    Added new orientation property for vertical/horizontal
  20/May/1999  DamienG    Fixed vertical orientation.
                          Added experimental 3D support - Limitations:
                                Currently hard-coded colours (will be shade-based)
                                Currently horizontal only (Will have to check Mac)
                                Currently 14 pixel-height control only (???)
                          Need still to optimize 2D painting again
                          Indeterminate version???
  Notes
  =====
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  NvOS8ColorServer;

type
  TNvOS8Orientation = (orVertical, orHorizontal);
  TNvOS8Style = (st2D, st3D);
  TNvOS8Progress = class(TGraphicControl)
  private
    FNvOS8ColorServer: TNvOS8ColorServer;
    FOrientation: TNvOS8Orientation;
    FPosition: Integer;
    BaseShade: TShade;
    FillShade: TShade;
    FStyle: TNvOS8Style;
    procedure SetOrientation(Value: TNvOS8Orientation);
    procedure SetNvOS8ColorServer(Value: TNvOS8ColorServer);
    procedure SetPosition(Value: Integer);
    procedure SetStyle(Value: TNvOS8Style);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property ColorServer: TNvOS8ColorServer read FNvOS8ColorServer write SetNVOS8ColorServer;
    property Orientation: TNvOS8Orientation read FOrientation write SetOrientation default orHorizontal;
    property Position: Integer read FPosition write SetPosition default 50;
    property Style: TNvOs8Style read FStyle write SetStyle default st2D;
  end;

implementation

constructor TNvOS8Progress.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FOrientation := orHorizontal;
  FPosition := 50;
  FStyle := st2D;
  Height := 12;
  Width := 100;
  ControlStyle := [csSetCaption, csOpaque];
end;

procedure TNvOS8Progress.Paint;
var
  MidPoint: Integer;
  FullRect: TRect;
  FilledRect: TRect;
  BackRect: TRect;
begin
  FilledRect := ClientRect;
  if (FStyle=st2D) then
     InflateRect(FilledRect,-1,-1)
  else
     InflateRect(FilledRect,-2,-2);

  BackRect := FilledRect;
  if (Orientation = orHorizontal) then
     begin
       MidPoint := FilledRect.Left + Round((FilledRect.Right-FilledRect.Left) / 100 * FPosition);
       FilledRect.Right := MidPoint;
       BackRect.Left := MidPoint;
     end
  else
     begin
       MidPoint := FilledRect.Bottom-Round((FilledRect.Bottom-FilledRect.Top) / 100 * FPosition);
       FilledRect.Top := MidPoint;
       BackRect.Bottom := MidPoint;
     end;

  with Canvas do
     begin
       FullRect := ClientRect;
       if (FStyle=st3D) then
          begin
            with FullRect do
                 begin
                      Pen.Color := BaseShade.C[10];
                      MoveTo(Left, Bottom-2);
                      LineTo(Left, Top);
                      LineTo(Right-1, Top);
                      Pen.Color := BaseShade.C[15];
                      MoveTo(Left+1, Bottom-1);
                      LineTo(Right-1, Bottom-1);
                      LineTo(Right-1, Top);
                 end;
            InflateRect(FullRect, -1, -1);
            Brush.Color := BaseShade.C[0];
            FrameRect(FullRect);

            if FPosition < 100 then
               begin
                 Brush.Color := BaseShade.C[12];
                 FillRect(BackRect);
                 Pen.Color := BaseShade.C[0];
                 MoveTo(BackRect.Left-1, BackRect.Top);
                 LineTo(BackRect.Left-1, BackRect.Bottom);
                 dec(FilledRect.Right);
                 Pen.Color := BaseShade.C[5];
                 MoveTo(BackRect.Left, BackRect.Top);
                 LineTo(BackRect.Left, BackRect.Bottom);
                 Pen.Color := BaseShade.C[8];
                 MoveTo(BackRect.Left+1, BackRect.Bottom-2);
                 LineTo(BackRect.Left+1, BackRect.Top);
                 LineTo(BackRect.Right-1, BackRect.Top);
                 Pen.Color := BaseShade.C[13];
                 MoveTo(BackRect.Left+2, BackRect.Bottom-1);
                 LineTo(BackRect.Right-1, BackRect.Bottom-1);
                 LineTo(BackRect.Right-1, BackRect.Top);
               end;
            if FPosition > 0 then
               if (Orientation = orHorizontal) then
               begin
                 Pen.Color := FillShade.C[7];
                 MoveTo(FilledRect.Left, FilledRect.Top);
                 LineTo(FilledRect.Left, FilledRect.Bottom);
                 Pixels[FilledRect.Left+1, FilledRect.Top] := FillShade.C[7];
                 Pixels[FilledRect.Left+1, FilledRect.Top+1] := FillShade.C[8];
                 Pixels[FilledRect.Left+1, FilledRect.Top+2] := FillShade.C[9];

                 Pen.Color := FillShade.C[10];
                 MoveTo(FilledRect.Left+1, FilledRect.Top+3);
                 LineTo(FilledRect.Left+1, FilledRect.Bottom-4);
                 Pixels[FilledRect.Left+1, FilledRect.Bottom-4] := FillShade.C[9];
                 Pixels[FilledRect.Left+1, FilledRect.Bottom-3] := FillShade.C[8];
                 Pixels[FilledRect.Left+1, FilledRect.Bottom-2] := FillShade.C[7];
                 Pixels[FilledRect.Left+1, FilledRect.Bottom-1] := FillShade.C[6];

                 Pen.Color := FillShade.C[5];
                 MoveTo(FilledRect.Left+2, FilledRect.Bottom-1);
                 LineTo(FilledRect.Right, FilledRect.Bottom-1);
                 Pen.Color := FillShade.C[6];
                 MoveTo(FilledRect.Left+2, FilledRect.Top);
                 LineTo(FilledRect.Right, FilledRect.Top);
                 MoveTo(FilledRect.Left+2, FilledRect.Bottom-2);
                 LineTo(FilledRect.Right, FilledRect.Bottom-2);
                 Pen.Color := FillShade.C[7];
                 MoveTo(FilledRect.Left+2, FilledRect.Top+1);
                 LineTo(FilledRect.Right, FilledRect.Top+1);
                 MoveTo(FilledRect.Left+2, FilledRect.Bottom-3);
                 LineTo(FilledRect.Right, FilledRect.Bottom-3);
                 Pen.Color := FillShade.C[8];
                 MoveTo(FilledRect.Left+2, FilledRect.Top+2);
                 LineTo(FilledRect.Right, FilledRect.Top+2);
                 MoveTo(FilledRect.Left+2, FilledRect.Bottom-4);
                 LineTo(FilledRect.Right, FilledRect.Bottom-4);
                 Pen.Color := FillShade.C[9];
                 MoveTo(FilledRect.Left+2, FilledRect.Top+3);
                 LineTo(FilledRect.Right, FilledRect.Top+3);
                 MoveTo(FilledRect.Left+2, FilledRect.Bottom-5);
                 LineTo(FilledRect.Right, FilledRect.Bottom-5);
                 Brush.Color := FillShade.C[10];
                 FillRect(Rect(FilledRect.Left+2, FilledRect.Top+4,FilledRect.Right,FilledRect.Bottom-5));

                 Pen.Color := FillShade.C[5];
                 MoveTo(FilledRect.Right-1, FilledRect.Bottom-1);
                 LineTo(FilledRect.Right-1, FilledRect.Top);
                 Pen.Color := FillShade.C[6];
                 MoveTo(FilledRect.Right-2, FilledRect.Bottom-2);
                 LineTo(FilledRect.Right-2, FilledRect.Top+1);
                 Pen.Color := FillShade.C[9];
                 MoveTo(FilledRect.Right-3, FilledRect.Top+4);
                 LineTo(FilledRect.Right-3, FilledRect.Bottom-4);
                 end
               else
                 begin
                   Brush.Color := FillShade.C[7];
                   FillRect(FilledRect);
               end;
          end
      else
        begin
          Brush.Color := clBlack;
          FrameRect(FullRect);
          Brush.Color := FillShade.C[7];
          FillRect(FilledRect);
          Brush.Color := BaseShade.C[7];
          FillRect(BackRect);
        end;
  end;
end;

procedure TNvOS8Progress.SetOrientation(Value: TNvOS8Orientation);
begin
  if (Value <> FOrientation) then
     begin
       FOrientation := Value;
       Repaint;
     end;
end;

procedure TNvOS8Progress.SetPosition(Value: Integer);
begin
  if (Value <> FPosition) and (Value >= 0) and (Value <= 100) then
     begin
       FPosition := Value;
       Repaint;
     end;
end;

procedure TNvOS8Progress.SetStyle(Value: TNvOS8Style);
begin
  if (Value <> FStyle) then
     begin
       FStyle := Value;
       Repaint;
     end;
end;

procedure TNvOS8Progress.SetNVOs8ColorServer(Value: TNvOS8ColorServer);
begin
  if (Value <> FNvOS8ColorServer) then
     begin
       FNvOS8ColorServer := Value;
       BaseShade := FNvOS8ColorServer.BaseShade;
       FillShade := FNvOS8ColorServer.AccentShade;
       Repaint;
     end;
end;

end.
