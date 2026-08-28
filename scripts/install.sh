#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  Скрипт первоначальной установки NixOS на Steam Deck OLED       ║
# ║  Запускать из NixOS Minimal ISO (после загрузки с USB)          ║
# ╚══════════════════════════════════════════════════════════════════╝

set -euo pipefail

echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  NixOS Steam Deck OLED — Установка                          ║"
echo "╚══════════════════════════════════════════════════════════════╝"
echo ""

# ── Шаг 0: Проверка окружения ────────────────────────────────────
if [ "$(id -u)" -ne 0 ]; then
    echo "❌ Запустите скрипт от root: sudo bash install.sh"
    exit 1
fi

# ── Шаг 1: Подключение к Wi-Fi ───────────────────────────────────
echo "🌐 Шаг 1: Подключение к Wi-Fi"
echo "  Используйте: iwctl или nmtui"
echo "  Пример: iwctl station wlan0 connect <SSID>"
echo ""
read -p "Wi-Fi настроен? (y/n): " wifi_ready
if [ "$wifi_ready" != "y" ]; then
    echo "Настройте Wi-Fi и запустите скрипт снова."
    exit 1
fi

# ── Шаг 2: Включение flakes ─────────────────────────────────────
echo "⚙️  Шаг 2: Включение Nix Flakes..."
export NIX_CONFIG="experimental-features = nix-command flakes"

# ── Шаг 3: Разметка диска через disko ────────────────────────────
echo "💾 Шаг 3: Разметка диска..."
echo "  ВНИМАНИЕ: Все данные на NVMe будут СТЁРТЫ!"
read -p "Продолжить? (yes для подтверждения): " confirm
if [ "$confirm" != "yes" ]; then
    echo "Отменено."
    exit 1
fi

# Разметка через disko
nix run github:nix-community/disko -- --mode disko ./hosts/dk/disko.nix

# ── Шаг 4: Генерация аппаратной конфигурации ─────────────────────
echo "🔧 Шаг 4: Генерация hardware-configuration.nix..."
nixos-generate-config --root /mnt --no-filesystems
# Скопировать сгенерированный файл
cp /mnt/etc/nixos/hardware-configuration.nix ./hosts/dk/hardware-configuration.nix
echo "  ✅ hardware-configuration.nix обновлён"

# ── Шаг 5: Установка NixOS ──────────────────────────────────────
echo "🚀 Шаг 5: Установка NixOS..."
echo "  ⏳ Первая сборка может занять несколько часов"
echo "     (компиляция ядра Valve, если нет бинарного кэша Chaotic-Nyx)"
echo ""

nixos-install --flake .#dk --no-root-passwd \
  --option substituters "https://cache.nixos.org https://nyx.chaotic.cx" \
  --option trusted-public-keys "cache.nixos.org-1:6NCHdD59X431o0gWypbMrAURkbJ16ZPMQFGspcDShjY= nyx.chaotic.cx-1:HfnXSw4pj95iI/n17rIDy40agHj12WfF+Gqk6SonIT8="

echo ""
echo "╔══════════════════════════════════════════════════════════════╗"
echo "║  ✅ Установка завершена!                                     ║"
echo "║                                                              ║"
echo "║  1. Установите пароль: nixos-enter --root /mnt -c 'passwd jb'  ║"
echo "║  2. Перезагрузитесь: reboot                                  ║"
echo "║  3. Steam Deck загрузится в игровой режим (Gamescope)        ║"
echo "║  4. Кнопка 'Перейти на рабочий стол' → Hyprland             ║"
echo "╚══════════════════════════════════════════════════════════════╝"
