unit NvSplitter;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvSplitter
  Type:     Component
  Contains: TNvSplitter         "Splitter/panel resizing control"
  Version:  v1.0

  Changes:  10-Apr-1997   DPG   New component.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible component.
            05-Aug-1997   DPG   Renamed to TNvSplitter, source tidy.

  Future:
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TNvSplitterOrientation = (soVertical, soHorizontal);

  TNvSplitter = class(TCustomPanel)
  private
    FMinSize: Integer;
    FOrientation: TNvSplitterOrientation;
    FPanelTL: TPanel;
    FPanelBR: TPanel;
    IsMouseDown: Boolean;
    procedure SetMinSize(Value: Integer);
    procedure SetOrientation(Value: TNvSplitterOrientation);
    procedure SplitDown(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
    procedure SplitMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SplitUp(Sender: TObject; Button: TMouseButton;
              Shift: TShiftState; X, Y: Integer);
  protected
    procedure Notification(AComponent: TComponent;
              Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property MinSize: Integer read FMinSize write SetMinSize;
    property Orientation: TNvSplitterOrientation read FOrientation
             write SetOrientation default soVertical;
    property PanelTopLeft: TPanel read FPanelTL write FPanelTL;
    property PanelBottomRight: TPanel read FPanelBR write FPanelBR;
  end;

implementation

{ Create object, assign defaults }
constructor TNvSplitter.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  ControlStyle := [csAcceptsControls, csCaptureMouse, csClickEvents,
     csOpaque, csDoubleClicks, csReplicatable]; { Remove caption }
  SetOrientation(soVertical);
  if (csDesigning in ComponentState) then {Design-time visibility }
     BevelOuter := bvRaised
   else
     BevelOuter := bvNone;
  IsMouseDown := False;
  OnMouseDown := SplitDown;
  OnMouseMove := SplitMove;
  OnMouseUp := SplitUp;
end;

{ Set either vertical or horizontal splitter }
procedure TNvSplitter.SetOrientation(Value: TNvSplitterOrientation);
begin
  FOrientation := Value;
  if (Orientation = soVertical) then
     begin
       Cursor := crHSplit;
       Align := alLeft;
       Width := 3;
     end
   else
     begin
       Cursor := crVSplit;
       Align := alTop;
       Height := 3;
     end;
end;

{ Mouse button is down, ready for resizing }
procedure TNvSplitter.SplitDown(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
begin
  if (not Assigned(FPanelTL)) or (not Assigned(FPanelTL)) then Exit;
  if (Button = mbLeft) then IsMouseDown := True;
end;

{ Mouse button moving, resize if mouse button is down }
procedure TNvSplitter.SplitMove(Sender: TObject; Shift: TShiftState;
          X, Y: Integer);
var
  Original: Integer;
begin
  if IsMouseDown then
     begin
       if (Orientation = soVertical) then { Vertical resizer }
          begin
            Original := Self.Left + X - 1;
            if (Original < (FPanelTL.Left + FMinSize)) then
               Original := FPanelTL.Left + FMinSize
            else
              if (Original > (FPanelBR.Left + FPanelBR.Width - FMinSize)) then
                 Original := FPanelBR.Left + FPanelBR.Width - FMinSize;
            FPanelTL.Width := Original
          end
       else
          begin
            Original := Self.Top + Y - 1; { Horizontal resizer }
            if (Original < (FPanelTL.Top + FMinSize)) then
               Original := FPanelTL.Top + FMinSize
            else
              if (Original > (FPanelBR.Top + FPanelBR.Height - 20)) then
                 Original := FPanelBR.Top + FPanelBR.Height - 20;
            FPanelTL.Height := Original;
          end;
     end;
end;

{ Mouse button is up, no more resizing }
procedure TNvSplitter.SplitUp(Sender: TObject; Button: TMouseButton;
          Shift: TShiftState; X, Y: Integer);
begin
  IsMouseDown := False;
end;

{ Set minimum size of resized panels }
procedure TNvSplitter.SetMinSize(Value: Integer);
begin
  if (Value <> FMinSize) then
     begin
       FMinSize := Value;
       Update;
     end;
end;

{ Detect design-time panel deletes }
procedure TNvSplitter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FPanelTL) and (Operation = opRemove) then FPanelTL := nil;
  if (AComponent = FPanelBR) and (Operation = opRemove) then FPanelBR := nil;
end;

end.
