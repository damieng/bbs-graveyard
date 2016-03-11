unit NvDBLabel;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvDBLabel
  Type:     Component
  Contains: TNvDBLabel          "Database aware label with 3D/Hyperlink"
                                Inspired by Internet Explorer.
  Version:  v1.0

  Changes:  22-Jul-1997   DPG   New component.
            05-Aug-1997   DPG   Renamed to TNvDBLabel, source tidy.

  Future:   Allow hyperlink to be assigned to a field too.
*******************************************************************************}

interface

uses
  Windows, Messages, SysUtils, Classes, Graphics, Controls, Forms, Dialogs,
  StdCtrls, DBCtrls, DB, NvLabel;

type
  TNvDBLabel = class(TNvLabel)
  private
    FDataLink: TFieldDataLink;
    procedure DataChange(Sender: TObject);
    function GetDataField: string;
    function GetDataSource: TDataSource;
    function GetField: TField;
    function GetFieldText: string;
    procedure SetDataField(const Value: string);
    procedure SetDataSource(Value: TDataSource);
    procedure CMGetDataLink(var Message: TMessage); message CM_GETDATALINK;
  protected
    function GetLabelText: string; override;
    procedure Loaded; override;
    procedure Notification(AComponent: TComponent; Operation: TOperation);
              override;
  public
    constructor Create(AOwner: TComponent); override;
    destructor Destroy; override;
    property Field: TField read GetField;
  published
    property DataField: string read GetDataField write SetDataField;
    property DataSource: TDataSource read GetDataSource write SetDataSource;
  end;

implementation

{ Create object, create DataLink and assign }
constructor TNvDBLabel.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FDataLink := TFieldDataLink.Create;
  FDataLink.Control := Self;
  FDataLink.OnDataChange := DataChange;
end;

{ Free DataLink, release object }
destructor TNvDBLabel.Destroy;
begin
  FDataLink.Free;
  FDataLink := nil;
  inherited Destroy;
end;

{ Once loaded, update caption }
procedure TNvDBLabel.Loaded;
begin
  inherited Loaded;
  if (csDesigning in ComponentState) then DataChange(Self);
end;

{ Notify if DataSource no longer available }
procedure TNvDBLabel.Notification(AComponent: TComponent;
          Operation: TOperation);
begin
  inherited Notification(AComponent, Operation);
  if (Operation = opRemove) and
     (FDataLink <> nil) and
     (AComponent = DataSource) then DataSource := nil;
end;

{ Get the DataLink source }
function TNvDBLabel.GetDataSource: TDataSource;
begin
  Result := FDataLink.DataSource;
end;

{ Set the DataLink source }
procedure TNvDBLabel.SetDataSource(Value: TDataSource);
begin
  FDataLink.DataSource := Value;
  if (Value <> nil) then Value.FreeNotification(Self);
end;

{ Get the DataLink field }
function TNvDBLabel.GetDataField: string;
begin
  Result := FDataLink.FieldName;
end;

{ Set the DataLink field }
procedure TNvDBLabel.SetDataField(const Value: string);
begin
  FDataLink.FieldName := Value;
end;

{ Get the field }
function TNvDBLabel.GetField: TField;
begin
  Result := FDataLink.Field;
end;

{ Get the field text }
function TNvDBLabel.GetFieldText: string;
begin
  if (FDataLink.Field <> nil) then
     Result := FDataLink.Field.DisplayText
   else
     if (csDesigning in ComponentState) then Result := Name else Result := '';
end;

{ If data has changed, reflect in the caption }
procedure TNvDBLabel.DataChange(Sender: TObject);
begin
  Caption := GetFieldText;
end;

{ Get the label text }
function TNvDBLabel.GetLabelText: string;
begin
  if (csPaintCopy in ControlState) then
     Result := GetFieldText
   else
     Result := Caption;
end;

procedure TNvDBLabel.CMGetDataLink(var Message: TMessage);
begin
  Message.Result := Integer(FDataLink);
end;

end.
