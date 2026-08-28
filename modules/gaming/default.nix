# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Gaming — Steam, Proton, MangoHud, Gamemode             ║
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

  # ── Игровые пакеты ────────────────────────────────────────────
  environment.systemPackages = with pkgs; [
    # Proton / Wine
    protonup-qt       # GUI для управления версиями Proton
    winetricks

    # Оверлеи и мониторинг
    mangohud           # FPS, frametime, температура, TDP
    gamescope          # микрокомпозитор для игр

    # Контроллеры
    steam-rom-manager
  ];
}
