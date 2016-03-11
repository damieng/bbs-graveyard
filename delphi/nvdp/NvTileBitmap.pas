unit NvTileBitmap;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvTileBitmap
  Type:     Component
  Contains: TNvTileBitmap       "Tile a bitmap over a selected region"
  Version:  v1.0

  Changes:  03-Mar-1997   DPG   Created from existing EnvyDCP.
            01-Apr-1997   DPG   Final code tidy.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvTileBitmap, source tidy.

  Future:
*******************************************************************************}

interface

uses Classes, Controls, Graphics, Messages;

type
  TNvTileBitmap = class(TGraphicControl)
  private
    FBitmap: TBitmap;
    procedure SetBitmap(Value: TBitmap);
  public
    procedure Paint; override;
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align default alClient;
    property Bitmap: TBitmap read FBitmap write SetBitmap;
    property Enabled;
    property ParentShowHint;
    property PopupMenu;
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

{ Create object, create bitmap }
constructor TNvTileBitmap.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Align := alClient;
  FBitmap := TBitmap.Create;
end;

{ Release bitmap, destroy object }
destructor TNvTileBitmap.Destroy;
begin
  FBitmap.Free;
  inherited Destroy;
end;

{ Tile the bitmap over the client area }
procedure TNvTileBitmap.Paint;
begin
  Canvas.Brush.Bitmap := FBitmap;
  Canvas.FillRect(Canvas.ClipRect);
  Canvas.Brush.Bitmap := nil;
end;

{ Assign a bitmap to our tile object }
procedure TNvTileBitmap.SetBitmap(Value: TBitmap);
begin
  FBitmap.Assign(Value);
  Invalidate;
end;

end.
