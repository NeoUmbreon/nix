{ pkgs, lib, config, ... }:
{
  options = {
    vfio.enable =
      lib.mkEnableOption "Enables VFIO PCI Passthrough";
  };

  config = lib.mkIf config.vfio.enable {
    
    boot.initrd.kernelModules = [ 
      "vfio_pci"
      "vfio"
      "vfio_iommu_type1"
    ];
    boot.kernelParams = [ 
      "amd_iommu=on"
      "vfio-pci.ids=1022:1482,1022:1483,10de:1f08,10de:10f9,10de:1ada,10de:1adb"
    ];
  };
}

