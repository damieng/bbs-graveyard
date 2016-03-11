unit NvFrame;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvFrame
  Type:     Component
  Contains: TNvFrame            "Windows 95/NT style frame"
  Version:  v1.0

  Changes:  10-Aug-1997   DPG   New component.

  Future:
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TNvFrameBevel = (bvNone, bvLowered, bvRaised);

  TNvFrame = class(TGraphicControl)
  private
    FBevelInner: TNvFrameBevel;
    FBevelOuter: TNvFrameBevel;
    procedure SetBevelInner(Value: TNvFrameBevel);
    procedure SetBevelOuter(Value: TNvFrameBevel);
  protected
    procedure Paint; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Align;
    property BevelInner: TNvFrameBevel read FBevelInner write SetBevelInner
             default bvLowered;
    property BevelOuter: TNvFrameBevel read FBevelOuter write SetBevelOuter
             default bvLowered;
    property ParentShowHint;
    property ShowHint;
  end;

implementation

constructor TNvFrame.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FBevelInner := bvRaised;
  FBevelOuter := bvRaised;
  Width := 145;
  Height := 145;
end;

procedure TNvFrame.SetBevelInner(Value: TNvFrameBevel);
begin
  if (Value <> FBevelInner) then
     begin
       FBevelInner := Value;
       Invalidate;
     end;
end;

procedure TNvFrame.SetBevelOuter(Value: TNvFrameBevel);
begin
  if (Value <> FBevelOuter) then
     begin
       FBevelOuter := Value;
       Invalidate;
     end;
end;

procedure TNvFrame.Paint;
var
  Area: TRect;
begin
  Area := ClientRect;
  case BevelOuter of
    bvLowered:
       DrawEdge(Canvas.Handle, Area, BDR_SUNKENOUTER, BF_RECT or BF_ADJUST);
    bvRaised:
       DrawEdge(Canvas.Handle, Area, BDR_RAISEDOUTER, BF_RECT or BF_ADJUST);
    bvNone:
       InflateRect(Area, -1, -1);
  end;
  case BevelInner of
    bvLowered:
       DrawEdge(Canvas.Handle, Area, BDR_SUNKENINNER, BF_RECT or BF_ADJUST);
    bvRaised:
       DrawEdge(Canvas.Handle, Area, BDR_RAISEDINNER, BF_RECT or BF_ADJUST);
  end;
end;

end.
