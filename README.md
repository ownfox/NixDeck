# 🎮 NixOS on Steam Deck OLED

> Декларативная конфигурация NixOS для Steam Deck OLED на базе **Jovian-NixOS** с **Hyprland** + **Hyprgrass** + **Chaotic-Nyx**.

Конфигурация воспроизводит опыт Bazzite/SteamOS (игровой режим, Gamescope, Steam UI),
но с полным контролем через Nix Flakes и энергоэффективной средой рабочего стола Hyprland.

## 📐 Архитектура

```
Игровой режим (Gamescope + Steam UI)
        ↕ кнопка "Перейти на рабочий стол"
Режим рабочего стола (Hyprland + wvkbd + Steam Input)
        ↕
Jovian-NixOS (ядро Valve, драйверы, контроллеры)
        ↕
NixOS (Nix Flakes, декларативная конфигурация)
        ↕
Chaotic-Nyx (бинарный кэш — готовое ядро Valve)
```

## 📁 Структура проекта

```
Steam_nix/
├── flake.nix                          # 🏗️  Главный entry point — все inputs и outputs
├── flake.lock                         # 🔒 Зафиксированные версии (генерируется авто)
├── README.md                          # 📖 Документация
│
├── hosts/
│   └── deck/
│       ├── configuration.nix          # ⚙️  Основная конфигурация хоста
│       ├── hardware-configuration.nix # 🔧 Аппаратная конфигурация (nixos-generate-config)
│       └── disko.nix                  # 💾 Декларативная разметка NVMe (Btrfs)
│
├── modules/
│   ├── hardware/
│   │   └── default.nix                # 🖥️  GPU, Vulkan, Bluetooth, сенсоры
│   ├── gaming/
│   │   └── default.nix                # 🎮 Steam, GameMode, ProtonUp, MangoHud
│   ├── desktop/
│   │   ├── hyprland/
│   │   │   ├── default.nix            # 🪟 Hyprland NixOS-модуль
│   │   │   └── hyprland.conf          # 📝 Конфиг Hyprland (OLED-оптимизирован)
│   │   └── steam-input/
│   │       └── default.nix            # 🕹️  Steam Input + радиальные меню
│   ├── networking/
│   │   └── default.nix                # 🌐 Wi-Fi, Bluetooth, Firewall, SSH
│   ├── audio/
│   │   └── default.nix                # 🔊 PipeWire (низкая задержка)
│   ├── power/
│   │   └── default.nix                # 🔋 TDP, энергосбережение, ryzenadj
│   ├── packages/
│   │   └── default.nix                # 📦 Системные пакеты, шрифты, Nix GC
│   └── users/
│       └── default.nix                # 👤 Пользователи, Home Manager, dotfiles
│
├── configs/
│   └── waybar/
│       ├── config.jsonc               # 📊 Waybar конфигурация
│       └── style.css                  # 🎨 OLED-оптимизированная тема
│
└── scripts/
    ├── install.sh                     # 🚀 Скрипт первоначальной установки
    └── rebuild.sh                     # 🔄 Обновление / откат системы
```

## 🔗 Ключевые зависимости

| Репозиторий | Назначение |
|---|---|
| [Jovian-NixOS](https://github.com/Jovian-Experiments/Jovian-NixOS) | Ядро Valve, драйверы, Gamescope, Steam UI |
| [Hyprland](https://github.com/hyprwm/Hyprland) | Тайлинговый Wayland-композитор |
| [Hyprgrass](https://github.com/horriblename/hyprgrass) | Плагин жестов сенсорного экрана |
| [Chaotic-Nyx](https://github.com/chaotic-cx/nyx) | Бинарный кэш (готовое ядро, mesa_git) |
| [SteamNix](https://github.com/SteamNix/SteamNix) | Готовый шаблон "SteamOS на NixOS" |

## 🚀 Быстрый старт

### 1. Подготовка USB
Скачайте NixOS Minimal ISO → запишите на USB → загрузитесь (Volume Down + Power).

### 2. Установка
```bash
# Подключитесь к Wi-Fi
iwctl station wlan0 connect <SSID>

# Клонируйте конфигурацию
git clone <this-repo> /tmp/nixos-deck
cd /tmp/nixos-deck

# Запустите установку
sudo bash scripts/install.sh
```

### 3. Повседневное использование
```bash
# Применить изменения
./scripts/rebuild.sh switch

# Обновить все зависимости
./scripts/rebuild.sh update

# Откатиться к предыдущей конфигурации
./scripts/rebuild.sh rollback

# Очистить старые поколения
./scripts/rebuild.sh gc
```

## 🎯 Ключевые решения из исследования

### OLED-оптимизации
- **Чёрный фон** (`#000000`) — выключенные пиксели = 0 энергопотребления
- **VFR** (Variable Frame Rate) — не рендерить кадры когда ничего не меняется
- **Blur отключен** — экономия GPU и батареи
- **Контрастная тема** — чёрный/белый для максимальной эффективности OLED

### Управление без клавиатуры
- **Steam Input** — радиальные меню на трекпадах (до 16 кнопок каждый)
- **Hyprgrass** — свайпы и щипки на сенсорном экране
- **wvkbd** — виртуальная клавиатура для тайлинговых WM
- **rofi** — лаунчер приложений через D-Pad

### Энергосбережение
- **ryzenadj** — автоматическое ограничение TDP до 8W в desktop-режиме
- **Jovian udev-правила** — управление TDP/GPU/яркостью на уровне пользователя
- **SimpleDeckyTDP** — плагин Decky для управления TDP из игрового режима

## ⚠️ Важные замечания

1. **Первая сборка** может занять часы без Chaotic-Nyx (компиляция ядра Valve)
2. **UUID-ы** в `hardware-configuration.nix` — заглушки, замените после `nixos-generate-config`
3. **Пользователь** — замените `deck` на своё имя в `configuration.nix` и `users/default.nix`
4. **Часовой пояс** — замените `Europe/Berlin` в `configuration.nix`
5. **Git** — замените имя и email в `users/default.nix`

## 📚 Источники и вдохновение

- [Chris Titus — Steamdeck as a Desktop](https://youtu.be/ttOs5iWgNzk) — гибридный подход SteamOS + Nix
- [Jovian-NixOS](https://github.com/Jovian-Experiments/Jovian-NixOS) — официальный фундамент
- [SteamNix](https://github.com/SteamNix/SteamNix) — готовый шаблон
- [nomadics9/NixOS-Flake](https://github.com/nomadics9/NixOS-Flake) — Hyprland + Waybar на портативной консоли
- [heywoodlh/nixos-configs](https://github.com/heywoodlh/nixos-configs) — GNOME на Jovian-NixOS
- [Stream5710/deck-flake](https://github.com/Stream5710/deck-flake) — минималистичный гибрид SteamOS + Nix
