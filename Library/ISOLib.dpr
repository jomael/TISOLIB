Program ISOLib;

{%ToDo 'ISOLib.todo'}

uses
  Forms,
  ISOASPILoader in 'DeviceIO\ISOASPILoader.pas',
  ISODiscLib in 'DeviceIO\ISODiscLib.pas',
  ISOSCSIConsts in 'DeviceIO\ISOSCSIConsts.pas',
  ISOSCSIStructs in 'DeviceIO\ISOSCSIStructs.pas',
  VolumeDescriptors in 'Image\VolumeDescriptors.pas',
  ImageFileHandler in 'Image\ImageFileHandler.pas',
  ISOImage in 'Image\ISOImage.pas',
  DataTree in 'Image\DataTree.pas',
  ISOStructs in 'Misc\ISOStructs.pas',
  ISOException in 'Misc\ISOException.pas',
  ISOToolBox in 'Misc\ISOToolBox.pas',
  ISOIntStructs in 'Misc\ISOIntStructs.pas',
  GlobalDefs in 'Misc\GlobalDefs.pas';

{$R *.RES}

Begin
  Application.Initialize;
  Application.Run;
End.
