import re

class Security:
    def __init__(self, pin="0000"):
        self.pin = pin
        self.is_locked = True
    
    def unlock(self, input_pin):
        if input_pin == self.pin:
            self.is_locked = False
            return True
        return False

    def lock(self):
        self.is_locked = True

    @staticmethod
    def sanitize_input(text):
        """
        Removes potentially dangerous characters or sequences.
        Although Python logic is safer than shell execution, 
        this ensures we don't process weird control characters.
        """
        if not text: return ""
        # Allow alphanumeric, spaces, and basic punctuation
        sanitized = re.sub(r'[^a-zA-Z0-9\s\?\.\,\!\-\'\"]', '', text)
        return sanitized.strip()

    def validate_windows_credentials(self, username, password):
        """
        Validates user credentials against the local Windows Security Authority.
        Returns True if valid, False otherwise.
        """
        try:
            import win32security
            import win32con
            
            # Use the currently logged-in domain (computer name) or allow user to specify domain\user
            domain = ""
            if "\\" in username:
                domain, username = username.split("\\")
            
            # Attempt to log the user in. If successful, token is returned.
            token = win32security.LogonUser(
                username,
                domain,
                password,
                win32con.LOGON32_LOGON_INTERACTIVE,
                win32con.LOGON32_PROVIDER_DEFAULT
            )
            if token:
                return True
        except Exception as e:
            # print(f"Auth Failed: {e}")
            pass
        return False
