# ╔══════════════════════════════════════════════════════════════════╗
# ║  hardware-configuration.nix                                     ║
# ║  Генерируется автоматически: sudo nixos-generate-config         ║
# ║  Это заглушка — при установке замените содержимым от генератора ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, lib, pkgs, modulesPath, ... }:

{
  imports = [
    (modulesPath + "/installer/scan/not-detected.nix")
  ];

  # ── Загрузка модулей ядра ──────────────────────────────────────
  boot.initrd.availableKernelModules = [
    "nvme"
    "xhci_pci"
    "usb_storage"
    "sd_mod"
    "sdhci_pci"
  ];
  boot.initrd.kernelModules = [ ];
  boot.kernelModules = [ "kvm-amd" ];
  boot.extraModulePackages = [ ];

  # ── Файловые системы ───────────────────────────────────────────
  # ВНИМАНИЕ: замените UUID-ы на свои после разметки диска!
  fileSystems."/" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "btrfs";
    options = [ "subvol=@" "compress=zstd" "noatime" ];
  };

  fileSystems."/boot" = {
    device = "/dev/disk/by-uuid/XXXX-XXXX";
    fsType = "vfat";
  };

  fileSystems."/home" = {
    device = "/dev/disk/by-uuid/XXXXXXXX-XXXX-XXXX-XXXX-XXXXXXXXXXXX";
    fsType = "btrfs";
    options = [ "subvol=@home" "compress=zstd" "noatime" ];
  };

  swapDevices = [ ];

  # ── CPU / GPU ──────────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
