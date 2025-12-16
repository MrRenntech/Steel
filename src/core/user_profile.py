import json
import os

class UserProfile:
    def __init__(self):
        self.file_path = "user_profile.json"
        self.data = {
            "name": "User",
            "hobbies": [],
            "preferences": {},
            "is_onboarded": False
        }
        self.load()

    def load(self):
        if os.path.exists(self.file_path):
            try:
                with open(self.file_path, "r") as f:
                    self.data = json.load(f)
            except:
                pass # Corrupt file, keep default

    def save(self):
        with open(self.file_path, "w") as f:
            json.dump(self.data, f, indent=4)

    def set_info(self, name, hobbies):
        self.data["name"] = name
        # Hobbies can be a comma-separated string or list
        if isinstance(hobbies, str):
            self.data["hobbies"] = [h.strip() for h in hobbies.split(',')]
        else:
            self.data["hobbies"] = hobbies
        self.data["is_onboarded"] = True
        self.save()

    def get_name(self):
        return self.data.get("name", "User")
