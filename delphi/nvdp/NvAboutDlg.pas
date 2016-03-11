unit NvAboutDlg;

{*******************************************************************************
  Envy Development Pack for Delphi 3
  Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  Unit:     NvAboutDlg
  Type:     Component
  Contains: TNvAboutDlg         "Help > About dialog box"
                                Inspired by Windows 95/NT system about dialog.
  Version:  v1.0

  Changes:  05-May-1997   DPG   Created from Delphi 2.0 version.
            21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.
            05-Aug-1997   DPG   Renamed to TNvAboutDlg, source tidy + comment.

  Future:   Change so that appears as Windows 95 style on 95, NT on NT
*******************************************************************************}

interface

uses Classes, NvAboutDlgForm, SysUtils, Windows, Forms;

type
  TNvAboutDlg = class(TComponent)
  private
    FCompany: string;
    FCopyright: string;
    FProduct: string;
    FTitle: string;
    FUser: string;
    FVersion: string;
  published
    property Company: string read FCompany write FCompany;
    property Copyright: string read FCopyright write FCopyright;
    property Product: string read FProduct write FProduct;
    property Title: string read FTitle write FTitle;
    property User: string read FUser write FUser;
    property Version: string read FVersion write FVersion;
  public
    function Execute: Boolean;
  end;

implementation

{ Execution method }
function TNvAboutDlg.Execute: Boolean;
var
  MemoryStruct: TMemoryStatus;
  OSVersionInfo: TOSVersionInfo;
  Memory: string;
  Version: string;
  AboutDlgForm: TNvAboutDlgForm;
begin
  AboutDlgForm := TNvAboutDlgForm.Create(Application);

  { Get memory information }
  MemoryStruct.dwLength := SizeOf(MemoryStruct);
  GlobalMemoryStatus(MemoryStruct);
  MemoryStruct.dwTotalPhys := MemoryStruct.dwTotalPhys div 1024;
  Memory := IntToStr(MemoryStruct.dwTotalPhys);

  { Get operating system information }
  OSVersionInfo.dwOSVersionInfoSize := SizeOf(OSVersionInfo);
  GetVersionEx(OSVersionInfo);
  Version := 'Windows ';
  case OSVersionInfo.dwPlatformID of
       VER_PLATFORM_WIN32s        : Version := Version + '(Win32s)';
       VER_PLATFORM_WIN32_WINDOWS : Version := Version + '95';
       VER_PLATFORM_WIN32_NT      : Version := Version + 'NT';
  end;

  { Generate build number }
  Version := Version + ' v' + IntToStr(OSVersionInfo.dwMajorVersion) +
                       '.' + IntToStr(OSVersionInfo.dwMinorVersion) +
                       ' (Build ' + IntToStr(Word(OSVersionInfo.dwBuildNumber))
                     + ')';
  try
    if (FProduct = '') then FProduct := Application.Title;

    { Display the about dialog box }
    with AboutDlgForm do
       begin
         Caption := FTitle;
         lWVe.Caption := Version;
         lRAM.Caption := Copy(Memory,1,length(Memory) -3) + ','
                       + Copy(Memory,length(Memory)-2,10) + ' KB';
         lPro.Caption := FProduct;
         lVer.Caption := FVersion;
         lCop.Caption := FCopyright;
         lUsr.Caption := FUser;
         lCom.Caption := FCompany;
         imgPro.Picture.Icon := Application.Icon;
         Result := (ShowModal = IDOK);
       end;
  finally
    AboutDlgForm.Free;
  end;
end;

end.
