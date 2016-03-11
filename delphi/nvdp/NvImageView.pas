unit NvImageView;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvImageView
  Type:     Component
  Contains: TNvImageView        "View an image in an imagelist"
  Version:  v1.0

  Changes:  09-Aug-1997   DPG   New component.
            10-Aug-1997   DPG   Added support to repaint if imagelist changes.

  Future:
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, ImgList;

type
  TNvImageView = class(TGraphicControl)
  private
    FAutoSize: Boolean;
    FCenter: Boolean;
    FImageList: TImageList;
    FImageIndex: Integer;
    FImageChangeLink: TChangeLink;
    FPicture: TPicture;
    FStretch: Boolean;
    FTransparent: Boolean;
    procedure ImageListChange(Sender: TObject);
    procedure SetAutoSize(Value: Boolean);
    procedure SetCenter(Value: Boolean);
    procedure SetImageIndex(Value: Integer);
    procedure SetImageList(Value: TImageList);
    procedure SetStretch(Value: Boolean);
    procedure SetTransparent(Value: Boolean);
  protected
    function DestRect: TRect;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
    procedure Paint; override;
    procedure UpdatePicture;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Align;
    property AutoSize: Boolean read FAutoSize write SetAutoSize default False;
    property Center: Boolean read FCenter write SetCenter default False;
    property DragCursor;
    property DragMode;
    property Hint;
    property ImageIndex: Integer read FImageIndex write SetImageIndex;
    property ImageList: TImageList read FImageList write SetImageList;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property Stretch: Boolean read FStretch write SetStretch default False;
    property Transparent: Boolean read FTransparent write SetTransparent default False;
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

constructor TNvImageView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FPicture := TPicture.Create;
  ControlStyle := ControlStyle + [csReplicatable];
  FAutoSize := False;
  FCenter := False;
  FStretch := False;
  FTransparent := False;
  FImageChangeLink := TChangeLink.Create;
  FImageChangeLink.OnChange := ImageListChange;
  Width := 105;
  Height := 105;
end;

destructor TNvImageView.Destroy;
begin
  FPicture.Free;
  FImageChangeLink.Free;
  inherited Destroy;
end;

procedure TNvImageView.Loaded;
begin
  inherited Loaded;
  UpdatePicture;
end;

procedure TNvImageView.SetAutoSize(Value: Boolean);
begin
  FAutoSize := Value;
  UpdatePicture;
end;

procedure TNvImageView.SetCenter(Value: Boolean);
begin
  if (Value <> FCenter) then
     begin
       FCenter := Value;
       UpdatePicture;
     end;
end;

procedure TNvImageView.SetImageIndex(Value: Integer);
begin
  if (Value <> FImageIndex) then
     begin
       FImageIndex := Value;
       UpdatePicture;
     end;
end;

procedure TNvImageView.SetImageList(Value: TImageList);
begin
  if Assigned(FImageList) then
     FImageList.UnRegisterChanges(FImageChangeLink);

  if (Value <> FImageList) then
     begin
       FImageList := Value;
       FImageList.RegisterChanges(FImageChangeLink);
       UpdatePicture;
     end;
end;

procedure TNvImageView.UpdatePicture;
var
  TempBitmap: TBitmap;
begin
  if Assigned(FImageList) then
     begin
       TempBitmap := TBitmap.Create;
       if (ImageIndex > -1) then FImageList.GetBitmap(FImageIndex, TempBitmap);
       FPicture.Assign(TempBitmap);
       TempBitmap.Free;
     end;

  if AutoSize and
    (FPicture.Width > 0) and (FPicture.Height > 0) then
    SetBounds(Left, Top, FPicture.Width, FPicture.Height);

  if Assigned(FImageList) then
     begin
       FPicture.Graphic.Transparent := FTransparent;
       if (not FPicture.Graphic.Transparent) and
          (Stretch or (FPicture.Width >= Width) and
          (FPicture.Height >= Height)) then
          ControlStyle := ControlStyle + [csOpaque]
        else
          ControlStyle := ControlStyle - [csOpaque];
     end
  else
     ControlStyle := ControlStyle - [csOpaque];
  Invalidate;
end;

procedure TNvImageView.Paint;
begin
  if (csDesigning in ComponentState) then
     with inherited Canvas do
     begin
       Pen.Style := psDash;
       Brush.Style := bsClear;
       Rectangle(0, 0, Width, Height);
     end;
  with inherited Canvas do
    StretchDraw(DestRect, FPicture.Graphic);
end;

procedure TNvImageView.SetStretch(Value: Boolean);
begin
  if (Value <> FStretch) then
     begin
       FStretch := Value;
       UpdatePicture;
     end;
end;

procedure TNvImageView.SetTransparent(Value: Boolean);
begin
  if (Value <> FTransparent) then
     begin
       FTransparent := Value;
       UpdatePicture;
     end;
end;

function TNvImageView.DestRect: TRect;
begin
  if Stretch then
    Result := ClientRect
  else
    if Center then
       Result := Bounds((Width - FPicture.Width) div 2, (Height - FPicture.Height)
              div 2, FPicture.Width, FPicture.Height)
    else
      Result := Rect(0, 0, FPicture.Width, FPicture.Height);
end;

procedure TNvImageView.Notification(AComponent: TComponent; Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FImageList) and
     (Operation = opRemove) then
     FImageList := nil;
end;

procedure TNvImageView.ImageListChange(Sender: TObject);
begin
  UpdatePicture;
end;

end.
