# ╔══════════════════════════════════════════════════════════════════╗
# ║  Disko — Декларативная разметка NVMe для Steam Deck             ║
# ║  Btrfs с subvolumes для гибкости и снапшотов                    ║
# ╚══════════════════════════════════════════════════════════════════╝
{ ... }:

{
  disko.devices = {
    disk = {
      nvme = {
        type = "disk";
        device = "/dev/nvme0n1"; # внутренний NVMe Steam Deck
        content = {
          type = "gpt";
          partitions = {
            # ── EFI System Partition ─────────────────────────────
            ESP = {
              size = "512M";
              type = "EF00";
              content = {
                type = "filesystem";
                format = "vfat";
                mountpoint = "/boot";
              };
            };

            # ── Root partition (Btrfs) ───────────────────────────
            root = {
              size = "100%";
              content = {
                type = "btrfs";
                extraArgs = [ "-f" ]; # force overwrite
                subvolumes = {
                  "@" = {
                    mountpoint = "/";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@home" = {
                    mountpoint = "/home";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@nix" = {
                    mountpoint = "/nix";
                    mountOptions = [ "compress=zstd" "noatime" ];
                  };
                  "@swap" = {
                    mountpoint = "/swap";
                    swap.swapfile.size = "8G";
                  };
                };
              };
            };
          };
        };
      };
    };
  };
}
