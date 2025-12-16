import customtkinter as ctk
from PIL import Image, ImageTk
import threading
import os
import time
import random
import math
import tkinter as tk
try:
    import cv2
    CV2_AVAILABLE = True
except ImportError:
    CV2_AVAILABLE = False
import winsound

from src.core.engine import SpeechEngine
from src.core.config_loader import Config
from src.core.security import Security
from src.core.vault import CredentialsVault
from src.core.user_profile import UserProfile
from src.core.memory import MemoryManager

from src.skills.web_automation import WebAutomation
from src.skills.basic import BasicSkills
from src.skills.system_ops import SystemOps
from src.skills.info import InfoSkills
from src.skills.ai import AIHandler
from src.skills.public_apis import PublicSkills
from src.skills.vision import VisionSkill
import datetime

ctk.set_appearance_mode("Dark")
ctk.set_default_color_theme("blue")

# --- SOUND MANAGER ---
class SoundManager:
    @staticmethod
    def play_startup():
        try: winsound.PlaySound("SystemAsterisk", winsound.SND_ASYNC) 
        except: pass
    @staticmethod
    def play_click():
        try: winsound.PlaySound("SystemExit", winsound.SND_ASYNC) # Using generic system sounds to avoid asset deps
        except: pass
    @staticmethod
    def play_alert():
        try: winsound.PlaySound("SystemHand", winsound.SND_ASYNC)
        except: pass

# --- UI COMPONENTS ---
class NeuralCanvas(tk.Canvas):
    def __init__(self, master, width=1280, height=800, theme_color="#C0C0C0", **kwargs):
        super().__init__(master, width=width, height=height, **kwargs)
        self.nodes = []
        self.width = width
        self.height = height
        self.theme_color = theme_color
        self.configure(bg="#050505", highlightthickness=0)
        self.bind("<Configure>", self.on_resize)
        
        for _ in range(40):
            self.nodes.append({
                "x": random.randint(0, self.width),
                "y": random.randint(0, self.height),
                "vx": random.uniform(-0.3, 0.3),
                "vy": random.uniform(-0.3, 0.3)
            })
        self.animate()

    def on_resize(self, event):
        self.width = event.width
        self.height = event.height

    def animate(self):
        self.delete("all")
        for node in self.nodes:
            node["x"] += node["vx"]
            node["y"] += node["vy"]
            if node["x"] < 0 or node["x"] > self.width: node["vx"] *= -1
            if node["y"] < 0 or node["y"] > self.height: node["vy"] *= -1
            
            self.create_oval(node["x"]-2, node["y"]-2, node["x"]+2, node["y"]+2, fill=self.theme_color, outline="")
            
            for other in self.nodes:
                dist = math.hypot(node["x"] - other["x"], node["y"] - other["y"])
                if dist < 120:
                     self.create_line(node["x"], node["y"], other["x"], other["y"], fill="#333333", width=1)
        self.after(50, self.animate)

