{ pkgs, lib, config, ... }:
{
  options = {
    lookingGlass.enable =
      lib.mkEnableOption "Enables configuration for Lookling Glass";
  };

  config = lib.mkIf config.lookingGlass.enable {
    boot.extraModulePackages = [ pkgs.linuxKernel.packages.linux_6_12.kvmfr ];
    boot.kernelModules = [ "kvmfr" ];
    boot.extraModprobeConfig = ''
      options kvmfr static_size_mb=64
    '';
    users.users.qemu-libvirtd.extraGroups = [ "kvm" ];

    virtualisation.libvirtd = {
      qemu.verbatimConfig = ''
        cgroup_device_acl = [
            "/dev/null", "/dev/full", "/dev/zero",
            "/dev/random", "/dev/urandom",
            "/dev/ptmx", "/dev/kvm",
            "/dev/kvmfr0"
        ]
      '';
    };
  };
}
