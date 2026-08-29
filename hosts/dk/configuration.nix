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
  # Разрешить переименованные пакеты (например noto-fonts-emoji → noto-fonts-color-emoji)
  # Нужно из-за зависимостей Jovian-NixOS, которые используют старые имена
  nixpkgs.config.allowAliases = true;

  # ── Загрузчик ──────────────────────────────────────────────────
  boot.loader.systemd-boot.enable = true;
  boot.loader.efi.canTouchEfiVariables = true;

  # ── Часовой пояс и локаль ──────────────────────────────────────
  time.timeZone = "Europe/Berlin"; # ← замените на свой
  i18n.defaultLocale = "en_US.UTF-8";

  # ── Кэширование (чтобы не компилировать ядро и mesa) ───────────
  nix.settings = {
    substituters = [
      "https://cache.nixos.org"
      "https://nyx-cache.chaotic.cx"
      "https://jovian.cachix.org"
    ];
    trusted-public-keys = [
      "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY="
      "nyx-cache.chaotic.cx:dJxTrgMC3V3cFfyIiBQDQorG6k1LsqurH/srpMSq7qk="
      "jovian.cachix.org-1:8Vq4Txku6VZIRhYrHYki3Ab9XHJRoWmdYqMqj4rB/Uc="
    ];
  };

  # ── Версия NixOS state ─────────────────────────────────────────
  system.stateVersion = "24.05";
}
