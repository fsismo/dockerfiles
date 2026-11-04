#!/bin/bash
set -e
set -o pipefail

SCRIPT_DIR="$(cd "$(dirname "$0")" && pwd)"
PRUNE_SCRIPT="$SCRIPT_DIR/image-prune.sh"
LOG_FILE="$SCRIPT_DIR/last-run.log"

timestamp() {
    date +"%Y-%m-%d %H:%M:%S %z"
}

run_script() {
    echo "==> [$(timestamp)] Running: $(basename "$1")"
    bash "$1"
}

run_all() {
    trap 'rc=$?; echo "==> [$(timestamp)] Fin de la corrida: $([ "$rc" -eq 0 ] && echo OK || echo "ERROR (exit $rc)")"' EXIT
    echo "==> [$(timestamp)] Inicio de la corrida"

    for script in $(ls "$SCRIPT_DIR"/*.sh | sort); do
        case "$(basename "$script")" in
            "$(basename "$0")"|"$(basename "$PRUNE_SCRIPT")")
                continue
                ;;
        esac
        run_script "$script"
    done

    run_script "$PRUNE_SCRIPT"
}

# Va a pantalla y a last-run.log, que se pisa en cada corrida.
run_all 2>&1 | tee "$LOG_FILE"
