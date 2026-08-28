# ╔══════════════════════════════════════════════════════════════════╗
# ║  Модуль: Networking — Wi-Fi, Bluetooth, Firewall                ║
# ╚══════════════════════════════════════════════════════════════════╝
{ config, pkgs, ... }:

{
  # ── Hostname ───────────────────────────────────────────────────
  networking.hostName = "dk";

  # ── NetworkManager (Wi-Fi) ─────────────────────────────────────
  networking.networkmanager.enable = true;

  # ── Firewall ───────────────────────────────────────────────────
  networking.firewall = {
    enable = true;
    allowedTCPPorts = [
      # Steam Remote Play
      27036
      27037
    ];
    allowedUDPPorts = [
      # Steam Remote Play
      27031
      27036
    ];
  };

  # ── SSH (опционально, для удалённого управления) ───────────────
  services.openssh = {
    enable = true;
    settings = {
      PasswordAuthentication = false;   # только ключи
      PermitRootLogin = "no";
    };
  };
}
