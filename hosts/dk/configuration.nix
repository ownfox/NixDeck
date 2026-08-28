# ╔══════════════════════════════════════════════════════════════════╗
# ║  Steam Deck OLED — Основная конфигурация системы               ║
# ║  Jovian-NixOS + Hyprland + Hyprgrass                           ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, inputs, ... }:

{
  imports = [ ];

  # ── Аппаратные оптимизации Steam Deck OLED (Jovian) ────────────
  jovian.devices.steamdeck.enable = true;
  jovian.steamos.useSteamOSConfig = true;

  # ── Игровой режим (Steam UI + Gamescope) ───────────────────────
  jovian.steam = {
    enable = true;
    autoStart = true;
    user = "jb"; # ← замените на своё имя пользователя
    desktopSession = "hyprland"; # переход в Desktop Mode → Hyprland
  };

  # ── Decky Loader (плагины для игрового режима) ─────────────────
  jovian.decky-loader.enable = true;

  # ── Управление TDP / производительностью ───────────────────────
  # udev-правила для управления TDP, GPU, яркостью на уровне пользователя
  jovian.devices.steamdeck.enablePerfControlUdevRules = true;

  # ── Разрешение несвободного ПО ─────────────────────────────────
  nixpkgs.config.allowUnfree = true;

  # ── Загрузчик ──────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Часовой пояс и локаль ──────────────────────────────────────
  time.timeZone = "Europe/Berlin"; # ← замените на свой
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Версия NixOS state ─────────────────────────────────────────
  system.stateVersion = "24.05";
}
