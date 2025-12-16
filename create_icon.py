from PIL import Image
import os
import shutil

# Artifact path from previous generation
artifact_path = r"C:/Users/seanr/.gemini/antigravity/brain/956b8f5f-aede-4cb5-9d2b-727381bd341b/steel_logo_1765874231042.png"
dest_png = "assets/logo.png"
dest_ico = "assets/icon.ico"

try:
    img = Image.open(artifact_path)
    img.save(dest_png)
    img.save(dest_ico, format='ICO', sizes=[(256, 256)])
    print("Icon created successfully.")
except Exception as e:
    print(f"Error creating icon: {e}")
