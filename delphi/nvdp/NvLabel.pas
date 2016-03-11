unit NvLabel;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvLabel
  Type:     Component
  Contains: TNvLabel            "Label with 3D/Hyperlink/Elipsis"
                                Inspired by Internet Explorer.
  Version:  v1.0

  Changes:  12-Mar-1997   DPG   New component.
            01-Apr-1997   DPG   Final code tidy.
            14-Apr-1997   DPG   Fixed execute command line (ShellExecute).
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            22-Jul-1997   DPG   Changed TEffect to TCoolEffect.
            05-Aug-1997   DPG   Renamed to TNvLabel, source tidy.
            10-Aug-1997   DPG   Definable shadow & highlight colors.

  Future:
*******************************************************************************}

interface

{$R NvLabel.res}

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, ShellApi, NvRoutines;

const
  HandCursor = 1; { Change if this conflicts with own cursors }

type
  TNvEffect = (fxNone, fxRaised, fxLowered, fxShadow, fxHyperlink);
  TNvLabel = class(TLabel)
  private
    FHighlightColor: TColor;
    FShadowColor: TColor;
    FEffect: TNvEffect;
    FEllipsis: Boolean;
    FExecuteCmd: string;
    FOldCursor: TCursor;
    procedure DoDrawText(var Rect: TRect; Flags: Word);
    procedure SetEffect(Value: TNvEffect);
    procedure SetEllipsis(Value: Boolean);
    procedure SetExecuteCmd(const Value: string);
    procedure SetHighlightColor(Value: TColor);
    procedure SetShadowColor(Value: TColor);
  protected
    procedure Paint; override;
    procedure Click; override;
  public
    constructor Create(AOwner: TComponent); override;
  published
    property Ellipsis: Boolean read FEllipsis write SetEllipsis default false;
    property ExecuteCmd: string read FExecuteCmd write SetExecuteCmd;
    property Effect: TNvEffect read FEffect write SetEffect default fxNone;
    property HighlightColor: TColor read FHighlightColor write
             SetHighlightColor default clBtnHighlight;
    property ShadowColor: TColor read FShadowColor write
             SetShadowColor default clBtnShadow;
  end;

implementation

{ Create object, assign defaults, Load 'Hand' cursor }
constructor TNvLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  Height := 18;
  FEllipsis := False;
  FExecuteCmd := '';
  Screen.Cursors[HandCursor] := LoadCursor(HInstance, 'HandPress');
  FOldCursor := Cursor;
  FHighlightColor := clBtnHighlight;
  FShadowColor := clBtnShadow;
end;

{ Highlight color property updater }
procedure TNvLabel.SetHighlightColor(Value: TColor);
begin
  if (Value <> FHighlightColor) then
     begin
       FHighlightColor := Value;
       Invalidate;
     end;
end;

{ Shadow color property updater }
procedure TNvLabel.SetShadowColor(Value: TColor);
begin
  if (Value <> FShadowColor) then
     begin
       FShadowColor := Value;
       Invalidate;
     end;
end;

{ Ellipsis property updater }
procedure TNvLabel.SetEllipsis(Value: Boolean);
begin
  if (Value <> FEllipsis) then
     begin
       FEllipsis := Value;
       Invalidate;
     end;
end;

{ Set command to execute & change cursor to a hand }
procedure TNvLabel.SetExecuteCmd(const Value: string);
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
procedure TNvLabel.SetEffect(Value: TNvEffect);
begin
  if (Value <> FEffect) then
     begin
       FEffect := Value;
       Invalidate;
     end;
end;

{ Click handler }
procedure TNvLabel.Click;
begin
  if (FExecuteCmd <> '') then
     ShellExecute(0, nil, PChar(FExecuteCmd), nil, nil, SW_SHOWNORMAL);
  inherited Click;
end;

{ Repaint controller }
procedure TNvLabel.Paint;
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
      DoDrawText(Rect, (DT_EXPANDTABS or DT_WORDBREAK) or
                 HAlignments[Alignment]);
    end;
end;

{ Routine to draw the text to the screen }
procedure TNvLabel.DoDrawText(var Rect: TRect; Flags: Word);
var
  Text: string;
  TopCol, NormCol, BotCol: TColor;
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
                    TopCol := HighlightColor;
                    BotCol := ShadowColor;
                  end;
       fxShadow : begin
                    NormOK := False;
                    BotCol := ShadowColor;
                    TopCol := NormCol;
                  end;
       fxLowered : begin
                     TopCol := ShadowColor;
                     BotCol := HighlightColor;
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
  if BotOK then
     DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  OffsetRect(Rect,-2,-2);
  Canvas.Font.Color := TopCol;
  if TopOK then
     DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
  OffsetRect(Rect,1,1);
  Canvas.Font.Color := NormCol;
  if NormOK then
     DrawText(Canvas.Handle, PChar(Text), Length(Text), Rect, Flags);
end;

end.
