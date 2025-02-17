; -----------------------------------------------------
; Get My IP
; -----------------------------------------------------

#define MyAppName "Get My IP"
#define MyAppExeName "GetMyIP.exe"
#define MyCompanyName "T_K"
#define MyPublisherName "Tim Kennedy"
#define CurrentYear GetDateTimeString('yyyy', '/', ':')
#define MyCopyright "(C) " + CurrentYear + " Tim Kennedy"
#define MyAppNameNoSpaces StringChange(MyAppName, " ", "")
#define MyDateTimeString GetDateTimeString('yyyy/mm/dd hh:nn:ss', '/', ':')

#define BaseDir "D:\Visual Studio\Source\Prod\GetMyIP\GetMyIP"
#define MySourceDir BaseDir + "\bin\Publish"
#define MySetupIcon BaseDir + "\Images\IP.ico"
#define MyAppVersion GetStringFileInfo(MySourceDir + "\" + MyAppExeName, "FileVersion")
#define MyInstallerFilename MyAppNameNoSpaces + "_" + MyAppVersion + "_Setup"
#define MyOutputDir "D:\InnoSetup\Output"
#define MyLargeImage "D:\InnoSetup\Images\WizardImage.bmp"

[Setup]
; NOTE: The value of AppId uniquely identifies this application.
; Do not use the same AppId value in installers for other applications.
; (To generate a new GUID, click Tools | Generate GUID inside the IDE.)
;---------------------------------------------
AppId={{EBEA37CE-1C9C-44C2-ACE3-102E6BF79364}

;---------------------------------------------
; Uncomment the following line to run in non administrative install mode (install for current user only.)
; Installs in %localappdata%\Programs\ instead of \Program Files(x86)
;---------------------------------------------
PrivilegesRequired=lowest
;---------------------------------------------

AllowNoIcons=yes
AppCopyright={#MyCopyright}
AppName={#MyAppName}
AppPublisher={#MyPublisherName}
AppSupportURL=https://github.com/Timthreetwelve/GetMyIP
AppVerName={#MyAppName} {#MyAppVersion}
AppVersion={#MyAppVersion}
Compression=lzma
DefaultDirName={autopf}\{#MyCompanyName}\{#MyAppName}
DefaultGroupName={#MyAppName}
DisableDirPage=yes
DisableProgramGroupPage=yes
DisableReadyMemo=no
DisableStartupPrompt=yes
DisableWelcomePage=no
OutputBaseFilename={#MyInstallerFilename}
OutputDir={#MyOutputDir}
OutputManifestFile={#MyAppName}_{#MyAppVersion}_FileList.txt
SetupIconFile={#MySetupIcon}
SetupLogging=yes
ShowLanguageDialog = yes
SolidCompression = no
SourceDir ={#MySourceDir}
UninstallDisplayIcon={app}\{#MyAppExeName}
VersionInfoVersion={#MyAppVersion}
WizardImageFile={#MyLargeImage}
WizardSizePercent=100,100
WizardStyle=modern

[Languages]
; https://jrsoftware.org/ishelp/index.php?topic=languagessection
Name: "en"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\Default.isl"
Name: "nl"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\Dutch.isl"
Name: "fr"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\French.isl"
Name: "de"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\German.isl"
Name: "it"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\Italian.isl"
Name: "es"; MessagesFile: "d:\Visual Studio\Source\Prod\Installer_Languages\Spanish.isl"

[LangOptions]
DialogFontSize=9
DialogFontName="Segoe UI"
WelcomeFontSize=14
WelcomeFontName="Segoe UI"

[Messages]
SetupWindowTitle = Setup - {#MyAppName} {#MyAppVersion}

[Files]
Source: "{#MySourceDir}\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\*.dll"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs
Source: "{#MySourceDir}\*.json"; Excludes: "usersettings.json"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\ReadMe.txt"; DestDir: "{app}"; Flags: ignoreversion
Source: "{#MySourceDir}\License.txt"; DestDir: "{app}"; Flags: ignoreversion

[InstallDelete]
; Delete these files & folders from previous installs
Type: filesandordirs; Name: "{group}"
Type: files; Name: "{app}\Nlog.config"

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"

[Registry]
Root: HKCU; Subkey: "Software\{#MyCompanyName}"; Flags: uninsdeletekeyifempty
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: String; ValueName: "Copyright"; ValueData: "{#MyCopyright}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: String; ValueName: "Install Date"; ValueData: "{#MyDateTimeString}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: String; ValueName: "Version"; ValueData: "{#MyAppVersion}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: String; ValueName: "Install Folder"; ValueData: "{autopf}\{#MyCompanyName}\{#MyAppName}"; Flags: uninsdeletekey
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: String; ValueName: "Installer Language"; ValueData:"{language}" ;Flags: uninsdeletekey
; Delete this key from previous installs
Root: HKCU; Subkey: "Software\{#MyCompanyName}\{#MyAppName}"; ValueType: none; ValueName: "Edition"; Flags: uninsdeletekey deletevalue

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent unchecked shellexec
Filename: "{app}\ReadMe.txt"; Description: "View the ReadMe file"; Flags: nowait postinstall skipifsilent unchecked shellexec

[UninstallDelete]
Type: files; Name: "{app}\*.txt"

[ThirdParty]
CompileLogFile = D : \InnoSetup\Logs\log.txt

; -----------------------------------------------------------------------------
; Code section follows
; -----------------------------------------------------------------------------
[Code]
// function used to check if app Is currently running
Function IsAppRunning(Const FileName : String): Boolean;
var
FSWbemLocator: Variant;
    FWMIService: Variant;
    FWbemObjectSet: Variant;
begin
    Result := false;
    FSWbemLocator := CreateOleObject('WBEMScripting.SWBEMLocator');
    FWMIService := FSWbemLocator.ConnectServer('', 'root\CIMV2', '', '');
    FWbemObjectSet :=
      FWMIService.ExecQuery(
        Format('SELECT Name FROM Win32_Process Where Name="%s"', [FileName]));
    Result:=(FWbemObjectSet.Count > 0);
    FWbemObjectSet := Unassigned;
    FWMIService := Unassigned;
    FSWbemLocator := Unassigned;
End;

// Checks if app Is running, if so, displays msgbox asking to close running app
Function InitializeSetup() : Boolean;
var
Answer: Integer;
  ThisApp: String;
begin
    Result := true;
  ThisApp := ExpandConstant('{#MyAppExeName}');
  While IsAppRunning(ThisApp) Do
  begin
        Answer := MsgBox(ThisApp + ' ' + CustomMessage('AppIsRunning'), mbError, MB_OKCANCEL);
    If Answer = IDCANCEL Then
            begin
            Result := false;
      Exit;
    End;
  End;
End;

// Copies setup log to app folder
procedure CurStepChanged(CurStep: TSetupStep);
var
            logfilepathname, newfilepathname: String;
begin
            If CurStep = ssDone Then
                begin
                logfilepathname := ExpandConstant('{log}');
      newfilepathname := ExpandConstant('{app}\') + 'Setup_Log.txt';
      Log('Setup log file copied to: ' + newfilepathname);
      FileCopy(logfilepathname, newfilepathname, False);
   End;
End;

// Uninstall
procedure CurUninstallStepChanged(CurUninstallStep: TUninstallStep);
var
mres:           Integer;
begin
                Case CurUninstallStep Of
      usPostUninstall:
                begin
                mres := MsgBox(CustomMessage('DeleteConfigFiles'), mbConfirmation, MB_YESNO or MB_DEFBUTTON2)
          If mres = IDYES Then
                    begin
                    DelTree(ExpandConstant('{app}\*.json'), False, True, False);
            DelTree(ExpandConstant('{app}'), True, True, True);
          end;
       End;
   End;
End;
