{
  description = "Steam Deck OLED — Standard NixOS + Hyprland";

  inputs = {
    # Используем стабильную/unstable ветку NixOS с официальным кэшем
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";

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

  outputs = { self, nixpkgs, home-manager, disko, ... }@inputs: {

    nixosConfigurations.dk = nixpkgs.lib.nixosSystem {
      system = "x86_64-linux";
      specialArgs = { inherit inputs; };

      modules = [
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
        ./modules/audio
        ./modules/gaming
        ./modules/desktop/hyprland
        ./modules/desktop/steam-input
        ./modules/networking
        ./modules/packages
        ./modules/users
      ];
    };
  };
}
