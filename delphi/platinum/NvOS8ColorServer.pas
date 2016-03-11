unit NvOS8ColorServer;

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls;

type
   TShade = record
     C: Array[0..15] of TColor;
   end;

type
  TNvOS8ColorServer = class(TComponent)
  private
    FAccentStartColor: TColor;
    FAccentMidColor: TColor;
    FAccentEndColor: TColor;
    FBaseStartColor: TColor;
    FBaseEndColor: TColor;
    FNotifyChildren: Boolean;
    procedure RecalculateAccent;
    procedure RecalculateBase;
    procedure SetAccentStartColor(Value: TColor);
    procedure SetAccentMidColor(Value: TColor);
    procedure SetAccentEndColor(Value: TColor);
    procedure SetBaseStartColor(Value: TColor);
    procedure SetBaseEndColor(Value: TColor);
  protected
  public
    AccentShade: TShade;
    BaseShade: TShade;
    constructor Create(AOwner: TComponent); override;
  published
    property AccentStartColor: TColor read FAccentStartColor write SetAccentStartColor;
    property AccentMidColor: TColor read FAccentMidColor write SetAccentMidColor;
    property AccentEndColor: TColor read FAccentEndColor write SetAccentEndColor;
    property BaseStartColor: TColor read FBaseStartColor write SetBaseStartColor;
    property BaseEndColor: TColor read FBaseEndColor write SetBaseEndColor;
    property NotifyChildren: Boolean read FNotifyChildren write FNotifyChildren default True;
  end;

implementation

constructor TNvOS8ColorServer.Create(AOwner: TComponent);
begin
  inherited;
  FNotifyChildren := True;
  FBaseStartColor := clBlack;
  FBaseEndColor := clWhite;
end;

procedure TNvOS8ColorServer.SetAccentStartColor(Value: TColor);
begin
     if (Value <> FAccentStartColor) then
        begin
           FAccentStartColor := Value;
           RecalculateAccent;
        end;
end;

procedure TNvOS8ColorServer.SetAccentMidColor(Value: TColor);
begin
     if (Value <> FAccentMidColor) then
        begin
           FAccentMidColor := Value;
           RecalculateAccent;
        end;
end;

procedure TNvOS8ColorServer.SetAccentEndColor(Value: TColor);
begin
     if (Value <> FAccentEndColor) then
        begin
           FAccentEndColor := Value;
           RecalculateAccent;
        end;
end;
procedure TNvOS8ColorServer.SetBaseStartColor(Value: TColor);
begin
     if (Value <> FBaseStartColor) then
        begin
           FBaseStartColor := Value;
           RecalculateBase;
        end;
end;

procedure TNvOS8ColorServer.SetBaseEndColor(Value: TColor);
begin
     if (Value <> FBaseEndColor) then
        begin
           FBaseEndColor := Value;
           RecalculateBase;
        end;
end;

procedure TNvOS8ColorServer.RecalculateAccent;
begin
     AccentShade.c[5] := $0057060A;
     AccentShade.c[6] := $009B3537;
     AccentShade.c[7] := $00CF6769;
     AccentShade.c[8] := $00FF9A9A;
     AccentShade.c[9] := $00FFCDCD;
     AccentShade.c[10] := $00EEEEEE;
end;

procedure TNvOS8ColorServer.RecalculateBase;
var
   Idx: Integer;
   RedStart, RedEnd, GreenStart, GreenEnd, BlueStart, BlueEnd: Integer;
   RedDiff, GreenDiff, BlueDiff: Real;
   RedNew, GreenNew, BlueNew: Integer;
begin
   RedStart := (FBaseStartColor and $FF);
   RedEnd := (FBaseEndColor and $FF);
   RedDiff := (RedEnd-RedStart) / 16;

   GreenStart := ((FBaseStartColor and $FF00) div 256);
   GreenEnd := ((FBaseEndColor and $FF00) div 256);
   GreenDiff := (GreenEnd-GreenStart) / 16;

   BlueStart := ((FBaseStartColor and $FF0000) div 65536);
   BlueEnd := ((FBaseEndColor and $FF0000) div 65536);
   BlueDiff := (BlueEnd-BlueStart) / 16;

  for Idx := 0 to 15 do
    begin
     RedNew := RedStart+Round(RedDiff*Idx);
     If RedNew > 255 Then RedNew := 255;
     If RedNew < 0 Then RedNew := 0;

     GreenNew := GreenStart+Round(GreenDiff*Idx);
     If GreenNew > 255 Then GreenNew := 255;
     If GreenNew < 0 Then GreenNew := 0;

     BlueNew := BlueStart+Round(BlueDiff*Idx);
     If BlueNew > 255 Then BlueNew := 255;
     If BlueNew < 0 Then BlueNew := 0;

     BaseShade.C[Idx] := (BlueNew*65536) + (GreenNew*256) + RedNew;
    end;
end;

end.
