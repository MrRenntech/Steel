from selenium import webdriver
from selenium.webdriver.chrome.options import Options
from selenium.webdriver.common.by import By
import time
from src.core.config_loader import Config

class WebAutomation:
    def __init__(self):
        self.browser = None

    def open_browser(self):
        chrome_options = webdriver.ChromeOptions()
        chrome_options.add_argument('--no-sandbox')
        # Check if driver path exists, else rely on PATH
        try:
            if Config.CHROMEDRIVER_PATH and Config.CHROMEDRIVER_PATH != 'chromedriver.exe':
                 self.browser = webdriver.Chrome(Config.CHROMEDRIVER_PATH, options=chrome_options)
            else:
                 self.browser = webdriver.Chrome(options=chrome_options)
        except Exception as e:
            print(f"Failed to open browser: {e}")
            return False
        return True

    def login_netflix(self):
        if not Config.NETFLIX_LOGIN or not Config.NETFLIX_PASSWORD:
            return "Netflix credentials not configured."
        if not self.open_browser(): return "Failed to open browser"
        try:
            self.browser.get("https://www.netflix.com/login")
            time.sleep(2) # Wait for load
            # Selectors might need updating as websites change
            self.browser.find_element(By.NAME, 'userLoginId').send_keys(Config.NETFLIX_LOGIN)
            self.browser.find_element(By.NAME, 'password').send_keys(Config.NETFLIX_PASSWORD)
            self.browser.find_element(By.CSS_SELECTOR, ".btn.login-button.btn-submit.btn-small").click()
            return "Logged into Netflix"
        except Exception as e:
            return f"Error logging into Netflix: {e}"

    def login_facebook(self):
        if not Config.FACEBOOK_MAIL or not Config.FACEBOOK_PASSWORD:
            return "Facebook credentials not configured."
        if not self.open_browser(): return "Failed to open browser"
        try:
            self.browser.get("https://www.facebook.com/")
            time.sleep(2)
            self.browser.find_element(By.NAME, 'email').send_keys(Config.FACEBOOK_MAIL)
            self.browser.find_element(By.NAME, 'pass').send_keys(Config.FACEBOOK_PASSWORD)
            self.browser.find_element(By.NAME, 'login').click()
            return "Logged into Facebook"
        except Exception as e:
            return f"Error logging into Facebook: {e}"
            
    def login_instagram(self):
        if not Config.INSTAGRAM_MAIL or not Config.INSTAGRAM_PASSWORD:
            return "Instagram credentials not configured."
        if not self.open_browser(): return "Failed to open browser"
        try:
            self.browser.get("https://www.instagram.com/")
            time.sleep(3)
            self.browser.find_element(By.NAME, 'username').send_keys(Config.INSTAGRAM_MAIL)
            self.browser.find_element(By.NAME, 'password').send_keys(Config.INSTAGRAM_PASSWORD)
            # This selector is distinct to Instagram login forms usually
            self.browser.find_element(By.XPATH, "//button[@type='submit']").click()
            return "Logged into Instagram"
        except Exception as e:
            return f"Error logging into Instagram: {e}"

    def close(self):
        if self.browser:
            self.browser.quit()
