{
  config,
  pkgs,
  ...
}: {
  imports = [
    ../common
    ./hardware-configuration.nix
  ];

  networking.hostName = "Nixilla"; 
  
   hardware.opengl = {
    enable = true;
    driSupport = true;
    driSupport32Bit = true;
  };

  # Load VMware kernel modules
  boot.kernelModules = [ "vmwgfx" ];

  # Enable VMware guest services & video drivers
  virtualisation.vmware.guest.enable = true;
  services.xserver.videoDrivers = [ "vmware" ];

}
