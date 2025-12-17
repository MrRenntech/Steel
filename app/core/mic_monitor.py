import sounddevice as sd
import numpy as np
import threading
import time

class MicMonitor:
    def __init__(self):
        self.level = 0.0
        self.running = False
        self.stream = None

    def audio_callback(self, indata, frames, time_info, status):
        if status:
            return
        # RMS energy
        rms = np.sqrt(np.mean(indata**2))
        # Clamp & smooth
        self.level = min(max(rms * 10, 0.0), 1.0)

    def start(self):
        if self.running:
            return
        self.running = True
        try:
            self.stream = sd.InputStream(
                channels=1,
                callback=self.audio_callback
            )
            self.stream.start()
        except Exception as e:
            print(f"[MicMonitor] Failed to start stream: {e}")
            self.running = False

    def stop(self):
        self.running = False
        if self.stream:
            self.stream.stop()
            self.stream.close()
            self.stream = None
