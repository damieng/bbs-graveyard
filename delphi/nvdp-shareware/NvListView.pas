unit NvListView;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvListView
  Type:     Component
  Contains: TNvListView         "ListView with sorting & width facilities"
                                Inspired by Windows 95/NT Explorer.
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2.0 release.
            05-May-1997   DPG   Added new Delphi 3.0 properties.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvListView, source tidy.

  Future:
*******************************************************************************}

interface

uses Classes, ComCtrls, CommCtrl, SysUtils, Windows;

type
  TNvListView = class(TListView)
  private
    FAutoSort: Boolean;
    FLastColumn: Integer;
    FOnColumnClick: TLVColumnClickEvent;
    FOnAfterSort: TNotifyEvent;
    FSortAscending: Boolean;
  protected
    procedure ColClick(Column: TListColumn); override;
  public
    constructor Create(AOwner: TComponent); override;
    procedure AutoSizeColumns;
    procedure AutoSizeColumn(ColumnIdx: Integer);
    procedure Resort;
    procedure SortColumn(ColumnIdx: Integer; Ascending: Boolean);
    procedure StopSorting;
  published
    property AutoSort: Boolean read FAutoSort write FAutoSort default False;
    property OnAfterSort: TNotifyEvent read FOnAfterSort write FOnAfterSort;
  end;

{ Sorting routines forward-declarations }
function SortAscendCaption(Item1, Item2: TListItem;
         ParamSort: Integer): Integer; stdcall;
function SortAscendSubItem(Item1, Item2: TListItem;
         Idx: Integer): Integer; stdcall;
function SortDescendCaption(Item2, Item1: TListItem;
         ParamSort: Integer): Integer; stdcall;
function SortDescendSubItem(Item2, Item1: TListItem;
         Idx: Integer): Integer; stdcall;

implementation

{ create object, assign defaults }
constructor TNvListView.Create(AOwner: TComponent);
begin
  inherited Create(AOwner);
  FAutoSort := False;
  FLastColumn := -1;
  FSortAscending := True;
end;

{ Column click handler to process sorting request }
procedure TNvListView.ColClick(Column: TListColumn);
begin
  if Assigned(FOnColumnClick) then FOnColumnClick(Self, Column);
  if FAutoSort then
     begin
       if (Column.Index = FLastColumn) then
          FSortAscending := not FSortAscending
        else
          FSortAscending := True;
       FLastColumn := Column.Index;
       Resort;
       if Assigned(FOnAfterSort) then FOnAfterSort(Self);
     end;
end;

{ Method to allow the listview to resort with current criteria }
procedure TNvListView.Resort;
begin
  if FAutoSort then SortColumn(FLastColumn, FSortAscending);
end;

{ Actual code to work the sort depending on desired column }
procedure TNvListView.SortColumn(ColumnIdx: Integer; Ascending: Boolean);
begin
  if (ColumnIdx = 0) then
     begin
       if Ascending then
          CustomSort(@SortAscendCaption, 0)
        else
          CustomSort(@SortDescendCaption, 0);
     end;
  if (ColumnIdx > 0) then
     begin
       if Ascending then
          CustomSort(@SortAscendSubItem, ColumnIdx-1)
        else
          CustomSort(@SortDescendSubItem, ColumnIdx-1);
     end;
end;

{ Automatically size all the columns }
procedure TNvListView.AutoSizeColumns;
var
  Index: Integer;
begin
  for Index := 0 to Columns.Count do
      ListView_SetColumnWidth(Handle, Index, LVSCW_AUTOSIZE);
end;

{ Automatically size a single column }
procedure TNvListView.AutoSizeColumn(ColumnIdx: Integer);
begin
  ListView_SetColumnWidth(Handle, ColumnIdx, LVSCW_AUTOSIZE);
end;

{ Code to switch furter sorting by Resort off }
procedure TNvListView.StopSorting;
begin
  FLastColumn := -1;
end;

{ Sort Ascending by Caption }
function SortAscendCaption(Item1, Item2: TListItem;
         ParamSort: Integer): Integer; stdcall;
begin
  if (StrToIntDef(Item1.Caption, 0) <> 0) and
     (StrToIntDef(Item2.Caption, 0) <> 0) then
     Result := StrToIntDef(Item1.Caption, 0) - StrToIntDef(Item2.Caption, 0)
   else
     Result := lstrcmp(PChar(Item1.Caption), PChar(Item2.Caption));
  if (ParamSort = 1) then Result := - Result;
end;

{ Sort Ascending by SubItem }
function SortAscendSubItem(Item1, Item2: TListItem;
         Idx: Integer): Integer; stdcall;
begin
  if (Item1.SubItems.Count < Idx+1) then Result := -1
   else
     if (Item2.SubItems.Count < Idx+1) then Result := 1
      else
        if (StrToIntDef(Item1.SubItems[Idx], 0) <> 0) and
           (StrToIntDef(Item2.SubItems[Idx], 0) <> 0) then
           Result := StrToIntDef(Item1.SubItems[Idx], 0) -
                     StrToIntDef(Item2.SubItems[Idx],0)
         else
           Result := lstrcmp(PChar(Item1.SubItems[Idx]),
                     PChar(Item2.SubItems[Idx]));
end;

{ Sort Descending by Caption }
function SortDescendCaption(Item2, Item1: TListItem;
         ParamSort: Integer): Integer; stdcall;
begin
  if (StrToIntDef(Item1.Caption, 0) <> 0) and
     (StrToIntDef(Item2.Caption, 0) <> 0) then
     Result := StrToIntDef(Item1.Caption, 0) - StrToIntDef(Item2.Caption, 0)
   else
     Result := lstrcmp(PChar(Item1.Caption), PChar(Item2.Caption));
  if (ParamSort = 1) then Result := -Result;
end;

{ Sort Descending by Subitem }
function SortDescendSubItem(Item2, Item1: TListItem;
         Idx: Integer): Integer; stdcall;
begin
  if (Item1.SubItems.Count < Idx+1) then Result := -1
   else
     if (Item2.SubItems.Count < Idx+1) then Result := +1
      else
        if (StrToIntDef(Item1.SubItems[Idx], 0) <> 0) and
           (StrToIntDef(Item2.SubItems[Idx], 0) <> 0) then
           Result := StrToIntDef(Item1.SubItems[Idx], 0) -
                     StrToIntDef(Item2.SubItems[Idx],0)
         else
           Result := lstrcmp(PChar(Item1.SubItems[Idx]),
                     PChar(Item2.SubItems[Idx]));
end;

end.
