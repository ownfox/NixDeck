{
  description = "Steam Deck OLED — Jovian-NixOS + Hyprland + Hyprgrass";

  inputs = {
    # ── Основные репозитории ──────────────────────────────────────
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

    # Jovian-NixOS — ядро Valve, драйверы, Gamescope, Steam UI
    jovian = {
      url = "github:Jovian-Experiments/Jovian-NixOS";
      inputs.nixpkgs.follows = "nixpkgs"; # критически важно для совместимости
    };

    # Hyprland — тайлинговый Wayland-композитор
    hyprland.url = "github:hyprwm/Hyprland";

    # Hyprgrass — плагин сенсорных жестов (свайпы, щипки, long press)
    hyprgrass = {
      url = "github:horriblename/hyprgrass";
      inputs.hyprland.follows = "hyprland";
    };

    # Chaotic-Nyx — сторонний бинарный кэш (готовое ядро Valve и т.д.)
    chaotic.url = "github:chaotic-cx/nyx";

    # Home Manager — декларативное управление dotfiles
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };

    # Disko — декларативная разметка дисков
    disko = {
      url = "github:nix-community/disko";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, jovian, hyprland, hyprgrass, chaotic, home-manager, disko, ... }@inputs: {

    nixosConfigurations.dk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
        # Бинарный кэш Chaotic-Nyx (скачиваем ядро вместо компиляции)
        chaotic.nixosModules.default

        # Jovian-NixOS — аппаратная поддержка Steam Deck
        jovian.nixosModules.default

        # Disko — разметка NVMe
        disko.nixosModules.disko

        # Home Manager как NixOS-модуль
        home-manager.nixosModules.home-manager

        # Наши конфигурационные файлы
        ./hosts/dk/hardware-configuration.nix
        ./hosts/dk/configuration.nix
        ./hosts/dk/disko.nix

        # Модули по компонентам
        ./modules/hardware
        ./modules/gaming
        ./modules/desktop/hyprland
        ./modules/desktop/steam-input
        ./modules/networking
        ./modules/audio
        ./modules/power
        ./modules/packages
        ./modules/users
      ];
    };
  };
}
