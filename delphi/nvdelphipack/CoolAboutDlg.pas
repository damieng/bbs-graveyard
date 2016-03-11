unit CoolAboutDlg;

{*******************************************************************************
  NVDPxxDX    Envy Dev Pack for Delphi 32 (Component Library)
              Copyright (c) 1996, 1997 Envy Technologies.  All rights reserved.

  TCoolAboutDlg v0.9 - Help > About Dialog

  Change Log
  ----------
  05-May-1997   DPG   Created from Delphi 2.0 version.
  21-May-1997   DPG   New Delphi 2/Delphi 3 compatible version.

  Future Ideas
  ------------
  Change so that appears as Windows 95 style on 95, NT on NT
*******************************************************************************}

interface

uses Classes, CoolAboutDlgForm, SysUtils, Windows, Forms;

type
  TCoolAboutDlg = class(TComponent)
  private
    FCopyright: string;
    FProduct: string;
    FVersion: string;
    FCompany: string;
    FUser: string;
    FTitle: string;
  published
    property Copyright: string read FCopyright write FCopyright;
    property Product: string read FProduct write FProduct;
    property Version: string read FVersion write FVersion;
    property Company: string read FCompany write FCompany;
    property User: string read FUser write FUser;
    property Title: string read FTitle write FTitle;
  public
    function Execute: Boolean;
  end;

implementation

{ Execution method }
function TCoolAboutDlg.Execute : Boolean;
var
  MemoryStruct: TMemoryStatus;
  OSVersionInfo: TOSVersionInfo;
  Memory: string;
  Version: string;
  AboutDlgForm: TCoolAboutDlgForm;
begin
  AboutDlgForm := TCoolAboutDlgForm.Create(Application);
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
