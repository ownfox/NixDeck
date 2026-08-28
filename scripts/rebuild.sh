#!/usr/bin/env bash
# ╔══════════════════════════════════════════════════════════════════╗
# ║  Обновление системы — NixOS Rebuild                              ║
# ║  Запускать после изменений в конфигурации                        ║
# ╚══════════════════════════════════════════════════════════════════╝

set -euo pipefail

ACTION="${1:-switch}"

case "$ACTION" in
    switch)
        echo "🔄 Применение конфигурации и переключение..."
        sudo nixos-rebuild switch --flake .#deck
        ;;
    boot)
        echo "🔄 Применение конфигурации (после перезагрузки)..."
        sudo nixos-rebuild boot --flake .#deck
        ;;
    test)
        echo "🧪 Тестирование конфигурации (без постоянного применения)..."
        sudo nixos-rebuild test --flake .#deck
        ;;
    build)
        echo "🔨 Только сборка (без применения)..."
        nixos-rebuild build --flake .#deck
        ;;
    update)
        echo "📦 Обновление всех inputs (nixpkgs, jovian, hyprland...)..."
        nix flake update
        echo "🔄 Применение обновлений..."
        sudo nixos-rebuild switch --flake .#deck
        ;;
    rollback)
        echo "⏪ Откат к предыдущему поколению..."
        sudo nixos-rebuild switch --rollback
        ;;
    gc)
        echo "🧹 Сборка мусора..."
        sudo nix-collect-garbage -d
        sudo nix-store --optimise
        echo "✅ Очистка завершена"
        ;;
    *)
        echo "Использование: ./rebuild.sh [switch|boot|test|build|update|rollback|gc]"
        echo ""
        echo "  switch   — применить и переключиться (по умолчанию)"
        echo "  boot     — применить при следующей загрузке"
        echo "  test     — временно применить (до перезагрузки)"
        echo "  build    — только собрать, не применять"
        echo "  update   — обновить все зависимости и применить"
        echo "  rollback — откатиться к предыдущей конфигурации"
        echo "  gc       — очистить старые поколения и оптимизировать store"
        exit 1
        ;;
esac
