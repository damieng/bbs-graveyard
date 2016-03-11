unit NvShade;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvShade
  Type:     Component
  Contains: TNvShade            "Borland C++ style shading control"
                                Inspired by Borland C++ OWL.
  Version:  v1.0

  Changes:  03-Mar-1997   DPG   Created from existing EnvyDCP.
            01-Apr-1997   DPG   Final code tidy.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvShade, source tidy.

  Future:
*******************************************************************************}

interface

uses Classes, Controls, Graphics;

type
  TNvShadeStyle = (ssBorland, ssLight, ssHeavy);

  TNvShade = class(TGraphicControl)
  private
    BrushBitmap: TBitmap;
    FBackColor: TColor;
    FForeColor: TColor;
    FShadeStyle: TNvShadeStyle;
    procedure SetBackColor(Value: TColor);
    procedure SetForeColor(Value: TColor);
    procedure SetShadeStyle(Value: TNvShadeStyle);
  public
    constructor Create(AOwner: TComponent); override;
    procedure Paint; override;
    destructor Destroy; override;
  published
    property Align default alClient;
    property BackColor: TColor read FBackColor write SetBackColor
             default clSilver;
    property Enabled;
    property ForeColor: TColor read FForeColor write SetForeColor
             default clWhite;
    property ParentShowHint;
    property PopupMenu;
    property ShadeStyle: TNvShadeStyle read FShadeStyle write SetShadeStyle
             default ssBorland;
    property ShowHint;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

{ Create object, assign defaults, create bitmap }
constructor TNvShade.Create(AOwner : TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
  FBackColor := clSilver;
  FForeColor := clWhite;
  FShadeStyle := ssBorland;
  BrushBitmap := TBitmap.Create;
  BrushBitmap.Height := 4;
  BrushBitmap.Width := 4;
end;

{ Release bitmap, destroy object }
destructor TNvShade.Destroy;
begin
  BrushBitmap.Free;
  inherited Destroy;
end;

{ Set the foreground color }
procedure TNvShade.SetForeColor(Value: TColor);
begin
  if (Value <> FForeColor) then
     begin
       FForeColor := Value;
       Invalidate;
     end;
end;

{ Set the background color }
procedure TNvShade.SetBackColor(Value: TColor);
begin
  if (Value <> FBackColor) then
     begin
       FBackColor := Value;
       Invalidate;
     end;
end;

{ Set the shading style }
procedure TNvShade.SetShadeStyle(Value: TNvShadeStyle);
begin
  if (Value <> FShadeStyle) then
     begin
       FShadeStyle := Value;
       Invalidate;
     end;
end;

{ Repaint the shade control }
procedure TNvShade.Paint;
begin
  { Build the desired brush image }
  BrushBitmap.Canvas.Brush.Color := FBackColor;
  BrushBitmap.Canvas.FillRect(Rect(0,0,4,4));
  BrushBitmap.Canvas.Pixels[0,0] := FForeColor;
  BrushBitmap.Canvas.Pixels[2,0] := FForeColor;

  { Render brush image in selected style }
  case FShadeStyle of
       ssBorland : begin
                     BrushBitmap.Canvas.Pixels[0,2] := FForeColor;
                     BrushBitmap.Canvas.Pixels[2,2] := FForeColor;
                   end;
       ssLight   : begin
                     BrushBitmap.Canvas.Pixels[1,2] := FForeColor;
                     BrushBitmap.Canvas.Pixels[3,2] := FForeColor;
                   end;
       ssHeavy   : begin
                     BrushBitmap.Canvas.Pixels[0,2] := FForeColor;
                     BrushBitmap.Canvas.Pixels[1,1] := FForeColor;
                     BrushBitmap.Canvas.Pixels[1,3] := FForeColor;
                     BrushBitmap.Canvas.Pixels[2,2] := FForeColor;
                     BrushBitmap.Canvas.Pixels[3,1] := FForeColor;
                     BrushBitmap.Canvas.Pixels[3,3] := FForeColor;
                   end;
  end;

  { Paint the shade image tiled over the client area }
  Canvas.Brush.Bitmap := BrushBitmap;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.Brush.Bitmap := nil;
end;

end.
