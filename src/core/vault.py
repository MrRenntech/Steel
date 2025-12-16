from cryptography.fernet import Fernet
import os
import json
import base64
from cryptography.hazmat.primitives import hashes
from cryptography.hazmat.primitives.kdf.pbkdf2 import PBKDF2HMAC
from src.core.config_loader import Config

class CredentialsVault:
    def __init__(self):
        self.file_path = "vault.dat"
        self.key_file = "vault.key"
        self.cipher = None
        self.load_key()

    def generate_key(self, password="DEFAULT_MASTER_PASSWORD"):
        # In a real app, user would provide a master password every time
        # For this assistant, we use a generated key stored locally (security vs convenience trade-off)
        if os.path.exists(self.key_file):
            with open(self.key_file, "rb") as f:
                key = f.read()
        else:
            key = Fernet.generate_key()
            with open(self.key_file, "wb") as f:
                f.write(key)
        
        self.cipher = Fernet(key)

    def load_key(self):
        self.generate_key()

    def save_credential(self, service, username, password):
        data = self.load_all()
        data[service] = {"username": username, "password": password}
        encrypted_data = self.cipher.encrypt(json.dumps(data).encode())
        with open(self.file_path, "wb") as f:
            f.write(encrypted_data)

    def get_credential(self, service):
        data = self.load_all()
        return data.get(service)

    def load_all(self):
        if not os.path.exists(self.file_path):
            return {}
        try:
            with open(self.file_path, "rb") as f:
                encrypted_data = f.read()
            decrypted_data = self.cipher.decrypt(encrypted_data)
            return json.loads(decrypted_data.decode())
        except Exception as e:
            print(f"Vault Error: {e}")
            return {}

    def list_services(self):
        return list(self.load_all().keys())
