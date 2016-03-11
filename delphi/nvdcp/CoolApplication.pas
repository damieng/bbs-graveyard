unit CoolApplication;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolApplication v0.9 - Design-time wrapper for Application object +
                          additional system event capturing.

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2 version.
  05-May-1997   DPG   Added new events and properties.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
  Prevent multiple instances
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs;

type
  TDisplayChangeEvent = procedure(Sender: TObject; BitsPerPixel: Integer; HorizontalRes: Integer; VerticalRes: Integer) of object;
  TCoolApplication = class(TComponent)
  private
    FApplication: TApplication;
    FOnDisplayChange: TDisplayChangeEvent;
    FOnFontChange: TNotifyEvent;
    FFreeOLELibrary: Boolean;
    function GetHelpFile: string;
    procedure SetHelpFile(Value: string);
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
    property FreeOLELibrary: Boolean read FFreeOLELibrary write FFreeOLELibrary default False;
    property HelpFile: string read GetHelpFile write SetHelpFile;
    property HintColor: TColor read GetHintColor write SetHintColor;
    property HintHidePause: Integer read GetHintHidePause write SetHintHidePause;
    property HintPause: Integer read GetHintPause write SetHintPause;
    property HintShortPause: Integer read GetHintShortPause write SetHintShortPause;
    property ShowHint: Boolean read GetShowHint write SetShowHint;
    property UpdateFormatSettings: Boolean read GetUpdateFormatSettings write SetUpdateFormatSettings;
    property OnActivate: TNotifyEvent read GetOnActivate write SetOnActivate;
    property OnDeactivate: TNotifyEvent read GetOnDeactivate write SetOnDeactivate;
    property OnDisplayChange: TDisplayChangeEvent read FOnDisplayChange write FOnDisplayChange;
    property OnException: TExceptionEvent read GetOnException write SetOnException;
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

{ Create the component, attach message hook routine }
constructor TCoolApplication.Create(AOwner: TComponent);
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
  FOnDisplayChange := nil;
  FOnFontChange := nil;
  FFreeOLELibrary := False;
end;

{ Unhook message handler & free design-time object }
destructor TCoolApplication.Destroy;
begin
  if (csDesigning in ComponentState) then
     Application.Free
   else
     Application.UnhookMainWindow(MsgHook);
  inherited Destroy;
end;

{ Apply design-time only settings }
procedure TCoolApplication.Loaded;
begin
  if (FFreeOLELibrary) then FreeLibrary(GetModuleHandle('OleAut32'));
end;

{ Properties to wrap TApplication object }
function TCoolApplication.GetHelpFile: string;
begin
  Result := Application.HelpFile;
end;

procedure TCoolApplication.SetHelpFile(Value: string);
begin
  Application.HelpFile := Value;
end;

function TCoolApplication.GetHintColor: TColor;
begin
  Result := Application.HintColor;
end;

procedure TCoolApplication.SetHintColor(Value: TColor);
begin
  Application.HintColor := Value;
end;

function TCoolApplication.GetHintHidePause: Integer;
begin
  Result := Application.HintHidePause;
end;

procedure TCoolApplication.SetHintHidePause(Value: Integer);
begin
  Application.HintHidePause := Value;
end;

function TCoolApplication.GetHintPause: Integer;
begin
  Result := Application.HintPause;
end;

procedure TCoolApplication.SetHintPause(Value: Integer);
begin
  Application.HintPause := Value;
end;

function TCoolApplication.GetHintShortPause: Integer;
begin
  Result := Application.HintShortPause;
end;

procedure TCoolApplication.SetHintShortPause(Value: Integer);
begin
  Application.HintShortPause := Value;
end;

function TCoolApplication.GetShowHint: Boolean;
begin
  Result := Application.ShowHint;
end;

procedure TCoolApplication.SetShowHint(Value: Boolean);
begin
  Application.ShowHint := Value;
end;

