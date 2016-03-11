unit NvOS8PushButton;

{ Envy Technologies

  Apple Macintosh OS 8 Platium Controls for Delphi 32

  TNvOS8PushButton - Push Button control v0.3

  Amendment Log
  =============
  18/Feb/1998  DamienG    Fix: Double-clicks treated as two clicks
                          Opt: Optimized code
  10/Feb/1998  DamienG    New: Colors shade-offsets from base of $00777777
                          New: Property base-color to allow colored buttons
                          New: Sits better on different colored backgrounds
                          Fix: Memory leak in destructor
                          Fix: Cosmetic changes to avoid warning messages
  09/Feb/1998  DamienG    New: Changed pixels to be rect-offsetable for default rect
                          New: Added 'Default' property rectangle ala MacOS8
  20/Jul/1998  DamienG    Fix: Removed unused State variables and redundant create
                          Fix: Use parent's brush to draw non-default-empty rectangle
                               Now means 'Default' property clears/sets okay
  20/May/1999  DamienG    New: Changes to run off a color server

  Notes
  =====
  }

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, Buttons, NvOS8Routines, NvOs8ColorServer;

type
  TNvOS8PushButton = class(TButton)
  private
    FColorServer: TNvOS8ColorServer;
    FCanvas: TCanvas;
    IsFocused: Boolean;
    Shade: TShade;
    procedure CMEnabledChanged(var Message: TMessage); message CM_ENABLEDCHANGED;
    procedure CMFontChanged(var Message: TMessage); message CM_FONTCHANGED;
    procedure CNDrawItem(var Message: TWMDrawItem); message CN_DRAWITEM;
    procedure DrawItem(const DrawItemStruct: TDrawItemStruct);
    procedure SetColorServer(Value: TNvOS8ColorServer);
  protected
    procedure CreateParams(var Params: TCreateParams); override;
    procedure SetButtonStyle(ADefault: Boolean); override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
  published
    property Cancel;
    property Caption;
    property ColorServer: TNvOS8ColorServer read FColorServer write SetColorServer;
    property Enabled;
    property Font;
    property ParentShowHint;
    property ShowHint;
    property TabOrder;
    property TabStop;
    property Visible;
    property OnEnter;
    property OnExit;
  end;

implementation

{ Create an instance of this control }
constructor TNvOS8PushButton.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FCanvas := TCanvas.Create;
  ControlStyle := ControlStyle - [csDoubleClicks];
  Font.Style := Font.Style + [fsBold];
  Width := 64;
  Height := 26;
end;

{ Clear up our mess }
destructor TNvOS8PushButton.Destroy;
begin
  inherited Destroy;
  FCanvas.Free;
end;

{ Override for owner-draw }
procedure TNvOS8PushButton.CreateParams(var Params: TCreateParams);
begin
  inherited CreateParams(Params);
  with Params do Style := Style or BS_OWNERDRAW;
end;

{ Component message to redraw }
procedure TNvOS8PushButton.CNDrawItem(var Message: TWMDrawItem);
begin
  DrawItem(Message.DrawItemStruct^);
end;

{ Font change - must redraw - used when ParentFont true }
procedure TNvOS8PushButton.CMFontChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{ Enable change - must redraw }
procedure TNvOS8PushButton.CMEnabledChanged(var Message: TMessage);
begin
  inherited;
  Invalidate;
end;

{ Actual drawing routine }
procedure TNvOS8PushButton.DrawItem(const DrawItemStruct: TDrawItemStruct);
var
  IsDown: Boolean;
  Rec: TRect;
  FilCol, BorCol, CapCol, T1, T2, B1, B2: TColor;
