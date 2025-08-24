{ pkgs, lib, config, ... }:
{
  options = {
    optionalServices.enable =
      lib.mkEnableOption "Enables virtualisation and adb";
  };

  config = lib.mkIf config.optionalServices.enable {
    # Partition Manager
    programs.partition-manager.enable = true;

    # QEMU/KVM
    programs.virt-manager.enable = true;

    users.groups.libvirtd.members = ["dawn"];

    virtualisation.libvirtd.enable = true;

    virtualisation.spiceUSBRedirection.enable = true;

    # Android
    programs.adb.enable = true;
  };
}
