unit CoolLabel;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolLabel - Label with Ellipses, 3D effects, proper disabling + execute.

  Change Log
  ----------
  12-Mar-1997   DPG   New component.
  01-Apr-1997   DPG   Final code tidy.
  14-Apr-1997   DPG   Fixed execute command line (ShellExecute).
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
  Automatic underline & correct coloring of hyperlink from MSIE?
*******************************************************************************}

interface

{$R CoolLabel.res}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellApi;

const
  HandCursor = 1; { Change if this conflicts with own cursors }

type
  TEffect = (fxNone, fxRaised, fxLowered, fxShadow, fxHyperlink);
  TCoolLabel = class(TLabel)
  private
    FOldCursor: TCursor;
    FEllipsis: Boolean;
    FExecuteCmd: string;
    FEffect: TEffect;
    procedure SetEllipsis(Value: Boolean);
    procedure SetExecuteCmd(Value: string);
    procedure SetEffect(Value: TEffect);
    procedure DoDrawText(var Rect: TRect; Flags: Word);
  protected
    procedure Paint; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Ellipsis: Boolean read FEllipsis write SetEllipsis default false;
    property ExecuteCmd: string read FExecuteCmd write SetExecuteCmd;
    property Effect: TEffect read FEffect write SetEffect default fxNone;
  end;

function RGBToColor(Red, Green, Blue: Integer): TColor;

implementation

{ Create the component }
constructor TCoolLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 18;
  FEllipsis := False;
  FExecuteCmd := '';
  Screen.Cursors[HandCursor] := LoadCursor(HInstance, 'HandPress');
  FOldCursor := Cursor;
end;

{ Ellipsis property updater }
procedure TCoolLabel.SetEllipsis(Value: Boolean);
begin
  if (Value <> FEllipsis) then
     begin
       FEllipsis := Value;
       Invalidate;
     end;
end;

{ Set command to execute & change cursor to a hand }
procedure TCoolLabel.SetExecuteCmd(Value: string);
begin
  if (Value <> FExecuteCmd) then
     begin
       FExecuteCmd := Value;
       if (FExecuteCmd <> '') then
          Cursor := HandCursor
        else
          Cursor := FOldCursor;
     end;
end;

{ Special effect property updater }
procedure TCoolLabel.SetEffect(Value: TEffect);
begin
  if (Value <> FEffect) then
     begin
       FEffect := Value;
       Invalidate;
     end;
end;

{ Click handler }
procedure TCoolLabel.Click;
begin
  if (FExecuteCmd <> '') then ShellExecute(0, nil, PChar(FExecuteCmd), nil, nil, SW_SHOWNORMAL);
  inherited Click;
end;

{ Repaint controller }
procedure TCoolLabel.Paint;
const
  HAlignments: array[TAlignment] of Word = (DT_LEFT, DT_RIGHT, DT_CENTER);
var
  Rect: TRect;
begin
  with Canvas do
  begin
    if not Transparent then
       begin
         Brush.Color := Self.Color;
         Brush.Style := bsSolid;
         FillRect(ClientRect);
       end;
    Brush.Style := bsClear;
    Rect := ClientRect;
    DoDrawText(Rect, (DT_EXPANDTABS or DT_WORDBREAK) or HAlignments[Alignment]);
  end;
end;

{ Routine to draw the text to the screen }
procedure TCoolLabel.DoDrawText(var Rect: TRect; Flags: Word);
var
  Text: string;
  TopCol, NormCol, BotCol : TColor;
  TopOK, BotOK, NormOK: Boolean;
begin
  Text := GetLabelText;
  if (Flags and DT_CALCRECT <> 0) and ((Text = '') or ShowAccelChar and
     (Text[1] = '&') and (Text[2] = #0)) then Text := Text + ' ';
  if not ShowAccelChar then Flags := Flags or DT_NOPREFIX;
  if FEllipsis then Flags := Flags or DT_PATH_ELLIPSIS;
  Canvas.Font := Font;
  TopOK := True;
  BotOK := True;
  NormOK := True;
  NormCol := Font.Color;
  if not Enabled then
     begin
       TopOK := False;
       NormCol := clBtnShadow;
       BotCol := clBtnHighlight;
     end
   else
     case Effect of
       fxNone : begin
                  TopOK := False;
                  BotOK := False;
                end;
       fxRaised : begin
                    TopCol := clBtnHighlight;
                    BotCol := clBtnShadow;
                  end;
       fxShadow : begin
                    NormOK := False;
                    BotCol := clBtnShadow;
                    TopCol := NormCol;
                  end;
       fxLowered : begin
                     TopCol := clBtnShadow;
                     BotCol := clBtnHighlight;
                   end;
       fxHyperLink : begin
                       TopOK := False;
                       BotOK := False;
                       NormCol := RGBToColor(0,0,255);
                       Canvas.Font.Style := Canvas.Font.Style + [fsUnderline];
                     end;
      end;
  OffsetRect(Rect,1,1);
  Canvas.Font.Color := BotCol;
  if BotOK then DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  OffsetRect(Rect,-2,-2);
  Canvas.Font.Color := TopCol;
  if TopOK then DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  OffsetRect(Rect,1,1);
  Canvas.Font.Color := NormCol;
  if NormOK then DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

{ Function to convert RGB values to a TColor }
function RGBToColor(Red, Green, Blue: Integer): TColor;
begin
  Result := Red + (Green * 256) + (Blue * 65536);
end;

end.
