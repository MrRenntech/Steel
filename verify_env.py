import sys
from PySide6.QtWidgets import QApplication

if __name__ == "__main__":
    print("Verifying environment...")
    try:
        import PySide6
        print(f"PySide6: {PySide6.__version__}")
        import psutil
        print(f"psutil: {psutil.__version__}")
        print("OK.")
    except ImportError as e:
        print(f"MISSING: {e}")
