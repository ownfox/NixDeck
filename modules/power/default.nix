# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Power — управление энергопотреблением и TDP            ║
# ║  Оптимизировано для Steam Deck OLED + батарея                   ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── TDP / GPU управление через ryzenadj ────────────────────────
  # Jovian-NixOS уже включает udev-правила через:
  #   jovian.devices.steamdeck.enablePerfControlUdevRules = true
  # Это открывает доступ к SMU процессора AMD на уровне пользователя

  environment.systemPackages = with pkgs; [
    ryzenadj          # управление TDP на AMD APU
    powertop          # анализ энергопотребления
    lm_sensors        # температуры и напряжения
  ];

  # ── Автоматическое ограничение TDP при работе от батареи ───────
  # Пример: залочить TDP на 7-10 Ватт при запуске ShojiWM/Hyprland
  systemd.services.tdp-limit = {
    description = "Ограничение TDP для энергосбережения в desktop-режиме";
    wantedBy = [ "multi-user.target" ];
    after = [ "multi-user.target" ];

    serviceConfig = {
      Type = "oneshot";
      RemainAfterExit = true;
      # Ограничиваем TDP до 8W в desktop-режиме (экономия батареи)
      # Закомментируйте если не нужно автоматическое ограничение
      ExecStart = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=8000 --fast-limit=8000 --slow-limit=8000";
      # При остановке сервиса возвращаем стандартный TDP (15W)
      ExecStop = "${pkgs.ryzenadj}/bin/ryzenadj --stapm-limit=15000 --fast-limit=15000 --slow-limit=15000";
    };
  };

  # ── Управление подсветкой OLED ─────────────────────────────────
  # На OLED-экране чёрные пиксели = 0 энергопотребления
  # Яркость регулируется через brightnessctl (в модуле desktop)

  # Suspend / Sleep теперь управляется через Jovian-NixOS (Steam UI)
}
