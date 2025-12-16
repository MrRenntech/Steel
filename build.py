import PyInstaller.__main__
import os
import shutil

# Clean previous build
if os.path.exists('build'):
    shutil.rmtree('build')
if os.path.exists('dist'):
    shutil.rmtree('dist')

print("Starting Build...")

PyInstaller.__main__.run([
    'main.py',
    '--name=SteelAssistant',
    '--onedir',
    '--windowed',
    '--noconfirm',
    '--clean',
    # Collect customtkinter data
    '--collect-all=customtkinter',
    '--collect-all=pyttsx3',
    '--collect-all=speech_recognition',
    '--collect-all=pycaw',
    '--collect-all=comtypes',
    '--collect-all=screen_brightness_control',
    '--collect-all=google.generativeai',
    '--hidden-import=win32timezone',
    '--hidden-import=win32security',
    '--hidden-import=win32api',
    '--hidden-import=win32con',
    '--hidden-import=cv2',
    '--hidden-import=cryptography',
    '--collect-all=cv2',
    '--collect-all=cryptography',
    '--icon=assets/icon.ico',
    '--add-data=src;src',
    '--add-data=assets;assets',
    '--add-data=HOW_TO.txt;.',
    '--add-data=README.md;.',
    '--add-data=CHANGELOG.txt;.',
])

print("Build Complete. Check 'dist/SteelAssistant' folder.")
