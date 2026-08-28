# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Packages — системные пакеты и утилиты                  ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  environment.systemPackages = with pkgs; [
    # ── Терминал и оболочка ──────────────────────────────────────
    foot              # Wayland-нативный терминал (лёгкий, быстрый)
    fish              # удобная оболочка
    starship          # кроссплатформенный промпт
    tmux              # мультиплексор

    # ── Файловый менеджер ────────────────────────────────────────
    yazi              # терминальный файл-менеджер
    nnn               # минималистичный альтернативный

    # ── Редакторы ────────────────────────────────────────────────
    neovim            # основной редактор
    helix             # модальный редактор (альтернатива)

    # ── Системные утилиты ────────────────────────────────────────
    btop              # мониторинг системы
    fastfetch         # информация о системе
    wget
    curl
    git
    unzip
    p7zip

    # ── Браузеры ─────────────────────────────────────────────────
    firefox           # Wayland-нативный
    google-chrome     # Google Chrome

    # ── Инструменты для разработки ───────────────────────────────
    gcc
    python3
    nodejs
    # ── Контейнеры и эмуляция ────────────────────────────────────
    distrobox         # Запуск любых дистрибутивов Linux в терминале
    hhd               # Handheld Daemon (поддержка контроллеров/гироскопа)
    # ── Утилиты в стиле Bazzite (GUI и Инструменты) ──────────────
    kdePackages.dolphin       # Файловый менеджер (как в SteamOS)
    kdePackages.ark           # Архиватор
    kdePackages.polkit-kde-agent-1 # Окно ввода пароля (polkit)
    networkmanagerapplet      # Иконка Wi-Fi в трее (nm-applet)
    blueman                   # Иконка Bluetooth в трее
    pavucontrol               # Удобное управление звуком (микшер)
    mangohud                  # Оверлей производительности (FPS)
    goverlay                  # Настройка MangoHud
    protonup-qt               # Управление версиями GE-Proton
    flatseal                  # Настройка прав Flatpak-приложений
    mission-center            # Красивый системный монитор
    qbittorrent               # Торрент-клиент
    portproton                # Простой запуск Windows-игр (альтернатива Lutris)
    # ── Остальные Bazzite-пакеты (Гейминг, Медиа, Офис) ──────────
    heroic                    # Heroic Games Launcher (Epic, GOG, Amazon)
    lutris                    # Менеджер игр Linux/Windows
    bottles                   # Изолированные префиксы Wine (как в Bazzite)
    vesktop                   # Клиент Discord с поддержкой демонстрации экрана на Wayland
    vlc                       # Универсальный видеоплеер
    kdePackages.gwenview      # Просмотрщик изображений
    kdePackages.kate          # Графический текстовый редактор
    kdePackages.kcalc         # Калькулятор
    webapp-manager            # Менеджер веб-приложений (как в Bazzite/Mint)
    gearlever                 # Менеджер AppImage файлов (добавляет ярлыки в меню)
    steam-rom-manager         # Менеджер ROM-ов для добавления эмуляторов и игр в Steam
    telegram-desktop          # Мессенджер Telegram
  ];

  # ── Настройка Podman (нужно для Distrobox) ─────────────────────
  virtualisation.podman = {
    enable = true;
    dockerCompat = true;
  };

  # ── Настройка Waydroid (Запуск Android-приложений как в Bazzite)
  virtualisation.waydroid.enable = true;

  # ── Настройка KDE Connect (Связь со смартфоном) ────────────────
  programs.kdeconnect.enable = true;

  # ── Настройка Input Remapper (Глобальное переназначение клавиш) ─
  services.input-remapper.enable = true;

  # ── Настройка HHD ──────────────────────────────────────────────
  # services.hhd.enable = true; # Раскомментируйте, если хотите включить сервис HHD (может конфликтовать со Steam Input)

  # ── Шрифты ─────────────────────────────────────────────────────
  fonts.packages = with pkgs; [
    noto-fonts
    noto-fonts-cjk-sans
    noto-fonts-emoji
    fira-code
    fira-code-nerdfont
    jetbrains-mono
  ];

  # ── Настройки Nix ──────────────────────────────────────────────
  nix.settings = {
    experimental-features = [ "nix-command" "flakes" ];
    auto-optimise-store = true;   # дедупликация в /nix/store
  };

  # ── Сборка мусора ──────────────────────────────────────────────
  nix.gc = {
    automatic = true;
    dates = "weekly";
    options = "--delete-older-than 7d";
  };
}
