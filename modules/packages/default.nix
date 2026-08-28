# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Packages — МИНИМАЛЬНАЯ СБОРКА                          ║
# ║  Только базовые утилиты. Остальное добавим после успешной       ║
# ║  загрузки системы.                                              ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Терминал и оболочка ──────────────────────────────────────
    foot              # Wayland-нативный терминал
    fish              # удобная оболочка
    starship          # промпт

    # ── Файловый менеджер ────────────────────────────────────────
    kdePackages.dolphin       # GUI файл-менеджер (как в SteamOS)

    # ── Системные утилиты ────────────────────────────────────────
    btop              # мониторинг системы
    fastfetch         # информация о системе
    wget
    curl
    git
    unzip

    # ── Браузер ──────────────────────────────────────────────────
    firefox           # Wayland-нативный

    # ── Рабочий стол (необходимый минимум) ───────────────────────
    kdePackages.polkit-kde-agent-1 # Окно ввода пароля (polkit)
    networkmanagerapplet      # Иконка Wi-Fi в трее
    blueman                   # Иконка Bluetooth в трее
    pavucontrol               # Управление звуком
  ];

  # ── Flatpak (для установки остальных программ после загрузки) ───
  services.flatpak.enable = true;

  # ── Шрифты (только проверенные) ────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-color-emoji
    fira-code
    jetbrains-mono
  ];

  # ── Настройки Nix ──────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;
  };

  # ── Сборка мусора ──────────────────────────────────────────────
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
