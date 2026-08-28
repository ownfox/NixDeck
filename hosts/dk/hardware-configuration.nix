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

  # ВНИМАНИЕ: Файловые системы управляются через файл disko.nix!
  # Определение файловых систем удалено отсюда во избежание конфликтов сборки.

  # ── CPU / GPU ──────────────────────────────────────────────────
  hardware.cpu.amd.updateMicrocode = lib.mkDefault config.hardware.enableRedistributableFirmware;
}
