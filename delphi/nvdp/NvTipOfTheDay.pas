unit NvTipOfTheDay;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvTipOfTheDay
  Type:     Component
  Contains: TNvTipOfTheDay      "TNvTipOfTheDay component"
                                Inspired by Microsoft Developer Studio.
  Version:  v1.0

  Changes:  03-Mar-1997   DPG   Created from existing EnvyDCP.
            17-Mar-1997   DPG   New 'AutoShow' property to show automatically on
                                startup, CheckboxChecked now defaults to true
                                and not published.
            01-Apr-1997   DPG   Final code tidy.
            15-Apr-1997   DPG   Correctly added back the registry code.
            11-May-1997   DPG   Reset the tip number when looped.
            18-May-1997   DPG   Enable the Next Tip button when redisplayed.
            21-May-1997   DPG   Prevent tip from displaying in design mode.
                                New Delphi 2/Delphi 3 compatible version.
            25-May-1997   DPG   New property to change 'Did you know?...'.
            05-Aug-1997   DPG   Renamed to TNvTipOfTheDay, source tidy.
                                NextBtnEnabled moved to public property.
                                Changed strings in procedures to const.

  Future:
*******************************************************************************}

interface

uses Classes, NvTipOfDayForm, SysUtils, Registry, Forms;

type
  TNvTipOfTheDay = class(TComponent)
  private
    FActive: Boolean;
    FAutoShow: Boolean;
    FTip: string;
    FTipFile: TFileName;
    FNextBtnVisible: Boolean;
    FNextBtnEnabled: Boolean;
    FRegistryKey: string;
    FStartupCheckboxVisible: Boolean;
    FStartupCheckboxChecked: Boolean;
    FTipForm: TNvTipOfTheDayForm;
    FTitle: string;
    TipNumber: Integer;
    procedure chkTipHandler(Sender: TObject);
    procedure SetNextBtnVisible(Value: Boolean);
    procedure SetNextBtnEnabled(Value: Boolean);
    procedure SetStartupCheckboxVisible(Value: Boolean);
    procedure SetStartupCheckboxChecked(Value: Boolean);
    procedure GetTipHandler(Sender: TObject);
    procedure SetTip(const Value: string);
    procedure SetTitle(const Value: string);
    procedure Hide;
    procedure Loaded; override;
    property Active: Boolean read FActive;
    property Tip: string read FTip write SetTip;
  published
    property AutoShow: Boolean read FAutoShow write FAutoShow default True;
    property NextBtnVisible: Boolean read FNextBtnVisible
             write SetNextBtnVisible default True;
    property RegistryKey: string read FRegistryKey write FRegistryKey;
    property StartupCheckboxVisible: Boolean read FStartupCheckboxVisible
             write SetStartupCheckboxVisible default True;
    property TipFile: TFileName read FTipFile write FTipFile;
    property Title: string read FTitle write SetTitle;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property NextBtnEnabled: Boolean read FNextBtnEnabled
             write SetNextBtnEnabled default True;
    procedure Show;
    property StartupCheckboxChecked: Boolean read FStartupCheckboxChecked
             write SetStartupCheckboxChecked default True;
  end;

implementation

{ Create object, assign defaults }
constructor TNvTipOfTheDay.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FActive := False;
  FAutoShow := True;
  FRegistryKey := '\Company\Product';
  FNextBtnEnabled := True;
  FNextBtnVisible := True;
  FStartupCheckboxChecked := True;
  FStartupCheckboxVisible := True;
  FTipForm := nil;
  FTipFile := '';
  FTitle := 'Did you know...';
end;

{ Display the tip of the day if needed }
procedure TNvTipOfTheDay.Loaded;
var
  Reg: TRegIniFile;
begin
  inherited Loaded;
  if (FRegistryKey <> '') and (not (csDesigning in ComponentState)) then
     begin
       Reg := TRegIniFile.Create(FRegistryKey);
       TipNumber := Reg.ReadInteger('TipOfTheDay', 'TipNumber', 1);
       FStartupCheckboxChecked := Reg.ReadBool('TipOfTheDay',
                               'ShowAtStart', True);
       Reg.Free;
     end;
  if (FStartupCheckboxChecked) and (not (csDesigning in ComponentState)) then
     Show;
end;

{ Change the visibility of the Next Button on the form }
procedure TNvTipOfTheDay.SetNextBtnVisible(Value: Boolean);
begin
  if (Value <> FNextBtnVisible) then
     begin
       FNextBtnVisible := Value;
       if Active then FTipForm.NextTipBtn.Visible := FNextBtnVisible;
     end;
end;

