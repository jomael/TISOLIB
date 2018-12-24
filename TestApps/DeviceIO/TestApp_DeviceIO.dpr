program TestApp_DeviceIO;

uses
  Forms,
  ISOToolBox in '..\..\Library\Misc\ISOToolBox.pas',
  ISOException in '..\..\Library\Misc\ISOException.pas',
  ISOIntStructs in '..\..\Library\Misc\ISOIntStructs.pas',
  ISOStructs in '..\..\Library\Misc\ISOStructs.pas',
  GlobalDefs in '..\..\Library\Misc\GlobalDefs.pas',
  ISOASPILoader in '..\..\Library\DeviceIO\ISOASPILoader.pas',
  ISODiscLib in '..\..\Library\DeviceIO\ISODiscLib.pas',
  ISOSCSIConsts in '..\..\Library\DeviceIO\ISOSCSIConsts.pas',
  ISOSCSIStructs in '..\..\Library\DeviceIO\ISOSCSIStructs.pas',
  Main in 'Main.pas' {MainForm};

{$R *.res}

begin
  Application.Initialize;
  Application.CreateForm(TMainForm, MainForm);
  Application.Run;
end.
