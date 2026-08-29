{ config, pkgs, ... }:

{
  # ── Настройка звука (PipeWire) ──────────────────────────────────
  security.rtkit.enable = true; # Для приоритета аудио в реальном времени
  services.pipewire = {
    enable = true;
    alsa.enable = true;
    alsa.support32Bit = true;
    pulse.enable = true;
    # На Steam Deck лучше включить поддержку Jack для низкой задержки
    jack.enable = true;
  };
}
