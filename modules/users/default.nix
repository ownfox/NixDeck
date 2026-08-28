# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Users — пользователи и Home Manager                    ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, inputs, ... }:

{
  # ── Основной пользователь ──────────────────────────────────────
  users.users.jb = {
    isNormalUser = true;
    description = "Steam Deck User";
    extraGroups = [
      "wheel"          # sudo
      "networkmanager" # управление сетью
      "video"          # яркость и GPU
      "audio"          # звук
      "input"          # устройства ввода
      "gamemode"       # Feral GameMode
    ];
    shell = pkgs.fish;
  };

  # ── Fish shell ─────────────────────────────────────────────────
  programs.fish.enable = true;

  # ── Home Manager (декларативные dotfiles) ──────────────────────
  home-manager = {
    useGlobalPkgs = true;
    useUserPackages = true;

    users.jb = { pkgs, ... }: {
      home.stateVersion = "24.05";

      # ── Hyprland конфиг через Home Manager ─────────────────────
      # Путь: ~/.config/hypr/hyprland.conf
      # Раскомментируйте для управления через HM:
      # xdg.configFile."hypr/hyprland.conf".source = ../../desktop/hyprland/hyprland.conf;

      # ── Ассоциации файлов (MIME) ───────────────────────────────
      xdg.mimeApps = {
        enable = true;
        defaultApplications = {
          "application/vnd.appimage" = [ "it.mijorus.gearlever.desktop" ];
          "application/x-executable" = [ "it.mijorus.gearlever.desktop" ];
        };
      };

      # ── Git ────────────────────────────────────────────────────
      programs.git = {
        enable = true;
        userName = "Your Name";        # ← замените
        userEmail = "you@example.com"; # ← замените
      };

      # ── Starship prompt ────────────────────────────────────────
      programs.starship = {
        enable = true;
        settings = {
          add_newline = false;
          character = {
            success_symbol = "[➜](bold green)";
            error_symbol = "[✗](bold red)";
          };
        };
      };

      # ── Foot (терминал) ────────────────────────────────────────
      programs.foot = {
        enable = true;
        settings = {
          main = {
            font = "JetBrains Mono:size=11";
            dpi-aware = "yes";
          };
          colors = {
            # Строго чёрный фон для OLED
            background = "000000";
            foreground = "e0e0e0";
          };
        };
      };
    };
  };
}
