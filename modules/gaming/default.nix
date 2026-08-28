# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Gaming — Steam, Gamescope, GameMode                    ║
# ║  МИНИМАЛЬНАЯ СБОРКА — только необходимое для запуска игр        ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── Steam ──────────────────────────────────────────────────────
  programs.steam = {
    enable = true;
    remotePlay.openFirewall = true;
    dedicatedServer.openFirewall = true;
    gamescopeSession.enable = true;
  };

  # ── GameMode (Feral) — оптимизация CPU при запуске игр ─────────
  programs.gamemode = {
    enable = true;
    settings = {
      general = {
        renice = 10;
        softrealtime = "auto";
      };
      gpu = {
        apply_gpu_optimisations = "accept-responsibility";
        gpu_device = 0;
      };
    };
  };

  # ── Игровые пакеты (минимум) ────────────────────────────────────
  environment.systemPackages = with pkgs; [
    mangohud           # FPS, frametime, температура, TDP
    gamescope          # микрокомпозитор для игр
    winetricks
  ];
}
