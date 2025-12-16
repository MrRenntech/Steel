from src.ui.app import SteelApp
import sys
import os

def main():
    # Ensure src is in path if running from here (redundant usually but safe)
    sys.path.append(os.path.dirname(os.path.abspath(__file__)))
    
    app = SteelApp()
    app.mainloop()

if __name__ == "__main__":
    main()
