unit NvProgressBar;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvProgressBar
  Type:     Component
  Contains: TNvProgressBar      "Graphic-image progress indicator"
                                Inspired by Apple QuickTime installer.
  Version:  v1.0

  Changes:  22-Jul-1997   DPG   New component.
            05-Aug-1997   DPG   Renamed to TNvProgressBar, source tidy.
                                Optimization to reduce redraw flicker.
            07-Aug-1997   DPG   Correct odd problem with bitmap sizes.

  Future:
*******************************************************************************}

interface

uses Windows, Classes, Controls, Graphics, Messages, SysUtils, NvRoutines;

type
  TNvProgressBevel = (bvNone, bvLowered, bvRaised);

  TNvProgressOrientation = (poHorizontal, poVertical);

  TNvProgressBar = class(TGraphicControl)
  private
    FBevelInner: TNvProgressBevel;
    FBevelOuter: TNvProgressBevel;
    FBitmap: TBitmap;
    FOrientation: TNvProgressOrientation;
    FPosition: Integer;
    FShowPosition: Boolean;
    procedure SetBevelInner(Value: TNvProgressBevel);
    procedure SetBevelOuter(Value: TNvProgressBevel);
    procedure SetBitmap(Value: TBitmap);
    procedure SetOrientation(Value: TNvProgressOrientation);
    procedure SetPosition(Value: Integer);
    procedure SetShowPosition(Value: Boolean);
  public
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property BevelInner: TNvProgressBevel read FBevelInner write SetBevelInner
             default bvLowered;
    property BevelOuter: TNvProgressBevel read FBevelOuter write SetBevelOuter
             default bvLowered;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Caption;
    property Color;
    property Cursor;
    property Font;
    property Orientation: TNvProgressOrientation read FOrientation
             write SetOrientation default poHorizontal;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property Position: Integer read FPosition write SetPosition default 0;
    property ShowHint;
    property ShowPosition: Boolean read FShowPosition write SetShowPosition
             default False;
  end;

implementation

{ Create object, create bitmap }
constructor TNvProgressBar.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alNone;
  ControlStyle := ControlStyle + [csOpaque];
  Height := 16;
  Width := 150;
  FBevelInner := bvLowered;
  FBevelOuter := bvLowered;
  FOrientation := poHorizontal;
  FPosition := 0;
  FShowPosition := False;
  FBitmap := TBitmap.Create;
end;

{ Release bitmap, destroy object }
destructor TNvProgressBar.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

{ Paint handler }
procedure TNvProgressBar.Paint;
var
  Area, Full, Empty: TRect;
begin
  Area := ClientRect;

  { Draw borders }
  case BevelOuter of
    bvLowered:
       DrawEdge(Canvas.Handle, Area, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
    bvRaised:
       DrawEdge(Canvas.Handle, Area, BDR_RAISEDOUTER, BF_RECT or BF_ADJUST);
  end;

  case BevelInner of
    bvLowered:
       DrawEdge(Canvas.Handle, Area, BDR_SUNKENINNER, BF_RECT or BF_ADJUST);
    bvRaised:
       DrawEdge(Canvas.Handle, Area, BDR_RAISEDINNER, BF_RECT or BF_ADJUST);
  end;

  { Calculate filled area }
  Full := Area;
  Empty := Area;
  case Orientation of
    poHorizontal: begin
                    Full.Right := Area.Left + (Position *
                                  (Area.Right - Area.Left) div 100);
                    Empty.Left := Full.Right;
                  end;
    poVertical:   begin
                    Full.Top := Area.Bottom - (Position *
                                (Area.Bottom - Area.Top) div 100);
                    Empty.Bottom := Full.Top;
                  end;
  end;

  { Fill the areas }
  with Canvas do
    begin
      { Full }
      Brush.Bitmap := FBitmap;
      FillRect(Full);
      Brush.Bitmap := nil;
      { Empty }
      Brush.Style := bsSolid;
      Brush.Color := Color;
      FillRect(Empty);
    end;

  if ShowPosition then
     begin
       Canvas.Font := Font;
       Canvas.Brush.Style := bsClear;
       CenterText(Canvas, Area, IntToStr(FPosition)+'%');
     end;
end;

{ Assign a bitmap to our tile object }
procedure TNvProgressBar.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
  Invalidate;
end;

{ Repaint the inner bevel when changed }
procedure TNvProgressBar.SetBevelInner(Value: TNvProgressBevel);
begin
  if (Value <> FBevelInner) then
     begin
       FBevelInner := Value;
       Repaint;
     end;
end;

{ Repaint the outer bevel when changed }
procedure TNvProgressBar.SetBevelOuter(Value: TNvProgressBevel);
begin
  if (Value <> FBevelOuter) then
     begin
       FBevelOuter := Value;
       Repaint;
     end;
end;

{ Repaint when the position changes }
procedure TNvProgressBar.SetPosition(Value: Integer);
begin
  if (Value <> FPosition) and (Value >=0) and (Value <=100) then
     begin
       FPosition := Value;
       Repaint;
     end;
end;

{ Repaint when the orientation changes }
procedure TNvProgressBar.SetOrientation(Value: TNvProgressOrientation);
begin
  if (Value <> FOrientation) then
     begin
       FOrientation := Value;
       Repaint;
     end;
end;

{ Repaint when the position changes }
procedure TNvProgressBar.SetShowPosition(Value: Boolean);
begin
  if (Value <> FShowPosition) then
     begin
       FShowPosition := Value;
       Repaint;
     end;
end;

end.
