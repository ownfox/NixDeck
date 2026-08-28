# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Hyprland — тайлинговый Wayland-композитор              ║
# ║  Оптимизирован для Steam Deck OLED (батарея, OLED, сенсор)      ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, inputs, ... }:

{
  # ── Включение Hyprland ─────────────────────────────────────────
  programs.hyprland = {
    enable = true;
    package = inputs.hyprland.packages.${pkgs.system}.hyprland;
    xwayland.enable = true; # для X11-приложений
  };

  # ── Виртуальная клавиатура (wvkbd) ────────────────────────────
  # Минималистичная клавиатура для тайлинговых Wayland-композиторов
  # Не перехватывает фокус, автоматически сдвигает окна
  environment.systemPackages = with pkgs; [
    wvkbd                          # виртуальная клавиатура
    rofi                           # лаунчер (D-Pad friendly)
    waybar                         # статус-бар
    mako                           # уведомления (Wayland)
    wl-clipboard                   # буфер обмена
    grim                           # скриншоты
    slurp                          # выбор области экрана
    brightnessctl                  # управление яркостью
    playerctl                      # управление медиа
    inputs.hyprgrass.packages.${pkgs.system}.default  # жесты сенсорного экрана
  ];

  # ── XDG Portal (для корректных диалогов и screen share) ────────
  xdg.portal = {
    enable = true;
    extraPortals = [ pkgs.xdg-desktop-portal-hyprland ];
  };

  # ── Переменные окружения для Wayland ───────────────────────────
  environment.sessionVariables = {
    WLR_NO_HARDWARE_CURSORS = "1";     # Steam Deck не имеет аппаратного курсора
    NIXOS_OZONE_WL = "1";             # Electron-приложения через Wayland
    MOZ_ENABLE_WAYLAND = "1";          # Firefox через Wayland
    QT_QPA_PLATFORM = "wayland";       # Qt через Wayland
    SDL_VIDEODRIVER = "wayland";        # SDL через Wayland
    XDG_SESSION_TYPE = "wayland";
  };
}
