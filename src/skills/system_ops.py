import psutil
import screen_brightness_control as sbc
from ctypes import cast, POINTER
from comtypes import CLSCTX_ALL
from ctypes import cast, POINTER, windll
from comtypes import CLSCTX_ALL
from pycaw.pycaw import AudioUtilities, IAudioEndpointVolume
import math
import subprocess
import winreg
import os
import shutil

class SystemOps:
    def __init__(self):
        # Setup Audio
        try:
            devices = AudioUtilities.GetSpeakers()
            interface = devices.Activate(IAudioEndpointVolume._iid_, CLSCTX_ALL, None)
            self.volume = cast(interface, POINTER(IAudioEndpointVolume))
        except:
            self.volume = None

    def get_system_stats(self):
        """Returns a dict of system stats."""
        cpu = psutil.cpu_percent(interval=None)
        ram = psutil.virtual_memory().percent
        battery = psutil.sensors_battery()
        bat_percent = battery.percent if battery else 100
        return {"cpu": cpu, "ram": ram, "battery": bat_percent}

    def set_volume(self, level):
        """Set volume to a specific percentage (0-100)."""
        if not self.volume: return "Audio control unavailable."
        # Clamp between 0 and 100
        level = max(0, min(100, level))
        # Pycaw expects scalar in range
        # Convert 0-100 to decibel range is complex, simpler is to use ScalarVolume?
        # self.volume.SetMasterVolumeLevelScalar(level / 100, None)
        # Actually SetMasterVolumeLevelScalar is linear 0.0 to 1.0
        try:
            self.volume.SetMasterVolumeLevelScalar(level / 100.0, None)
            return f"Volume set to {level}%"
        except Exception as e:
            return f"Error setting volume: {e}"

    def change_volume(self, change):
        if not self.volume: return
        current = self.volume.GetMasterVolumeLevelScalar() * 100
        new_level = current + change
        return self.set_volume(new_level)

    def set_brightness(self, level):
        try:
           sbc.set_brightness(level)
           return f"Brightness set to {level}%"
        except Exception as e:
            return f"Error setting brightness: {e}"

    def is_admin(self):
        try:
            return windll.shell32.IsUserAnAdmin()
        except:
            return False

    def connect_vpn(self):
        # Placeholder command. In reality, this depends heavily on the VPN client.
        # Example for generic OpenVPN: openvpn --config client.ovpn
        # We will assume a user command is set in env
        cmd = os.getenv('VPN_CONNECT_CMD')
        if not cmd:
            return "VPN command not configured in .env (VPN_CONNECT_CMD)."
        
        try:
            subprocess.Popen(cmd, shell=True)
            return "Executing VPN connection command..."
        except Exception as e:
            return f"Error connecting VPN: {e}"

    def find_app_path(self, app_name):
        """Attempts to find an app executable using Windows Registry."""
        # Common keys where uninstallers live (good way to find install location)
        roots = [winreg.HKEY_LOCAL_MACHINE, winreg.HKEY_CURRENT_USER]
        keys = [
            r"SOFTWARE\Microsoft\Windows\CurrentVersion\Uninstall",
            r"SOFTWARE\WOW6432Node\Microsoft\Windows\CurrentVersion\Uninstall"
        ]
        
        app_name = app_name.lower()
        
        for root in roots:
            for key_path in keys:
                try:
                    with winreg.OpenKey(root, key_path) as key:
                        for i in range(0, winreg.QueryInfoKey(key)[0]):
                            sub_key_name = winreg.EnumKey(key, i)
                            with winreg.OpenKey(key, sub_key_name) as sub_key:
                                try:
                                    display_name = winreg.QueryValueEx(sub_key, "DisplayName")[0].lower()
                                    if app_name in display_name:
                                        # Try to find InstallLocation or DisplayIcon
                                        # This is heuristic and messy on Windows
                                        try:
                                            install_loc = winreg.QueryValueEx(sub_key, "InstallLocation")[0]
                                            # Look for exe in that folder
                                            for f in os.listdir(install_loc):
                                                if f.endswith(".exe") and app_name in f.lower():
                                                    return os.path.join(install_loc, f)
                                        except: pass
                                except: pass
                except: pass
        
        # Fallback to shutil which checks PATH
        path = shutil.which(app_name)
        if path: return path
        
        return None
