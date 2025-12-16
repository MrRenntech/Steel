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
    app_state = AppState()
    system = SystemBridge()
    
    # Initialize Core Logic (State Machine)
    from core.steel_core import SteelCore
    core = SteelCore(app_state)

    engine = QQmlApplicationEngine()
    
    # Expose to QML
    engine.rootContext().setContextProperty("app", app_state)
    engine.rootContext().setContextProperty("system", system)
    
    # Load QML
    qml_file = os.path.join(os.path.dirname(__file__), "ui/main.qml")
    engine.load(qml_file)
    
    if not engine.rootObjects():
        sys.exit(-1)
        
    sys.exit(app.exec())
