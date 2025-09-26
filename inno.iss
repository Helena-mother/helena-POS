; Script Inno Setup com PATH e variável de ambiente configurados

#define MyAppName "Helena POS"
#define MyAppVersion "3.2"
#define MyAppPublisher "syshard, Inc."
#define MyAppURL "https://helena.web.app"
#define MyAppExeName "Helena pos.exe"
#define MyAppAssocName MyAppName + ""
#define MyAppAssocExt ".exe"
#define MyAppAssocKey StringChange(MyAppAssocName, " ", "") + MyAppAssocExt

[Setup]
AppId={{0EBD2CFA-1BA6-44CF-98B6-F213A6B1404A}}
AppName={#MyAppName}
AppVersion={#MyAppVersion}
AppPublisher={#MyAppPublisher}
AppPublisherURL={#MyAppURL}
AppSupportURL={#MyAppURL}
AppUpdatesURL={#MyAppURL}
DefaultDirName={localappdata}\{#MyAppName}
ArchitecturesAllowed=x64compatible
ArchitecturesInstallIn64BitMode=x64compatible
ChangesAssociations=yes
DisableProgramGroupPage=yes
OutputDir=C:\Users\dell\Desktop
OutputBaseFilename=Helena pos-win32-x64
SetupIconFile=C:\Users\dell\Music\Helena POS\resources\app\256x256.ico
Compression=lzma
SolidCompression=yes
WizardStyle=modern

[Languages]
Name: "english"; MessagesFile: "compiler:Default.isl"
Name: "brazilianportuguese"; MessagesFile: "compiler:Languages\BrazilianPortuguese.isl"
Name: "french"; MessagesFile: "compiler:Languages\French.isl"
Name: "portuguese"; MessagesFile: "compiler:Languages\Portuguese.isl"

[Tasks]
Name: "desktopicon"; Description: "{cm:CreateDesktopIcon}"; GroupDescription: "{cm:AdditionalIcons}"; Flags: unchecked

[Files]
Source: "C:\Users\dell\Music\Helena POS\{#MyAppExeName}"; DestDir: "{app}"; Flags: ignoreversion
Source: "C:\Users\dell\Music\Helena POS\*"; DestDir: "{app}"; Flags: ignoreversion recursesubdirs createallsubdirs

[Registry]
; Associação de extensões
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocExt}\OpenWithProgids"; ValueType: string; ValueName: "{#MyAppAssocKey}"; ValueData: ""; Flags: uninsdeletevalue
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}"; ValueType: string; ValueName: ""; ValueData: "{#MyAppAssocName}"; Flags: uninsdeletekey
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\DefaultIcon"; ValueType: string; ValueName: ""; ValueData: "{app}\{#MyAppExeName},0"
Root: HKA; Subkey: "Software\Classes\{#MyAppAssocKey}\shell\open\command"; ValueType: string; ValueName: ""; ValueData: """{app}\{#MyAppExeName}"" ""%1"""
Root: HKA; Subkey: "Software\Classes\Applications\{#MyAppExeName}\SupportedTypes"; ValueType: string; ValueName: ".myp"; ValueData: ""

; Variável de ambiente para o usuário atual
Root: HKCU; Subkey: "Environment"; ValueType: string; ValueName: "HELENA_POS_HOME"; ValueData: "{app}"; Flags: preservestringtype

; Adiciona {app} ao PATH, se ainda não estiver
Root: HKCU; Subkey: "Environment"; ValueType: string; ValueName: "PATH"; ValueData: "{code:AppendToPath}"; Check: NeedsPathUpdate

[Icons]
Name: "{autoprograms}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"
Name: "{autodesktop}\{#MyAppName}"; Filename: "{app}\{#MyAppExeName}"; Tasks: desktopicon

[Run]
Filename: "{app}\{#MyAppExeName}"; Description: "{cm:LaunchProgram,{#StringChange(MyAppName, '&', '&&')}}"; Flags: nowait postinstall skipifsilent

[Code]
function GetEnvPath(): string;
begin
  Result := ExpandConstant('{reg:HKCU\Environment,PATH|}');
end;

function NeedsPathUpdate(): Boolean;
var
  pathVal: string;
begin
  pathVal := GetEnvPath();
  Result := Pos(ExpandConstant('{app}'), pathVal) = 0;
end;

function AppendToPath(Param: string): string;
var
  pathVal: string;
begin
  pathVal := GetEnvPath();
  if pathVal = '' then
    Result := ExpandConstant('{app}')
  else
    Result := pathVal + ';' + ExpandConstant('{app}');
end;
