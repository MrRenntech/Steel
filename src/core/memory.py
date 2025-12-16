import json
import os
import datetime

class MemoryManager:
    def __init__(self):
        self.file_path = "data/memory.json"
        self.ensure_dir()
        self.memory = self.load()

    def ensure_dir(self):
        if not os.path.exists("data"):
            os.makedirs("data")

    def load(self):
        if os.path.exists(self.file_path):
            try:
                with open(self.file_path, "r") as f:
                    return json.load(f)
            except:
                return {"chat_history": [], "facts": {}}
        return {"chat_history": [], "facts": {}}

    def save(self):
        with open(self.file_path, "w") as f:
            json.dump(self.memory, f, indent=4)

    def add_interaction(self, user_text, ai_text):
        timestamp = datetime.datetime.now().isoformat()
        entry = {"timestamp": timestamp, "user": user_text, "ai": ai_text}
        self.memory["chat_history"].append(entry)
        # Keep history limited to last 50 interactions to prevent bloat
        if len(self.memory["chat_history"]) > 50:
            self.memory["chat_history"] = self.memory["chat_history"][-50:]
        self.save()

    def remember_fact(self, key, value):
        self.memory["facts"][key] = value
        self.save()

    def get_context(self):
        # Format recent history for the AI
        context = "Here is the recent conversation history:\n"
        for msg in self.memory["chat_history"][-5:]:
            context += f"User: {msg['user']}\nAssistant: {msg['ai']}\n"
        
        # Add facts
        if self.memory["facts"]:
            context += "\nKnown facts about the user:\n"
            for k, v in self.memory["facts"].items():
                context += f"{k}: {v}\n"
                
        return context

    def get_facts(self):
        return self.memory["facts"]
