self: super: {
  vmware-workstation = super.vmware-workstation.overrideAttrs (old: {
    src = super.fetchurl {
      url = "file:///home/dawn/flakes/nixos/overlays/VMware-Workstation-Full-17.6.4-24832109.x86_64.bundle";
      sha256 = "1gd935zvm5l3jfyw6yz8r4613sddp8mjldhlh536b264mjpgpyv4";
    };
  });
}