class SteelApp(ctk.CTk):
    def __init__(self):
        super().__init__()

        # --- THEMES ---
        self.themes = {
            "BENTLEY":  {"fg": "#080808", "accent": "#00A2FF", "text": "white", "sec": "#1A1A1A", "node": "#C0C0C0"},
            "FERRARI":  {"fg": "#110000", "accent": "#FF2800", "text": "#FFF200", "sec": "#200000", "node": "#FF0000"},
            "MERCEDES": {"fg": "#000000", "accent": "#00F5FF", "text": "white",   "sec": "#111111", "node": "#00CCFF"},
            "BMW":      {"fg": "#F0F0F0", "accent": "#0066B1", "text": "black",   "sec": "#FFFFFF", "node": "#0066B1"}, # Lightish
            "AUDI":     {"fg": "#000000", "accent": "#FF0000", "text": "white",   "sec": "#101010", "node": "#FF3333"},
            "CHEVY":    {"fg": "#050510", "accent": "#FFD700", "text": "white",   "sec": "#0A0A20", "node": "#FFD700"},
        }
        self.current_theme_name = "BENTLEY"
        self.colors = self.themes["BENTLEY"]
        
        # --- INIT ---
        self.title("STEEL | v5.3.0")
        self.geometry(f"{1280}x{800}")
        self.resizable(True, True)

        # --- CORE ---
        self.engine = SpeechEngine()
        self.web = WebAutomation()
        self.skills = BasicSkills()
        self.sys_ops = SystemOps()
        self.info = InfoSkills()
        self.ai = AIHandler()
        self.public = PublicSkills()
        self.vision = VisionSkill()
        self.security = Security(pin=os.getenv('APP_PIN', '0000'))
        self.vault = CredentialsVault()
        self.profile = UserProfile()
        self.memory = MemoryManager()
        
        self.is_listening = False
        self.camera_on = False
        self.sounds_enabled = True

        # --- UI LAYERS ---
        self.neural_bg = NeuralCanvas(self, theme_color=self.colors["node"])
        self.neural_bg.place(x=0, y=0, relwidth=1, relheight=1)
        
        self.bg_label = ctk.CTkLabel(self, text="") 
        self.bg_label.place(x=0, y=0, relwidth=1, relheight=1)
        self.bg_label.lower() 

        self.main_container = ctk.CTkFrame(self, fg_color="transparent")
        self.main_container.place(x=0, y=0, relwidth=1, relheight=1)

        # --- STARTUP SEQUENCE ---
        self.show_splash_screen()

    # --- PREMIUM UI COMPONENTS ---
    def get_font(self, style="body", size=12, weight="normal"):
        # Bentley Aesthetic: Serif for Headers, Clean Sans for body
        if style == "header":
            return ctk.CTkFont(family="Times New Roman", size=size, weight="bold")
        elif style == "title":
            return ctk.CTkFont(family="Times New Roman", size=size, weight="bold")
        else:
            return ctk.CTkFont(family="Arial", size=size, weight=weight)

    def show_splash_screen(self):
        self.splash = ctk.CTkFrame(self.main_container, fg_color="#000000")
        self.splash.place(relx=0, rely=0, relwidth=1, relheight=1)
        
        ctk.CTkLabel(self.splash, text="STEEL OS", font=self.get_font("title", 60), text_color=self.colors["accent"]).place(relx=0.5, rely=0.4, anchor="center")
        
        self.progress = ctk.CTkProgressBar(self.splash, width=400, height=5, progress_color=self.colors["accent"])
        self.progress.place(relx=0.5, rely=0.55, anchor="center")
        self.progress.set(0)
        
        self.load_lbl = ctk.CTkLabel(self.splash, text="Initializing...", text_color="gray", font=self.get_font("body", 12))
        self.load_lbl.place(relx=0.5, rely=0.6, anchor="center")
        
        threading.Thread(target=self.run_splash).start()

    def show_login_screen(self):
        self.login_frame = ctk.CTkFrame(self.main_container, fg_color="#000000", corner_radius=0)
        self.login_frame.place(relx=0, rely=0, relwidth=1, relheight=1)
        
        self.avatar_canvas = ctk.CTkCanvas(self.login_frame, width=120, height=120, bg="#000000", highlightthickness=0)
        self.avatar_canvas.place(relx=0.5, rely=0.3, anchor="center")
        self.avatar_canvas.create_oval(10, 10, 110, 110, fill="#1A1A1A", outline=self.colors["accent"], width=3)
        initial = self.profile.get_name()[0].upper() if self.profile.get_name() else "S"
        self.avatar_canvas.create_text(60, 60, text=initial, fill="white", font=("Times New Roman", 40, "bold"))
        
        ctk.CTkLabel(self.login_frame, text=self.profile.get_name() or "OPERATOR", font=self.get_font("header", 24), text_color="white").place(relx=0.5, rely=0.42, anchor="center")
        
        self.pwd_entry = ctk.CTkEntry(self.login_frame, placeholder_text="Windows Password / PIN", show="*", width=250, font=self.get_font("body", 14))
        self.pwd_entry.place(relx=0.5, rely=0.5, anchor="center")
        self.pwd_entry.bind("<Return>", self.attempt_login)
        
        self.login_btn = ctk.CTkButton(self.login_frame, text="UNLOCK SYSTEM", command=self.attempt_login_btn, width=250, height=40, fg_color=self.colors["accent"], font=self.get_font("body", 14, "bold"))
        self.login_btn.place(relx=0.5, rely=0.58, anchor="center")
        
        self.login_status = ctk.CTkLabel(self.login_frame, text="", text_color="red", font=self.get_font("body", 12))
        self.login_status.place(relx=0.5, rely=0.65, anchor="center")

    def show_onboarding(self):
        self.onboard_frame = ctk.CTkFrame(self.main_container, fg_color="#111111", corner_radius=20, border_width=2, border_color=self.colors["sec"])
        self.onboard_frame.place(relx=0.5, rely=0.5, anchor="center", relwidth=0.7, relheight=0.8)
        
        ctk.CTkLabel(self.onboard_frame, text="WELCOME TO STEEL", font=self.get_font("title", 30), text_color=self.colors["accent"]).pack(pady=(30, 10))
        ctk.CTkLabel(self.onboard_frame, text="Identify yourself, Operator.", font=self.get_font("body", 16)).pack(pady=5)
        
        self.name_e = ctk.CTkEntry(self.onboard_frame, placeholder_text="Designation (Name)", width=300, font=self.get_font("body", 14))
        self.name_e.pack(pady=20)
        
        ctk.CTkLabel(self.onboard_frame, text="Select Interests for Neural Context:", font=self.get_font("header", 14)).pack(pady=(10, 5))
        
        hobbies_frame = ctk.CTkScrollableFrame(self.onboard_frame, width=300, height=200, fg_color=self.colors["sec"])
        hobbies_frame.pack(pady=10)
        
        self.hobby_vars = []
        hobbies_list = ["Coding", "Gaming", "Artificial Intelligence", "Cars / Racing", "Music Production", "Finance / Stocks", "Cybersecurity", "Movies", "Fitness"]
        for h in hobbies_list:
            var = ctk.BooleanVar()
            ctk.CTkCheckBox(hobbies_frame, text=h, variable=var, font=self.get_font("body", 12), fg_color=self.colors["accent"], hover_color=self.colors["accent"]).pack(anchor="w", pady=5, padx=10)
            self.hobby_vars.append((h, var))

        ctk.CTkButton(self.onboard_frame, text="INITIALIZE CORE", command=self.finish_onboard, fg_color=self.colors["accent"], width=200, height=40, font=self.get_font("body", 14, "bold")).pack(pady=30)

    def finish_onboard(self):
        if self.sounds_enabled: SoundManager.play_click()
        name = self.name_e.get()
        selected_hobbies = [h for h, var in self.hobby_vars if var.get()]
        hobbies_str = ", ".join(selected_hobbies)
        
        if name:
            self.profile.set_info(name, hobbies_str)
            self.memory.remember_fact("hobbies", hobbies_str)
            self.onboard_frame.destroy()
            self.setup_main_interface()

    def create_sidebar(self):
        self.sb = ctk.CTkFrame(self.main_container, width=240, fg_color=self.colors["fg"], corner_radius=0)
        self.sb.grid(row=0, column=0, sticky="nsew")
        self.sb.grid_rowconfigure(7, weight=1)
        
        # Identity Block
        ctk.CTkLabel(self.sb, text=self.profile.get_name().upper(), font=self.get_font("title", 22), text_color=self.colors["text"]).grid(row=0, column=0, pady=(40, 5))
        ctk.CTkLabel(self.sb, text="PRIMARY OPERATOR", font=self.get_font("body", 10), text_color="gray").grid(row=1, column=0, pady=(0, 40))
        
        self.add_nav_btn(self.sb, "DASHBOARD", 2)
        self.add_nav_btn(self.sb, "VISION", 3)
        self.add_nav_btn(self.sb, "VAULT", 4)
        self.add_nav_btn(self.sb, "SETTINGS", 5)
        
        color = "#00FF00" if self.sys_ops.is_admin() else "#FF5500"
        txt = "ADMIN ACTIVE" if self.sys_ops.is_admin() else "USER MODE"
        ctk.CTkLabel(self.sb, text=txt, text_color=color, font=self.get_font("body", 10, "bold")).grid(row=8, column=0, pady=20)

    def add_nav_btn(self, parent, text, row):
        btn = ctk.CTkButton(parent, text=text, command=lambda: self.show_tab(text), 
                            fg_color="transparent", hover_color=self.colors["sec"], anchor="w", width=200, height=50,
                            font=self.get_font("header", 14), text_color=self.colors["text"])
        btn.grid(row=row, column=0, padx=20, pady=5)

    def create_dashboard_tab(self):
        frame = ctk.CTkFrame(self.content_area, fg_color="transparent")
        self.frames["DASHBOARD"] = frame
        
        # System Stats Card
        gauge_frame = ctk.CTkFrame(frame, fg_color=self.colors["fg"], corner_radius=10, border_width=1, border_color=self.colors["sec"])
        gauge_frame.pack(fill="x", pady=(0, 20))
        
        ctk.CTkLabel(gauge_frame, text="SYSTEM STATUS", font=self.get_font("header", 16), text_color="gray").pack(anchor="w", padx=20, pady=(15, 5))
        
        stats_container = ctk.CTkFrame(gauge_frame, fg_color="transparent")
        stats_container.pack(fill="x", padx=10, pady=10)
        
        self.cpu_bar, self.cpu_lbl = self.add_gauge(stats_container, "CPU CORE", 0)
        self.ram_bar, self.ram_lbl = self.add_gauge(stats_container, "MEMORY", 1)
        self.bat_bar, self.bat_lbl = self.add_gauge(stats_container, "POWER", 2)
        
        self.log_frame = ctk.CTkScrollableFrame(frame, label_text="NEURAL FEED", fg_color=self.colors["sec"], label_text_color=self.colors["accent"], label_font=self.get_font("header", 14))
        self.log_frame.pack(fill="both", expand=True, pady=(0, 20))
        
        btn = ctk.CTkButton(frame, text="INITIATE VOICE UPLINK", command=self.start_listening, height=50, fg_color=self.colors["accent"], font=self.get_font("header", 14))
        btn.pack(fill="x")

    def add_gauge(self, parent, title, col):
        f = ctk.CTkFrame(parent, fg_color="transparent")
        f.pack(side="left", expand=True, fill="x", padx=5)
        
        header = ctk.CTkFrame(f, fg_color="transparent")
        header.pack(fill="x")
        ctk.CTkLabel(header, text=title, text_color="gray", font=self.get_font("body", 10, "bold")).pack(side="left")
        percent_lbl = ctk.CTkLabel(header, text="0%", text_color=self.colors["accent"], font=self.get_font("body", 12, "bold"))
        percent_lbl.pack(side="right")
        
        bar = ctk.CTkProgressBar(f, height=8, progress_color=self.colors["accent"])
        bar.set(0)
        bar.pack(pady=5, fill="x")
        return bar, percent_lbl

    def sys_ops_loop(self):
        stats = self.sys_ops.get_system_stats()
        
        self.cpu_bar.set(stats["cpu"]/100)
        self.cpu_lbl.configure(text=f"{int(stats['cpu'])}%")
        
        self.ram_bar.set(stats["ram"]/100)
        self.ram_lbl.configure(text=f"{int(stats['ram'])}%")
        
        self.bat_bar.set(stats["battery"]/100)
        self.bat_lbl.configure(text=f"{int(stats['battery'])}%")
        
        self.after(2000, self.sys_ops_loop)

    def create_vision_tab(self):
        frame = ctk.CTkFrame(self.content_area, fg_color="transparent")
        self.frames["VISION"] = frame
        
        status_text = "CAMERA OFFLINE"
        if not CV2_AVAILABLE:
            status_text = "VISION UNAVAILABLE (MISSING OPENCV)"
            
        self.cam_label = ctk.CTkLabel(frame, text=status_text, fg_color="black", text_color="gray")
        self.cam_label.pack(fill="both", expand=True, pady=(0, 10))
        controls = ctk.CTkFrame(frame, fg_color="transparent")
        controls.pack(fill="x", pady=10)
        
        state = "normal" if CV2_AVAILABLE else "disabled"
        ctk.CTkButton(controls, text="ANALYZE CAMERA", command=self.analyze_cam, fg_color=self.colors["accent"], state=state).pack(side="left", expand=True, padx=5)
        # Screen analysis doesn't strictly need CV2 if we use PIL/PyAutoGUI, but VisionSkill uses CV2 logic often.
        # Assuming screen capture uses PIL `ImageGrab`, check implementation.
        # VisionSkill.capture_screen usually relies on PIL. 
        # But if `analyze_image` is generic, we can keep Screen Analyze open?
        # Let's keep it safe.
        ctk.CTkButton(controls, text="ANALYZE SCREEN", command=self.analyze_screen, fg_color="#555555").pack(side="left", expand=True, padx=5)

    def create_vault_tab(self):
        frame = ctk.CTkFrame(self.content_area, fg_color="transparent")
        self.frames["VAULT"] = frame
        ctk.CTkLabel(frame, text="SECURE VAULT", font=ctk.CTkFont(size=20), text_color=self.colors["text"]).pack(pady=20)
        form = ctk.CTkFrame(frame, fg_color=self.colors["sec"])
        form.pack(pady=10, padx=50, fill="x")
        self.v_svc = ctk.CTkEntry(form, placeholder_text="Service")
        self.v_svc.pack(pady=5, padx=20, fill="x")
        self.v_usr = ctk.CTkEntry(form, placeholder_text="Username")
        self.v_usr.pack(pady=5, padx=20, fill="x")
        self.v_pwd = ctk.CTkEntry(form, placeholder_text="Password", show="*")
        self.v_pwd.pack(pady=5, padx=20, fill="x")
        ctk.CTkButton(form, text="SAVE", command=self.save_cred, fg_color=self.colors["accent"]).pack(pady=10)
        self.vault_lbl = ctk.CTkLabel(frame, text="")
        self.vault_lbl.pack()

    def create_settings_tab(self):
        frame = ctk.CTkFrame(self.content_area, fg_color="transparent")
        self.frames["SETTINGS"] = frame
        
        ctk.CTkLabel(frame, text="CONFIGURATION", font=ctk.CTkFont(size=20, weight="bold"), text_color=self.colors["text"]).pack(pady=20)
        
        set_box = ctk.CTkFrame(frame, fg_color=self.colors["sec"])
        set_box.pack(pady=10, padx=20, fill="x")
        
        # Theme
        ctk.CTkLabel(set_box, text="VISUAL THEME").pack(pady=5)
        self.theme_combo = ctk.CTkComboBox(set_box, values=list(self.themes.keys()), command=self.change_theme)
        self.theme_combo.set(self.current_theme_name)
        self.theme_combo.pack(pady=5)
        
        # Sounds
        self.snd_var = ctk.BooleanVar(value=True)
        ctk.CTkSwitch(set_box, text="SOUND EFFECTS", variable=self.snd_var, command=self.toggle_sounds, progress_color=self.colors["accent"]).pack(pady=10)
        
        # Wallpaper
        ctk.CTkLabel(set_box, text="BACKGROUND").pack(pady=5)
        btn_box = ctk.CTkFrame(set_box, fg_color="transparent")
        btn_box.pack()
        ctk.CTkButton(btn_box, text="NEURAL (LIVE)", command=self.set_neural, fg_color="#333333").pack(side="left", padx=5)
        ctk.CTkButton(btn_box, text="CUSTOM IMAGE", command=self.set_bg_image, fg_color=self.colors["accent"]).pack(side="left", padx=5)
        
        self.set_lbl = ctk.CTkLabel(frame, text="")
        self.set_lbl.pack()

    # --- SETTINGS LOGIC ---
    def change_theme(self, choice):
        if self.sounds_enabled: SoundManager.play_click()
        self.current_theme_name = choice
        self.colors = self.themes[choice]
        # Full Apply requires restart or complex rebinding types.
        # We will apply partial updates to confirm selection.
        self.sb.configure(fg_color=self.colors["fg"])
        self.log_frame.configure(fg_color=self.colors["sec"], label_text_color=self.colors["accent"])
        self.set_lbl.configure(text=f"Theme {choice} active. Restart to see full changes.", text_color=self.colors["accent"])

    def toggle_sounds(self):
        self.sounds_enabled = self.snd_var.get()

    def set_neural(self):
        self.bg_label.lower()
        self.neural_bg.lift()
        self.set_lbl.configure(text="Neural Background Active", text_color="gray")

    def set_bg_image(self):
        from tkinter import filedialog
        path = filedialog.askopenfilename(filetypes=[("Images", "*.jpg *.png *.jpeg")])
        if path:
            img = Image.open(path)
            w, h = self.winfo_width(), self.winfo_height()
            img = img.resize((w, h), Image.Resampling.LANCZOS)
            self.bg_img = ImageTk.PhotoImage(img) # Keep ref
            self.bg_label.configure(image=self.bg_img)
            self.bg_label.lift()
            self.neural_bg.lower()
            self.content_area.lift()
            self.sb.lift()
            self.set_lbl.configure(text=f"Wallpaper Set: {os.path.basename(path)}", text_color="green")

    # --- MAIN LOOP ---
    def sys_ops_loop(self):
        stats = self.sys_ops.get_system_stats()
        self.cpu_bar.set(stats["cpu"]/100)
        self.ram_bar.set(stats["ram"]/100)
        self.bat_bar.set(stats["battery"]/100)
        self.after(2000, self.sys_ops_loop)

    def start_listening(self):
        if not self.is_listening:
            if self.sounds_enabled: SoundManager.play_click()
            self.is_listening = True
            threading.Thread(target=self.process_voice).start()

    def process_voice(self):
        txt = self.engine.listen()
        self.is_listening = False
        if txt:
            self.log_user(txt)
            self.handle_command(txt)

    def handle_command(self, txt):
        txt = txt.lower()
        # Save to Memory
        
        # Vision
        if "screen" in txt and ("analyze" in txt or "look" in txt):
             self.analyze_screen()
             return
        if "camera" in txt and ("open" in txt or "on" in txt):
             self.show_tab("VISION")
             return
             
        # AI + Memory Context
        context = self.memory.get_context()
        full_prompt = f"{context}\nUser: {txt}\nAssistant:"
        
        resp = self.ai.ask(full_prompt)
        
        self.memory.add_interaction(txt, resp) # Persist
        
        self.log_sys(resp)
        self.speak(resp)

    def log_sys(self, txt):
        ctk.CTkLabel(self.log_frame, text=f"STEEL: {txt}", text_color=self.colors["accent"], anchor="w", wraplength=500, justify="left").pack(fill="x", padx=5)
    
    def log_user(self, txt):
        ctk.CTkLabel(self.log_frame, text=f"> {txt}", text_color=self.colors["text"], anchor="e", wraplength=500, justify="right").pack(fill="x", padx=5)

    def speak(self, txt):
        threading.Thread(target=lambda: self.engine.speak(txt)).start()

    # --- VISION ---
    def start_camera_preview(self):
        self.camera_on = True
        self.vision.start_camera()
        self.update_camera_frame()

    def stop_camera_preview(self):
        self.camera_on = False
        self.vision.stop_camera()
        self.cam_label.configure(image=None, text="CAMERA OFFLINE")

    def update_camera_frame(self):
        if not self.camera_on or not CV2_AVAILABLE: return
        frame = self.vision.get_frame()
        if frame is not None:
             pil_img = Image.fromarray(frame)
             ctk_img = ctk.CTkImage(light_image=pil_img, size=(640, 480))
             self.cam_label.configure(image=ctk_img, text="")
        self.after(30, self.update_camera_frame)

    def analyze_cam(self):
        if self.sounds_enabled: SoundManager.play_click()
        frame = self.vision.get_frame()
        if frame is not None:
             self.log_sys("Analyzing visual...")
             desc = self.vision.analyze_image(Image.fromarray(frame))
             self.log_sys(desc)
             self.speak(desc)

    def analyze_screen(self):
        if self.sounds_enabled: SoundManager.play_click()
        self.log_sys("Capturing screen...")
        img = self.vision.capture_screen()
        desc = self.vision.analyze_image(img)
        self.log_sys(desc)
        self.speak(desc)

    def save_cred(self):
        if self.sounds_enabled: SoundManager.play_click()
        s, u, p = self.v_svc.get(), self.v_usr.get(), self.v_pwd.get()
        if s and u and p:
            self.vault.save_credential(s, u, p)
            self.vault_lbl.configure(text=f"Encrypted {s} to Vault.", text_color="green")
            self.v_pwd.delete(0, 'end')

if __name__ == "__main__":
    app = SteelApp()
    app.mainloop()
