unit NvNxsRadioButton;

{ Envy Technologies

  NextStep/OpenStep Controls for Delphi 32

  TNvNxsCheckbox - Checkbox Control v0.1

  Amendment Log
  =============
  23/Jul/1998  DamienG    New control

  Notes
  =====
  1. I can not get this control to become transparent!
     Windows seems to be providing a colored canvas before I paint.
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NvNxsRoutines;

type
  TNvNxsRadioButton = class(TButtonControl)
  private
    FCanvas: TCanvas;
    FChecked: Boolean;
    FUseSystemColors: Boolean;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWindowHandle(const Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure SetChecked(Value: Boolean);
    procedure SetUseSystemColors(Value: Boolean);
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Caption;
    property Checked: Boolean read FChecked write SetChecked default False;
    property Color;
    property DragCursor;
    property DragMode;
    property Enabled;
    property Font;
    property ParentColor;
    property ParentFont;
    property ParentShowHint;
    property PopupMenu;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property UseSystemColors: Boolean read FUseSystemColors write SetUseSystemColors;
    property Visible;
    property OnClick;
    property OnDblClick;
    property OnDragDrop;
    property OnDragOver;
    property OnEndDrag;
    property OnEnter;
    property OnExit;
    property OnKeyDown;
    property OnKeyPress;
    property OnKeyUp;
    property OnMouseDown;
    property OnMouseMove;
    property OnMouseUp;
    property OnStartDrag;
  end;

implementation

constructor TNvNxsRadioButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  FUseSystemColors := False;
  Width := 140;
  Height := 16;
  TabStop := True;
  ControlStyle := [csSetCaption, csOpaque];
end;

procedure TNvNxsRadioButton.SetChecked(Value: Boolean);

  procedure TurnSiblingsOff;
  var
    I: Integer;
    Sibling: TControl;
  begin
    if (Parent <> nil) then
      with Parent do
        for I := 0 to (ControlCount - 1) do
        begin
          Sibling := Controls[I];
          if (Sibling <> Self) and (Sibling is TNvNxsRadioButton) then
             TNvNxsRadioButton(Sibling).SetChecked(False);
        end;
  end;

begin
  if (FChecked <> Value) then
     begin
       FChecked := Value;
       TabStop := Value;
       if HandleAllocated then
          SendMessage(Handle, BM_SETCHECK, Integer(Checked), 0);
       if Value then
          begin
            TurnSiblingsOff;
            inherited Changed;
            Click;
          end;
       Repaint;
     end;
end;

procedure TNvNxsRadioButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  with Params do
  begin
    Style := Style or BS_OWNERDRAW;
    WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
  end;
end;

procedure TNvNxsRadioButton.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, BM_SETCHECK, Integer(FChecked), 0);
end;

procedure TNvNxsRadioButton.CreateWindowHandle(const Params: TCreateParams);
begin
  inherited CreateWindowHandle(Params);
end;

procedure TNvNxsRadioButton.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(Message.CharCode, Caption) and CanFocus then
    begin
      SetFocus;
      Result := 1;
    end else
      inherited;
end;

procedure TNvNxsRadioButton.CNCommand(var Message: TWMCommand);
begin
  case Message.NotifyCode of
    BN_CLICKED: SetChecked(True);
    BN_DOUBLECLICKED: DblClick;
  end;
end;

procedure TNvNxsRadioButton.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TNvNxsRadioButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown, IsDefault: Boolean;
  Rec: TRect;
  High, Shad1, Shad2, Face: TColor;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  Rec := ClientRect;

  { Decode the state of the button }
  with DrawItemStruct do
    begin
      IsDown := itemState and ODS_SELECTED <> 0;
      IsDefault := itemState and ODS_FOCUS <> 0;
    end;

  FCanvas.Font := Font;
  FCanvas.Brush.Color := Color;
  FCanvas.Brush.Style := bsSolid;

  { Setup the colors }
  if FUseSystemColors then
     begin
       High := clBtnHighlight;
       Shad1 := clBtnShadow;
       Shad2 := cl3DDkShadow;
       Face := clBtnFace;
     end
   else
     begin
       High := clWhite;
       Shad1 := $00818181;
       Shad2 := clBlack;
       Face := $00C9C9C9;
     end;

  with FCanvas do
    begin
      FillRect(Rect(Rec.Left, Rec.Top, Rec.Left+18, Rec.Bottom));
      { Draw }
      Pixels[Rec.Left+13, Rec.Top+3] := Shad1;
      Pixels[Rec.Left+12, Rec.Top+2] := Shad1;
      Pixels[Rec.Left+11, Rec.Top+2] := Shad1;
      Pen.Color := Shad1;
      MoveTo(Rec.Left+10, Rec.Top+1);
      LineTo(Rec.Left+5, Rec.Top+1);
      Pixels[Rec.Left+5, Rec.Top+2] := Shad1;
      Pixels[Rec.Left+4, Rec.Top+2] := Shad1;
      Pixels[Rec.Left+3, Rec.Top+3] := Shad1;
      Pixels[Rec.Left+4, Rec.Top+4] := Shad1;
      Pixels[Rec.Left+2, Rec.Top+4] := Shad1;
      Pixels[Rec.Left+2, Rec.Top+5] := Shad1;
      MoveTo(Rec.Left+1, Rec.Top+6);
      LineTo(Rec.Left+1, Rec.Top+11);
      Pixels[Rec.Left+2, Rec.Top+11] := Shad1;
      Pixels[Rec.Left+3, Rec.Top+11] := Shad1;
      Pixels[Rec.Left+2, Rec.Top+12] := Shad1;
      Pixels[Rec.Left+3, Rec.Top+13] := Shad1;
      Pen.Color := Shad2;
      MoveTo(Rec.Left+10, Rec.Top+2);
      LineTo(Rec.Left+5, Rec.Top+2);
      Pixels[Rec.Left+5, Rec.Top+3] := Shad2;
      Pixels[Rec.Left+4, Rec.Top+3] := Shad2;
      Pixels[Rec.Left+3, Rec.Top+4] := Shad2;
      Pixels[Rec.Left+3, Rec.Top+5] := Shad2;
      MoveTo(Rec.Left+2, Rec.Top+6);
      LineTo(Rec.Left+2, Rec.Top+11);
      Pen.Color := High;
      Pixels[Rec.Left+5, Rec.Top+14] := High;
      MoveTo(Rec.Left+6, Rec.Top+15);
      LineTo(Rec.Left+11, Rec.Top+15);
      Pixels[Rec.Left+11, Rec.Top+14] := High;
      Pixels[Rec.Left+12, Rec.Top+14] := High;
      Pixels[Rec.Left+13, Rec.Top+13] := High;
      Pixels[Rec.Left+14, Rec.Top+12] := High;
      Pixels[Rec.Left+14, Rec.Top+11] := High;
      MoveTo(Rec.Left+15, Rec.Top+10);
      LineTo(Rec.Left+15, Rec.Top+5);

      If Checked then
         begin
           Brush.Color := High;
           FillRect(Rect(Rec.Left+5, Rec.Top+5,Rec.Left+13, Rec.Top+13));
           MoveTo(Rec.Left+7, Rec.Top+4);
           LineTo(Rec.Left+11, Rec.Top+4);
           MoveTo(Rec.Left+7, Rec.Top+13);
           LineTo(Rec.Left+11, Rec.Top+13);
           MoveTo(Rec.Left+4, Rec.Top+7);
           LineTo(Rec.Left+4, Rec.Top+11);
           MoveTo(Rec.Left+13, Rec.Top+7);
           LineTo(Rec.Left+13, Rec.Top+11);
           Pixels[Rec.Left+11, Rec.Top+3] := Shad1;
         end;

      { Caption }
      Font.Color := Self.Font.Color;
      Brush.Color := Self.Color;
      Brush.Style := bsSolid;
      Rec.Left := Rec.Left + 19;
      FillRect(Rec);
      DrawText(Handle, PChar(Caption), Length(Caption), Rec, DT_VCENTER or DT_SINGLELINE);
    end;
  FCanvas.Handle := 0;
end;

procedure TNvNxsRadioButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TNvNxsRadioButton.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNvNxsRadioButton.SetUseSystemColors(Value: Boolean);
begin
  if (FUseSystemColors <> Value) then
     begin
       FUseSystemColors := Value;
       Repaint;
     end;
end;

end.
