try:
    import cv2
    CV2_AVAILABLE = True
except ImportError:
    CV2_AVAILABLE = False
import threading
from PIL import Image, ImageGrab
import io
import time
import google.generativeai as genai
import os

class VisionSkill:
    def __init__(self):
        self.cap = None
        self.is_camera_active = False
        # Load Face Cascade if CV2 is available
        self.face_cascade = None
        if CV2_AVAILABLE:
            try:
                self.face_cascade = cv2.CascadeClassifier(cv2.data.haarcascades + 'haarcascade_frontalface_default.xml')
            except AttributeError:
                 pass # Fallback or handle missing data

    def start_camera(self):
        if not CV2_AVAILABLE: return False
        if self.cap is None:
            self.cap = cv2.VideoCapture(0)
        self.is_camera_active = True
        return self.cap.isOpened()

    def stop_camera(self):
        self.is_camera_active = False
        if self.cap:
            self.cap.release()
            self.cap = None

    def get_frame(self):
        if self.cap and self.is_camera_active and CV2_AVAILABLE:
            ret, frame = self.cap.read()
            if ret:
                # Face Detection
                if self.face_cascade:
                    gray = cv2.cvtColor(frame, cv2.COLOR_BGR2GRAY)
                    faces = self.face_cascade.detectMultiScale(gray, 1.1, 4)
                    for (x, y, w, h) in faces:
                        cv2.rectangle(frame, (x, y), (x+w, y+h), (0, 255, 0), 2)
                        cv2.putText(frame, "USER DETECTED", (x, y-10), cv2.FONT_HERSHEY_SIMPLEX, 0.5, (0,255,0), 2)
                
                # Convert to RGB for PIL/Tkinter
                return cv2.cvtColor(frame, cv2.COLOR_BGR2RGB)
        return None

    def capture_screen(self):
        return ImageGrab.grab()

    def analyze_image(self, image_pil):
        """Sends PIL Image to Gemini Vision"""
        api_key = os.getenv('GEMINI_API_KEY')
        if not api_key: return "Vision requires GEMINI_API_KEY."
        
        try:
            model = genai.GenerativeModel('gemini-pro-vision')
            response = model.generate_content(["Describe this image in detail.", image_pil])
            return response.text
        except Exception as e:
            # Fallback to gemini-1.5-flash if pro-vision is deprecated or unavailable
            try:
                model = genai.GenerativeModel('gemini-1.5-flash')
                response = model.generate_content(["Describe this image.", image_pil])
                return response.text
            except Exception as e2:
                 return f"Vision Error: {e2}"