{ Change the enabled status of the Next Button on the form }
procedure TNvTipOfTheDay.SetNextBtnEnabled(Value: Boolean);
begin
  if (Value <> FNextBtnEnabled) then
     begin
       FNextBtnEnabled := Value;
       if Active then FTipForm.NextTipBtn.Enabled := FNextBtnEnabled;
     end;
end;

{ Change the visibility of the 'Show Tips at Startup' checkbox on the form }
procedure TNvTipOfTheDay.SetStartupCheckboxVisible(Value: Boolean);
begin
  if (Value <> FStartupCheckboxVisible) then
     begin
       FStartupCheckboxVisible := Value;
       if Active then FTipForm.chkShowTips.Visible := FStartupCheckboxVisible;
     end;
end;

{ Change the status of the 'Show Tips at Startup' checkbox on the form }
procedure TNvTipOfTheDay.SetStartupCheckboxChecked(Value: Boolean);
begin
  if (Value <> FStartupCheckboxChecked) then
     begin
       FStartupCheckboxChecked := Value;
       if Active then FTipForm.chkShowTips.Checked := FStartupCheckboxChecked;
     end;
end;

{ Change the title on the form }
procedure TNvTipOfTheDay.SetTitle(const Value: string);
begin
  if (Value <> FTitle) then
     begin
       FTitle := Value;
       if Active then FTipForm.DidYouLabel.Caption := FTitle;
     end;
end;

{ Set a tip on the form }
procedure TNvTipOfTheDay.SetTip(const Value: string);
begin
  if (Value <> FTip) then
     begin
       FTip := Value;
       if Active then FTipForm.TipLabel.Caption := FTip;
     end;
end;

{ Show the tip of the day form with it's next tip }
procedure TNvTipOfTheDay.Show;
begin
  if not Active then
     begin
       FTipForm := TNvTipOfTheDayForm.Create(Application);
       FActive := True;
     end;
  with FTipForm do
    begin
      NextTipBtn.Visible := FNextBtnVisible;
      NextTipBtn.Enabled := FNextBtnEnabled;
      chkShowTips.Visible := FStartupCheckboxVisible;
      chkShowTips.Checked := FStartupCheckboxChecked;
      NextTipBtn.OnClick := GetTipHandler;
      TipLabel.Caption := FTip;
      chkShowTips.OnClick := chkTipHandler;
      NextTipBtn.Click;
      DidYouLabel.Caption := FTitle;
      Show;
    end;
end;

{ Hide the tip of the day form }
procedure TNvTipOfTheDay.Hide;
var
  Reg: TRegIniFile;
begin
  if Active then
     begin
       if (FRegistryKey <> '') and (not (csDesigning in ComponentState)) then
          begin
            Reg := TRegIniFile.Create(FRegistryKey);
            Reg.WriteInteger('TipOfTheDay', 'TipNumber', TipNumber);
            Reg.WriteBool('TipOfTheDay', 'ShowAtStart',
                          FStartupCheckboxChecked);
            Reg.Free;
          end;
       FTipForm.Close;
       FTipForm := nil;
       FActive := False;
     end;
end;

{ Form Event Handler for the 'Show Tips at Startup' checkbox }
procedure TNvTipOfTheDay.chkTipHandler(Sender: TObject);
begin
  if Active then
     FStartupCheckboxChecked := FTipForm.chkShowTips.Checked;
end;

{ Form Event Handler for the 'Next Tip' button }
procedure TNvTipOfTheDay.GetTipHandler(Sender: TObject);
var
  TextFile: Text;
  StoreFileMode: Integer;
  Index: Integer;
  TempTip: string;
begin
  NextBtnEnabled := True;
  if (FileExists(FTipFile)) then
     begin
       inc(TipNumber);
       StoreFileMode := FileMode;
       FileMode := 0;
       AssignFile(TextFile, FTipFile);
       Reset(TextFile);
       for Index := 1 to TipNumber do
           Readln(TextFile, TempTip);
       if (SeekEof(TextFile)) and (TempTip = '') then
          begin
            NextBtnEnabled := False;
            Tip := 'There are no more tips.  Click the "Show tips at startup"' +
                   ' checkbox to prevent these tips from displaying each time' +
                   ' this application is loaded.';
            TipNumber := 0;
          end
         else
          Tip := TempTip;
       CloseFile(TextFile);
       FileMode := StoreFileMode;
     end
   else
     begin
       NextBtnEnabled := False;
       Tip := 'The "Tip Of The Day" tips file can not be found.  You may need' +
              ' to reinstall this application to use them again.';
     end;
end;

{ Destroy this object }
destructor TNvTipOfTheDay.Destroy;
begin
  Hide;
  inherited Destroy;
end;

end.
