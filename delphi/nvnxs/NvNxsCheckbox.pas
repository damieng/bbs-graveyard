unit NvNxsCheckbox;

{ Envy Technologies

  NextStep/OpenStep Controls for Delphi 32

  TNvNxsCheckbox - Checkbox Control v0.1

  Amendment Log
  =============
  23/Jul/1998  DamienG    New NextStep style checkbox control

  Notes
  =====
  1. I can not get this control to become transparent!
     Windows seems to be providing a colored canvas before I paint.
  2. Reduce flicker
  3. Check the down/pushed drawing with NextStep
}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, NvNxsRoutines;

type
  TNvNxsCheckbox = class(TButtonControl)
  private
    FAllowGrayed: Boolean;
    FCanvas: TCanvas;
    FState: TCheckBoxState;
    FUseSystemColors: Boolean;
    procedure CMDialogChar(var Message: TCMDialogChar); message CM_DIALOGCHAR;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CNCommand(var Message: TWMCommand); message CN_COMMAND;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    function GetChecked: Boolean;
    procedure SetChecked(Value: Boolean);
    procedure SetState(Value: TCheckBoxState);
    procedure SetUseSystemColors(Value: Boolean);
    procedure WMSize(var Message: TMessage); message WM_SIZE;
  protected
    procedure Click; override;
    procedure CreateParams(var Params: TCreateParams); override;
    procedure CreateWnd; override;
    procedure Toggle; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property AllowGrayed: Boolean read FAllowGrayed write FAllowGrayed default False;
    property Caption;
    property Checked: Boolean read GetChecked write SetChecked stored False;
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
    property State: TCheckBoxState read FState write SetState default cbUnchecked;
    property TabOrder;
    property TabStop default True;
    property UseSystemColors: Boolean read FUseSystemColors write SetUseSystemColors;
    property Visible;
    property OnClick;
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

constructor TNvNxsCheckbox.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  Width := 140;
  Height := 16;
  TabStop := True;
  ControlStyle := [csSetCaption, csOpaque];
  FState := cbUnchecked;
  FUseSystemColors := False;
end;

destructor TNvNxsCheckbox.Destroy;
begin
  FCanvas.Free;
  inherited Destroy;
end;

procedure TNvNxsCheckbox.Toggle;
begin
  case State of
    cbUnchecked:
      if AllowGrayed then State := cbGrayed else State := cbChecked;
    cbChecked: State := cbUnchecked;
    cbGrayed: State := cbChecked;
  end;
  Repaint;
end;

procedure TNvNxsCheckbox.Click;
begin
  inherited Changed;
  inherited Click;
end;

function TNvNxsCheckbox.GetChecked: Boolean;
begin
  Result := State = cbChecked;
end;

procedure TNvNxsCheckbox.SetChecked(Value: Boolean);
begin
  if Value then State := cbChecked else State := cbUnchecked;
  Repaint;
end;

procedure TNvNxsCheckbox.SetState(Value: TCheckBoxState);
begin
  if (FState <> Value) then
     begin
       FState := Value;
       Repaint;
       if HandleAllocated then
          SendMessage(Handle, BM_SETCHECK, Integer(FState), 0);
       Click;
     end;
end;

procedure TNvNxsCheckbox.SetUseSystemColors(Value: Boolean);
begin
  if (FUseSystemColors <> Value) then
     begin
       FUseSystemColors := Value;
       Repaint;
     end;
end;

procedure TNvNxsCheckbox.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  CreateSubClass(Params, 'BUTTON');
  with Params do
    begin
      Style := Style or BS_OWNERDRAW;
      WindowClass.style := WindowClass.style and not (CS_HREDRAW or CS_VREDRAW);
    end;
end;

procedure TNvNxsCheckbox.CreateWnd;
begin
  inherited CreateWnd;
  SendMessage(Handle, BM_SETCHECK, Integer(FState), 0);
end;

procedure TNvNxsCheckbox.WMSize(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

procedure TNvNxsCheckbox.CMDialogChar(var Message: TCMDialogChar);
begin
  with Message do
    if IsAccel(CharCode, Caption) and CanFocus then
       begin
         SetFocus;
         if Focused then Toggle;
         Result := 1;
       end
    else
      inherited;
end;

procedure TNvNxsCheckbox.CNCommand(var Message: TWMCommand);
begin
  if (Message.NotifyCode = BN_CLICKED) then Toggle;
end;

procedure TNvNxsCheckbox.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

procedure TNvNxsCheckbox.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Repaint;
end;

procedure TNvNxsCheckbox.DrawItem(const DrawItemStruct: TDrawItemStruct);
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
  { Attempted to reduce flicker by blanking the parts seperately, closer to the
    drawing }
  FCanvas.FillRect(Rect(Rec.Left+4, Rec.Top, Rec.Left+19, Rec.Bottom));

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

  DrawNextFrame(FCanvas, Rect(Rec.Left+2, Rec.Top+1, Rec.Left+16, Rec.Top+15), not IsDown, High, Shad1, Shad2, Face);

  { Actual draw of status }
  with FCanvas do
  begin
    Pen.Color := clBlack;
    case Self.State of
      cbChecked:   begin
                     Pen.Color := High;
                     MoveTo(Rec.Left+5, Rec.Top+6);
                     LineTo(Rec.Left+5, Rec.Top+11);
                     LineTo(Rec.Left+14, Rec.Top+2);
                     Pen.Color := Shad2;
                     MoveTo(Rec.Left+5, Rec.Top+12);
                     LineTo(Rec.Left+14, Rec.Top+3);
                     Pen.Color := Shad1;
                     MoveTo(Rec.Left+6, Rec.Top+12);
                     LineTo(Rec.Left+14, Rec.Top+4);
                     Pixels[Rec.Left+6, Rec.Top+6] := Shad2;
                     Pixels[Rec.Left+6, Rec.Top+7] := Shad2;
                     Pixels[Rec.Left+6, Rec.Top+8] := Shad2;
                     Pixels[Rec.Left+6, Rec.Top+9] := Shad1;
                     Pixels[Rec.Left+7, Rec.Top+8] := Shad1;
                   end;
      cbGrayed:    begin
                   end;
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

end.