function TCoolApplication.GetUpdateFormatSettings: Boolean;
begin
  Result := Application.UpdateFormatSettings;
end;

procedure TCoolApplication.SetUpdateFormatSettings(Value: Boolean);
begin
  Application.UpdateFormatSettings := Value;
end;

function TCoolApplication.GetOnActivate: TNotifyEvent;
begin
  Result := Application.OnActivate;
end;

procedure TCoolApplication.SetOnActivate(Value: TNotifyEvent);
begin
  Application.OnActivate := Value;
end;

function TCoolApplication.GetOnDeactivate: TNotifyEvent;
begin
  Result := Application.OnDeactivate;
end;

procedure TCoolApplication.SetOnDeactivate(Value: TNotifyEvent);
begin
  Application.OnDeactivate := Value;
end;

function TCoolApplication.GetOnException: TExceptionEvent;
begin
  Result := Application.OnException;
end;

procedure TCoolApplication.SetOnException(Value: TExceptionEvent);
begin
  Application.OnException := Value;
end;

function TCoolApplication.GetOnHelp: THelpEvent;
begin
  Result := Application.OnHelp;
end;

procedure TCoolApplication.SetOnHelp(Value: THelpEvent);
begin
  Application.OnHelp := Value;
end;

function TCoolApplication.GetOnHint: TNotifyEvent;
begin
  Result := Application.OnHint;
end;

procedure TCoolApplication.SetOnHint(Value: TNotifyEvent);
begin
  Application.OnHint := Value;
end;

function TCoolApplication.GetOnIdle: TIdleEvent;
begin
  Result := Application.OnIdle;
end;

procedure TCoolApplication.SetOnIdle(Value: TIdleEvent);
begin
  Application.OnIdle := Value;
end;

function TCoolApplication.GetOnMessage: TMessageEvent;
begin
  Result := Application.OnMessage;
end;

procedure TCoolApplication.SetOnMessage(Value: TMessageEvent);
begin
  Application.OnMessage := Value;
end;

function TCoolApplication.GetOnMinimize: TNotifyEvent;
begin
  Result := Application.OnMinimize;
end;

procedure TCoolApplication.SetOnMinimize(Value: TNotifyEvent);
begin
  Application.OnMinimize := Value;
end;

function TCoolApplication.GetOnRestore: TNotifyEvent;
begin
  Result := Application.OnRestore;
end;

procedure TCoolApplication.SetOnRestore(Value: TNotifyEvent);
begin
  Application.OnRestore := Value;
end;

function TCoolApplication.GetOnShowHint: TShowHintEvent;
begin
  Result := Application.OnShowHint;
end;

procedure TCoolApplication.SetOnShowHint(Value: TShowHintEvent);
begin
  Application.OnShowHint := Value;
end;

{ Additional system events are monitored here }
function TCoolApplication.MsgHook(var Msg: TMessage): Boolean;
begin
  Result := False;
  case Msg.Msg of
    { Screen resolution change }
    Wm_DisplayChange: if Assigned(FOnDisplayChange) then
                         FOnDisplayChange(Self, Msg.wParam, Loword(Msg.lParam), Hiword(Msg.lParam));
    { Windows fonts added/removed }
    Wm_FontChange: if Assigned(FOnFontChange) then
                      FOnFontChange(Self);
  end;
end;

{ Show help at the 'Index' tab }
procedure TCoolApplication.HelpIndex;
begin
  FApplication.HelpCommand(Help_Finder, 0);
end;

{ Show the help Contents topic }
procedure TCoolApplication.HelpContents;
begin
  FApplication.HelpCommand(Help_Contents, 0);
end;

{ Hide the application window }
procedure TCoolApplication.Hide;
begin
  ShowWindow(FApplication.Handle, SW_HIDE);
end;

{ Show the application window }
procedure TCoolApplication.Show;
begin
  ShowWindow(FApplication.Handle, SW_SHOW);
end;

end.
