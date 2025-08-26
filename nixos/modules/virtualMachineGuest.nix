{ pkgs, lib, config, ... }:
{
  options = {
    virtualMachineGuest.enable =
      lib.mkEnableOption "Enables Guest Tools for NixOS Guest on QEMU/KVM";
  };

  config = lib.mkIf config.virtualMachineGuest.enable {
    # QEMU/KVM Guest Tools
    services.qemuGuest.enable = true;
    services.spice-vdagentd.enable = true;
  };
}
