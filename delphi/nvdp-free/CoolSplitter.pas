unit CoolSplitter;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolSplitter v0.1 - Splitter/Panel resizing control

  Change Log
  ----------
  10-Apr-1997   DPG   New component.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible component.
                      Use the TSplitter component in Delphi 3 instead!

  Future Ideas
  ------------
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  ExtCtrls;

type
  TCoolSplitterOrientation = (soVertical, soHorizontal);
  TCoolSplitter = class(TCustomPanel)
  private
    FMinSize: Integer;
    FOrientation: TCoolSplitterOrientation;
    FPanel1: TPanel;
    FPanel2: TPanel;
    IsMouseDown: Boolean;
    procedure SetMinSize(Value: Integer);
    procedure SetOrientation(Value: TCoolSplitterOrientation);
    procedure SplitDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
    procedure SplitMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
    procedure SplitUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
  protected
    procedure Notification(AComponent: TComponent; Operation: TOperation); override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property MinSize: Integer read FMinSize write SetMinSize;
    property Orientation: TCoolSplitterOrientation read FOrientation
             write SetOrientation default soVertical;
    property PanelTopLeft: TPanel read FPanel1 write FPanel1;
    property PanelBottomRight: TPanel read FPanel2 write FPanel2;
  end;

implementation

{ Create object, assign defaults }
constructor TCoolSplitter.Create(AOwner: TComponent);
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
procedure TCoolSplitter.SetOrientation(Value: TCoolSplitterOrientation);
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
procedure TCoolSplitter.SplitDown(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  if (not Assigned(FPanel1)) or (not Assigned(FPanel2)) then Exit;
  if (Button = mbLeft) then IsMouseDown := True;
end;

{ Mouse button moving, resize if mouse button is down }
procedure TCoolSplitter.SplitMove(Sender: TObject; Shift: TShiftState; X, Y: Integer);
var
  Original: Integer;
begin
  if IsMouseDown then
     begin
       if (Orientation = soVertical) then { Vertical resizer }
          begin
            Original := Self.Left + X - 1;
            if (Original < (FPanel1.Left + FMinSize)) then
               Original := FPanel1.Left + FMinSize
            else
              if (Original > (FPanel2.Left + FPanel2.Width - FMinSize)) then
                 Original := FPanel2.Left + FPanel2.Width - FMinSize;
            FPanel1.Width := Original
          end
       else
          begin
            Original := Self.Top + Y - 1; { Horizontal resizer }
            if (Original < (FPanel1.Top + FMinSize)) then
               Original := FPanel1.Top + FMinSize
            else
              if (Original > (FPanel2.Top + FPanel2.Height - 20)) then
                 Original := FPanel2.Top + FPanel2.Height - 20;
            FPanel1.Height := Original;
          end;
     end;
end;

{ Mouse button is up, no more resizing }
procedure TCoolSplitter.SplitUp(Sender: TObject; Button: TMouseButton; Shift: TShiftState; X, Y: Integer);
begin
  IsMouseDown := False;
end;

{ Set minimum size of resized panels }
procedure TCoolSplitter.SetMinSize(Value: Integer);
begin
  if (Value <> FMinSize) then
     begin
       FMinSize := Value;
       Update;
     end;
end;

procedure TCoolSplitter.Notification(AComponent: TComponent;
  Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (AComponent = FPanel1) and (Operation = opRemove) then FPanel1 := nil;
  if (AComponent = FPanel2) and (Operation = opRemove) then FPanel2 := nil;
end;

end.
