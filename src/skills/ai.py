import google.generativeai as genai
import os
from src.core.config_loader import Config

class AIHandler:
    def __init__(self):
        self.api_key = os.getenv('GEMINI_API_KEY')
        self.model = None
        self.chat_session = None
        
        if self.api_key:
            try:
                genai.configure(api_key=self.api_key)
                self.model = genai.GenerativeModel('gemini-pro')
                self.chat_session = self.model.start_chat(history=[])
            except Exception as e:
                print(f"AI Init Failed: {e}")

    def ask(self, prompt):
        if not self.model:
            return "I am not connected to my AI brain. Please check your API Key."
        
        try:
            # Send message to chat session to keep context
            if self.chat_session:
                response = self.chat_session.send_message(prompt)
                return response.text
            else:
                return "AI Chat session not active."
        except Exception as e:
            return f"I had trouble thinking: {e}"
