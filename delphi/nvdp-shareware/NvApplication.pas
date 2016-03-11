unit NvApplication;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvApplication
  Type:     Component
  Contains: TNvApplication      "Design-time wrapper with additional methods"
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2 version.
            05-May-1997   DPG   Added new events and properties.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvApplication, source tidy.
            05-Aug-1997   DPG   Changed SetHelpFile parameter to constant.

  Future:   Prevent multiple instances
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TDisplayChangeEvent = procedure(Sender: TObject; BitsPerPixel: Integer;
                        HorizontalRes: Integer; VerticalRes: Integer) of object;

  TNvApplication = class(TComponent)
  private
    FApplication: TApplication;
    FFreeOLELibrary: Boolean;
    FOnDisplayChange: TDisplayChangeEvent;
    FOnFontChange: TNotifyEvent;
    function GetHelpFile: string;
    procedure SetHelpFile(const Value: string);
    function GetHintColor: TColor;
    procedure SetHintColor(Value: TColor);
    function GetHintHidePause: Integer;
    procedure SetHintHidePause(Value: Integer);
    function GetHintPause: Integer;
    procedure SetHintPause(Value: Integer);
    function GetHintShortPause: Integer;
    procedure SetHintShortPause(Value: Integer);
    function GetShowHint: Boolean;
    procedure SetShowHint(Value: Boolean);
    function GetUpdateFormatSettings: Boolean;
    procedure SetUpdateFormatSettings(Value: Boolean);
    function GetOnActivate: TNotifyEvent;
    procedure SetOnActivate(Value: TNotifyEvent);
    function GetOnDeactivate: TNotifyEvent;
    procedure SetOnDeactivate(Value: TNotifyEvent);
    function GetOnException: TExceptionEvent;
    procedure SetOnException(Value: TExceptionEvent);
    function GetOnHelp: THelpEvent;
    procedure SetOnHelp(Value: THelpEvent);
    function GetOnHint: TNotifyEvent;
    procedure SetOnHint(Value: TNotifyEvent);
    function GetOnIdle: TIdleEvent;
    procedure SetOnIdle(Value: TIdleEvent);
    function GetOnMessage: TMessageEvent;
    procedure SetOnMessage(Value: TMessageEvent);
    function GetOnMinimize: TNotifyEvent;
    procedure SetOnMinimize(Value: TNotifyEvent);
    function GetOnRestore: TNotifyEvent;
    procedure SetOnRestore(Value: TNotifyEvent);
    function GetOnShowHint: TShowHintEvent;
    procedure SetOnShowHint(Value: TShowHintEvent);
  protected
    property Application: TApplication read FApplication;
    procedure Loaded; override;
    function MsgHook(var Msg: TMessage): Boolean; virtual;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    procedure HelpContents;
    procedure HelpIndex;
    procedure Hide;
    procedure Show;
  published
    property FreeOLELibrary: Boolean read FFreeOLELibrary write FFreeOLELibrary
             default False;
    property HelpFile: string read GetHelpFile write SetHelpFile;
    property HintColor: TColor read GetHintColor write SetHintColor;
    property HintHidePause: Integer read GetHintHidePause
             write SetHintHidePause;
    property HintPause: Integer read GetHintPause write SetHintPause;
    property HintShortPause: Integer read GetHintShortPause
             write SetHintShortPause;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    property UpdateFormatSettings: Boolean read GetUpdateFormatSettings
             write SetUpdateFormatSettings;
    property OnActivate: TNotifyEvent read GetOnActivate write SetOnActivate;
    property OnDeactivate: TNotifyEvent read GetOnDeactivate
             write SetOnDeactivate;
    property OnDisplayChange: TDisplayChangeEvent read FOnDisplayChange
             write FOnDisplayChange;
    property OnException: TExceptionEvent read GetOnException
             write SetOnException;
    property OnFontChange: TNotifyEvent read FOnFontChange write FOnFontChange;
    property OnHelp: THelpEvent read GetOnHelp write SetOnHelp;
    property OnHint: TNotifyEvent read GetOnHint write SetOnHint;
    property OnIdle: TIdleEvent read GetOnIdle write SetOnIdle;
    property OnMessage: TMessageEvent read GetOnMessage write SetOnMessage;
    property OnMinimize: TNotifyEvent read GetOnMinimize write SetOnMinimize;
    property OnRestore: TNotifyEvent read GetOnRestore write SetOnRestore;
    property OnShowHint: TShowHintEvent read GetOnShowHint write SetOnShowHint;
  end;

implementation

{ Create object, assign defaults, attach message hook routine }
constructor TNvApplication.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  if (Owner <> nil) and (csDesigning in Owner.ComponentState) then
     begin
       FApplication := TApplication.Create(nil);
       FApplication.ShowHint := True;
     end
   else
     begin
       FApplication := Forms.Application;
       Application.HookMainWindow(MsgHook);
     end;
  FFreeOLELibrary := False;
  FOnDisplayChange := nil;
  FOnFontChange := nil;
end;

{ Unhook message handler, free design-time object }
destructor TNvApplication.Destroy;
begin
  if (csDesigning in ComponentState) then
     Application.Free
   else
     Application.UnhookMainWindow(MsgHook);
  inherited Destroy;
end;

