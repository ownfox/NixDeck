# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Gaming — Steam, Gamescope, GameMode                    ║
# ║  МИНИМАЛЬНАЯ СБОРКА — только необходимое для запуска игр        ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── Стандартный Steam с игровым режимом ───────────────────────
  programs.steam = {
    enable = true;
    gamescopeSession.enable = true; # Включает игровой режим Steam UI
  };

  # ── Автозапуск и графический вход (Display Manager) ────────────
  services.displayManager = {
    sddm = {
      enable = true;
      wayland.enable = true; # Используем Wayland для SDDM
    };
    autoLogin = {
      enable = true;
      user = "jb";
    };
    defaultSession = "steam-wayland"; # Запускать Steam UI по умолчанию
  };

  # ── Игровые пакеты (дополнительные) ────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud           # FPS, frametime, температура
    winetricks
  ];
}
