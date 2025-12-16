import pyttsx3
import speech_recognition as sr
import threading

class SpeechEngine:
    def __init__(self, voice_id=None):
        self.engine = pyttsx3.init('sapi5')
        self.r = sr.Recognizer()
        self.r.pause_threshold = 1
        
        # Set Voice
        voices = self.engine.getProperty('voices')
        # Default to the last voice (often a female voice in SAPI5)
        if voice_id is None:
            self.engine.setProperty('voice', voices[len(voices)-1].id)
        else:
            self.engine.setProperty('voice', voice_id)

    def speak(self, text, on_start=None, on_end=None):
        """Speaks the text. Can be run in a separate thread to not block UI."""
        print(f"Computer: {text}")
        if on_start: on_start()
        self.engine.say(text)
        self.engine.runAndWait()
        if on_end: on_end()

    def listen(self):
        """Listens for audio and returns string."""
        with sr.Microphone() as source:
            print("Listening...")
            # Adjust for ambient noise?
            # self.r.adjust_for_ambient_noise(source)
            try:
                audio = self.r.listen(source, timeout=5, phrase_time_limit=5)
                query = self.r.recognize_google(audio, language='en-US')
                print(f"User: {query}")
                return query.lower()
            except sr.WaitTimeoutError:
                return None
            except sr.UnknownValueError:
                return None
            except sr.RequestError:
                return "Network Error"
            except Exception as e:
                print(e)
                return None
