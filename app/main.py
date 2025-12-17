import sys
import os
from PySide6.QtGui import QGuiApplication
from PySide6.QtQml import QQmlApplicationEngine
from PySide6.QtQuickControls2 import QQuickStyle
from core.app_state import AppState
from core.system_bridge import SystemBridge

if __name__ == "__main__":
    QQuickStyle.setStyle("Basic")
    app = QGuiApplication(sys.argv)
    
    # Init Logic
    print("[DEBUG] Initializing AppState...")
    try:
        app_state = AppState()
        print(f"[DEBUG] AppState Initialized: {app_state}")
    except Exception as e:
        print(f"[DEBUG] AppState Init Failed: {e}")
        import traceback
        traceback.print_exc()
        sys.exit(1)

    system = SystemBridge()
    
    # Initialize Core Logic (State Machine)
    print("[DEBUG] Initializing SteelCore...")
    from core.steel_core import SteelCore
    core = SteelCore(app_state)
    print("[DEBUG] SteelCore Initialized")

    engine = QQmlApplicationEngine()
    
    # Add UI modules path (Theme, etc.)
    ui_modules_path = os.path.join(os.path.dirname(__file__), "ui")
    engine.addImportPath(ui_modules_path)
    
    # Expose to QML
    print("[DEBUG] Setting Context Property 'app'...")
    engine.rootContext().setContextProperty("app", app_state)
    print("[DEBUG] Context Property Set")
    engine.rootContext().setContextProperty("system", system)
    
    # Load QML
    qml_file = os.path.join(os.path.dirname(__file__), "ui/main.qml")
    engine.load(qml_file)
    
    if not engine.rootObjects():
        sys.exit(-1)
        
    sys.exit(app.exec())
