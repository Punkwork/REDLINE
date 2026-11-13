#!/usr/bin/env bash
# Runs the headless Godot rules tests and the UI smoke test.
# Usage: GODOT=/path/to/godot tools/run_godot_tests.sh
set -euo pipefail
GODOT="${GODOT:-godot}"
cd "$(dirname "$0")/.."
"$GODOT" --headless --path godot --script res://tests/run_tests.gd
"$GODOT" --headless --path godot --script res://tests/smoke_ui.gd
