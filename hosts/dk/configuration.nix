# ╔══════════════════════════════════════════════════════════════════╗
# ║  Steam Deck OLED — Основная конфигурация системы               ║
# ║  Standard NixOS + Hyprland                                     ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, inputs, ... }:

{
  imports = [ ];

  # ── Разрешение несвободного ПО ─────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── Загрузчик ──────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Часовой пояс и локаль ──────────────────────────────────────
  time.timeZone = "Europe/Berlin"; # ← замените на свой
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Кэширование (только официальный кэш NixOS) ─────────────────
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
    ];
  };

  # ── Версия NixOS state ─────────────────────────────────────────
  system.stateVersion = "24.05";
}
