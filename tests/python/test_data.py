"""Runs the REDLINE data checker as a test: python3 -m pytest tests/python"""
import subprocess
import sys
from pathlib import Path

ROOT = Path(__file__).resolve().parents[2]


def test_game_data_is_valid():
    result = subprocess.run([sys.executable, str(ROOT / "tools" / "validate_data.py")], capture_output=True, text=True)
    assert result.returncode == 0, result.stdout + result.stderr
