self: super: {
  vmware-workstation = super.vmware-workstation.overrideAttrs (old: {
    src = super.fetchurl {
      url = "file:///etc/nixos/VMware-Workstation-Full-17.6.3-24583834.x86_64.bundle";
      sha256 = "1q4f8wjv23dc28fqvdpf00y7g6myh5mapx491dnlrvcdf8bmjmvr";
    };
  });
}

