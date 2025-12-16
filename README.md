# STEEL OS | AI ASSISTANT (v5.7.0)
*The Ultimate "Game Ready" Personal Assistant.*

## 🌟 Overview
Steel is a Python-based desktop assistant designed for power users, gamers, and developers. It blends a **Jarvis-like voice interface** with a **premium "Driver" dashboard** inspired by modern automotive and gaming software aesthetics.

## 🚀 Key Features
*   **🧠 Neural Core**: Powered by **Google Gemini 1.5**, remembering your hobbies and conversations (`memory.json`).
*   **🏎️ "Driver" Dashboard**: Real-time CPU/RAM/Battery gauges with a sleek, card-based UI.
*   **🛡️ Security Center**: 
    *   **Crypt-Vault**: AES-256 encrypted password manager.
    *   **VPN Tunneling**: Auto-interface for NordVPN, ExpressVPN, etc.
*   **🎵 Media & News**: Global media keys (Spotify) and live Tech/Car news feeds.
*   **👁️ Vision**: Analyze camera feeds or screen content ("What is on my screen?").
*   **🎨 Customization**: Themes (Ferrari, Bentley, BMW, Neon) and AI-generated wallpapers.

## 📦 Installation
1.  **Clone**: `git clone https://github.com/MrRenntech/Steel.git`
2.  **Setup**: Run `prereq.bat` to install dependencies.
    *   *Requires Python 3.10+*
    *   *Recommend: FFMPEG (for sound)*
3.  **Config**: Rename `.env.example` to `.env` and add your **GEMINI_API_KEY**.
4.  **Run**: `python main.py`

## 🎮 How to Use
-   **Voice**: Click "INITIATE VOICE UPLINK" and speak.
    -   *"Analyze my screen"*
    -   *"Play music"*
    -   *"Check system status"*
-   **Security**: Go to the **Security Tab** to manage passwords or connect your VPN.
-   **Settings**: Change the Theme to "BMW" to see the dynamic wallpaper switch.

## 🏗️ Building (EXE)
Run `python build.py` to compile a standalone executable in `dist/`.

## 📝 License
Open Source (MIT). Built for the community.