{ Apply run-time only settings }
procedure TNvApplication.Loaded;
begin
  if (FFreeOLELibrary) then FreeLibrary(GetModuleHandle('OleAut32'));
end;

{ Properties handlers to wrap TApplication object }
function TNvApplication.GetHelpFile: string;
begin
  Result := Application.HelpFile;
end;

procedure TNvApplication.SetHelpFile(const Value: string);
begin
  Application.HelpFile := Value;
end;

function TNvApplication.GetHintColor: TColor;
begin
  Result := Application.HintColor;
end;

procedure TNvApplication.SetHintColor(Value: TColor);
begin
  Application.HintColor := Value;
end;

function TNvApplication.GetHintHidePause: Integer;
begin
  Result := Application.HintHidePause;
end;

procedure TNvApplication.SetHintHidePause(Value: Integer);
begin
  Application.HintHidePause := Value;
end;

function TNvApplication.GetHintPause: Integer;
begin
  Result := Application.HintPause;
end;

procedure TNvApplication.SetHintPause(Value: Integer);
begin
  Application.HintPause := Value;
end;

function TNvApplication.GetHintShortPause: Integer;
begin
  Result := Application.HintShortPause;
end;

procedure TNvApplication.SetHintShortPause(Value: Integer);
begin
  Application.HintShortPause := Value;
end;

function TNvApplication.GetShowHint: Boolean;
begin
  Result := Application.ShowHint;
end;

procedure TNvApplication.SetShowHint(Value: Boolean);
begin
  Application.ShowHint := Value;
end;

function TNvApplication.GetUpdateFormatSettings: Boolean;
begin
  Result := Application.UpdateFormatSettings;
end;

procedure TNvApplication.SetUpdateFormatSettings(Value: Boolean);
begin
  Application.UpdateFormatSettings := Value;
end;

function TNvApplication.GetOnActivate: TNotifyEvent;
begin
  Result := Application.OnActivate;
end;

procedure TNvApplication.SetOnActivate(Value: TNotifyEvent);
begin
  Application.OnActivate := Value;
end;

function TNvApplication.GetOnDeactivate: TNotifyEvent;
begin
  Result := Application.OnDeactivate;
end;

procedure TNvApplication.SetOnDeactivate(Value: TNotifyEvent);
begin
  Application.OnDeactivate := Value;
end;

function TNvApplication.GetOnException: TExceptionEvent;
begin
  Result := Application.OnException;
end;

procedure TNvApplication.SetOnException(Value: TExceptionEvent);
begin
  Application.OnException := Value;
end;

function TNvApplication.GetOnHelp: THelpEvent;
begin
  Result := Application.OnHelp;
end;

procedure TNvApplication.SetOnHelp(Value: THelpEvent);
begin
  Application.OnHelp := Value;
end;

function TNvApplication.GetOnHint: TNotifyEvent;
begin
  Result := Application.OnHint;
end;

procedure TNvApplication.SetOnHint(Value: TNotifyEvent);
begin
  Application.OnHint := Value;
end;

function TNvApplication.GetOnIdle: TIdleEvent;
begin
  Result := Application.OnIdle;
end;

procedure TNvApplication.SetOnIdle(Value: TIdleEvent);
begin
  Application.OnIdle := Value;
end;

function TNvApplication.GetOnMessage: TMessageEvent;
begin
  Result := Application.OnMessage;
end;

procedure TNvApplication.SetOnMessage(Value: TMessageEvent);
begin
  Application.OnMessage := Value;
end;

function TNvApplication.GetOnMinimize: TNotifyEvent;
begin
  Result := Application.OnMinimize;
end;

procedure TNvApplication.SetOnMinimize(Value: TNotifyEvent);
begin
  Application.OnMinimize := Value;
end;

function TNvApplication.GetOnRestore: TNotifyEvent;
begin
  Result := Application.OnRestore;
end;

procedure TNvApplication.SetOnRestore(Value: TNotifyEvent);
begin
  Application.OnRestore := Value;
end;

function TNvApplication.GetOnShowHint: TShowHintEvent;
begin
  Result := Application.OnShowHint;
end;

procedure TNvApplication.SetOnShowHint(Value: TShowHintEvent);
begin
  Application.OnShowHint := Value;
end;

{ Additional system events are monitored here }
function TNvApplication.MsgHook(var Msg: TMessage): Boolean;
begin
  Result := False;
  case Msg.Msg of
    { Screen resolution change }
    Wm_DisplayChange: if Assigned(FOnDisplayChange) then
                      FOnDisplayChange(Self, Msg.wParam, Loword(Msg.lParam),
                                       Hiword(Msg.lParam));
    { Windows fonts added/removed }
    Wm_FontChange: if Assigned(FOnFontChange) then
                      FOnFontChange(Self);
  end;
end;

{ Show help at the 'Index' tab }
procedure TNvApplication.HelpIndex;
begin
  FApplication.HelpCommand(Help_Finder, 0);
end;

{ Show the help Contents topic }
procedure TNvApplication.HelpContents;
begin
  FApplication.HelpCommand(Help_Contents, 0);
end;

{ Hide the application window }
procedure TNvApplication.Hide;
begin
  ShowWindow(FApplication.Handle, SW_HIDE);
end;

{ Show the application window }
procedure TNvApplication.Show;
begin
  ShowWindow(FApplication.Handle, SW_SHOW);
end;

end.