begin
  FCanvas.Handle := DrawItemStruct.hDC;
  Rec := ClientRect;

  { Decode the state of the button }
  with DrawItemStruct do
      IsDown := itemState and ODS_SELECTED <> 0;

  FCanvas.Font := Font;

  { Setup the colors }
  if Enabled then
     begin
       BorCol := Shade.C[0];
       if IsDown then
          begin
            T1 := Shade.C[4];
            T2 := Shade.C[5];
            B1 := Shade.C[7];
            B2 := Shade.C[8];
            FilCol := Shade.C[6];
            CapCol := Shade.C[15];
          end
        else
          begin
            T1 := Shade.C[13];
            T2 := Shade.C[15];
            B1 := Shade.C[10];
            B2 := Shade.C[7];
            FilCol := Shade.C[13];
            CapCol := Font.Color;
          end
     end
   else
     begin
       BorCol := Shade.C[8];
       CapCol := Shade.C[8];
       FilCol := Shade.C[13];
     end;

  { Get painting }
  with FCanvas do
    begin
      Pen.Style := psSolid;
      Brush := Parent.Brush;
      FillRect(ClientRect);
      if Default then
         begin
           Pen.Color := BorCol;
           MoveTo(Rec.Left+3, Rec.Top);
           LineTo(Rec.Right-4, Rec.Top);
           LineTo(Rec.Right-1, Rec.Top+3);
           LineTo(Rec.Right-1, Rec.Bottom-4);
           LineTo(Rec.Right-4, Rec.Bottom-1);
           LineTo(Rec.Left+3, Rec.Bottom-1);
           LineTo(Rec.Left, Rec.Bottom-4);
           LineTo(Rec.Left, Rec.Top+3);
           LineTo(Rec.Left+3, Rec.Top);
           if Enabled then
              begin
                Pen.Color := Shade.C[13];
                MoveTo(Rec.Left+1, Rec.Bottom-5);
                LineTo(Rec.Left+1, Rec.Top+3);
                LineTo(Rec.Left+3, Rec.Top+1);
                LineTo(Rec.Right-4, Rec.Top+1);
                MoveTo(Rec.Left+2, Rec.Top+3);
                LineTo(Rec.Left+4, Rec.Top+2);
                Pen.Color := Shade.C[10];
                MoveTo(Rec.Left+4, Rec.Top+2);
                LineTo(Rec.Right-4, Rec.Top+2);
                LineTo(Rec.Right-4, Rec.Top+3);
                LineTo(Rec.Right-3, Rec.Top+3);
                LineTo(Rec.Right-3, Rec.Bottom-5);
                LineTo(Rec.Right-5, Rec.Bottom-3);
                LineTo(Rec.Left+3, Rec.Bottom-3);
                LineTo(Rec.Left+3, Rec.Bottom-4);
                LineTo(Rec.Left+2, Rec.Bottom-4);
                LineTo(Rec.Left+2, Rec.Top+4);
                LineTo(Rec.Left+4, Rec.Top+2);
                Pen.Color := Shade.C[7];
                MoveTo(Rec.Left+4, Rec.Bottom-2);
                LineTo(Rec.Right-4, Rec.Bottom-2);
                LineTo(Rec.Right-2, Rec.Bottom-4);
                LineTo(Rec.Right-2, Rec.Top+3);
                Pixels[Rec.Left+4, Rec.Top+3] := Shade.C[7];
                Pixels[Rec.Left+3, Rec.Top+4] := Shade.C[7];
                Pixels[Rec.Right-5, Rec.Top+3] := Shade.C[7];
                Pixels[Rec.Right-4, Rec.Top+4] := Shade.C[7];
                Pixels[Rec.Right-5, Rec.Bottom-4] := Shade.C[7];
                Pixels[Rec.Right-4, Rec.Bottom-5] := Shade.C[7];
                Pixels[Rec.Left+4, Rec.Bottom-4] := Shade.C[7];
                Pixels[Rec.Left+3, Rec.Bottom-5] := Shade.C[7];
                Pixels[Rec.Left+1, Rec.Bottom-4] := Shade.C[12];
                Pixels[Rec.Right-4, Rec.Top+1] := Shade.C[12];
                Pixels[Rec.Left+2, Rec.Bottom-3] := Shade.C[11];
                Pixels[Rec.Right-3, Rec.Top+2] := Shade.C[11];
                Pixels[Rec.Left+3, Rec.Bottom-2] := Shade.C[8];
                Pixels[Rec.Right-2, Rec.Top+3] := Shade.C[8];
                Pixels[Rec.Right-3, Rec.Bottom-4] := Shade.C[8];
                Pixels[Rec.Right-4, Rec.Bottom-3] := Shade.C[8];
              end
         end;
      Brush.Color := FilCol;
      Pen.Color := BorCol;
      InflateRect(Rec,-3,-3);
      RoundRect(Rec.Left, Rec.Top, Rec.Right, Rec.Bottom, 5, 5);
      if Enabled then
         begin
           Pen.Color := T1;
           MoveTo(Rec.Left+1, Rec.Bottom-3);
           LineTo(Rec.Left+1, Rec.Top+1);
           MoveTo(Rec.Left+2, Rec.Top+1);
           LineTo(Rec.Right-2, Rec.Top+1);
           Pen.Color := T2;
           MoveTo(Rec.Left+2, Rec.Bottom-4);
           LineTo(Rec.Left+2, Rec.Top+2);
           LineTo(Rec.Right-3, Rec.Top+2);
           Pen.Color := B1;
           MoveTo(Rec.Left+3, Rec.Bottom-3);
           LineTo(Rec.Right-3, Rec.Bottom-3);
           LineTo(Rec.Right-3, Rec.Top+2);
           Pen.Color := B2;
           MoveTo(Rec.Left+3, Rec.Bottom-2);
           LineTo(Rec.Right-2, Rec.Bottom-2);
           MoveTo(Rec.Right-2, Rec.Bottom-3);
           LineTo(Rec.Right-2, Rec.Top+2);

           { Make pixel-perfect modifications }
           if IsDown then
              begin
                Pixels[Rec.Left+2, Rec.Top+2] := T1;
                Pixels[Rec.Left+3, Rec.Top+3] := T2;
                Pixels[Rec.Left+2, Rec.Bottom-2] := B1;
                Pixels[Rec.Right-2, Rec.Top+2] := B1;
                Pixels[Rec.Right-3, Rec.Bottom-3] := B2;
                Pixels[Rec.Right-4, Rec.Bottom-4] := B1;
              end
            else
              begin
                Pixels[Rec.Left+1, Rec.Top+2] := Shade.C[11];
                Pixels[Rec.Left+2, Rec.Top+1] := Shade.C[11];
                Pixels[Rec.Left+3, Rec.Top+3] := T2;
                Pixels[Rec.Left+1, Rec.Bottom-3] := Shade.C[11];
                Pixels[Rec.Left+2, Rec.Bottom-2] := Shade.C[11];
                Pixels[Rec.Right-3, Rec.Top+1] := Shade.C[11];
                Pixels[Rec.Right-2, Rec.Top+2] := Shade.C[11];
                Pixels[Rec.Right-4, Rec.Bottom-4] := B1;
                Pixels[Rec.Right-3, Rec.Bottom-3] := B2;
              end;

         end;
    InflateRect(Rec, -8, -4);
    Font.Color := CapCol;
    Rec.Top := Rec.Top-1;
    DrawText(Handle, PChar(Caption), Length(Caption), Rec,
                    DT_CENTER or DT_VCENTER or DT_SINGLELINE);
  end;

  FCanvas.Handle := 0;
end;

{ Essential routine to allow ownerdraw TButton }
procedure TNvOS8PushButton.SetButtonStyle(ADefault: Boolean);
begin
  if (ADefault <> IsFocused) then
     begin
       IsFocused := ADefault;
       Invalidate;
     end;
end;

procedure TNvOS8PushButton.SetColorServer(Value: TNvOS8ColorServer);
begin
  if (Value <> FColorServer) then
     begin
       FColorServer := Value;
       Shade := FColorServer.BaseShade;
       Repaint;
     end;
end;

end.
