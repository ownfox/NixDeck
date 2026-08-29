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

  # ── Игровые пакеты (дополнительные) ────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud           # FPS, frametime, температура
    winetricks
  ];
}
