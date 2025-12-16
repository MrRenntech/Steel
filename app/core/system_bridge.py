from PySide6.QtCore import QObject, Signal, Property, Slot, QTimer
import psutil

class SystemBridge(QObject):
    def __init__(self):
        super().__init__()
        self._cpu = 0
        self._ram = 0
        self._battery = 0
        
        # Timer for polling
        self.timer = QTimer(self)
        self.timer.timeout.connect(self.update_stats)
        self.timer.start(2000) # 2s

    # Signals
    cpuChanged = Signal()
    ramChanged = Signal()
    batteryChanged = Signal()

    @Property(int, notify=cpuChanged)
    def cpu(self): return self._cpu

    @Property(int, notify=ramChanged)
    def ram(self): return self._ram

    @Property(int, notify=batteryChanged)
    def battery(self): return self._battery

    def update_stats(self):
        self._cpu = int(psutil.cpu_percent())
        self._ram = int(psutil.virtual_memory().percent)
        try:
            bat = psutil.sensors_battery()
            self._battery = int(bat.percent) if bat else 100
        except:
            self._battery = 100
            
        self.cpuChanged.emit()
        self.ramChanged.emit()
        self.batteryChanged.emit()
