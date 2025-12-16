import wikipedia
import wolframalpha
import smtplib
import webbrowser
import datetime
import os
import subprocess
from src.core.config_loader import Config

class BasicSkills:
    def __init__(self):
        self.wolfram_client = wolframalpha.Client(Config.WOLFRAM_ALPHA_APP_ID)

    def get_time_greeting(self):
        currentH = int(datetime.datetime.now().hour)
        if currentH >= 0 and currentH < 12:
            return 'Good Morning!'
        if currentH >= 12 and currentH < 18:
            return 'Good Afternoon!'
        if currentH >= 18 and currentH != 0:
            return 'Good Evening!'
        return "Hello!"

    def search_wikipedia(self, query):
        try:
            results = wikipedia.summary(query, sentences=2)
            return results
        except:
            return "Could not find that on Wikipedia."

    def query_wolfram(self, query):
        try:
            res = self.wolfram_client.query(query)
            results = next(res.results).text
            return results
        except:
            return None

    def send_email(self, recipient, content):
        try:
            server = smtplib.SMTP('smtp.gmail.com', 587)
            server.ehlo()
            server.starttls()
            server.login(Config.MAIL_EMAIL, Config.MAIL_PASSWORD)
            server.sendmail(Config.MAIL_EMAIL, recipient, content)
            server.close()
            return "Email sent successfully."
        except Exception as e:
            return f"Failed to send email: {e}"

    def open_website(self, url):
        webbrowser.open(url)
        return f"Opening {url}"

    def launch_app(self, app_name):
        app_name = app_name.lower()
        try:
            if "notepad" in app_name:
                subprocess.Popen(["notepad.exe"])
                return "Opening Notepad"
            elif "calculator" in app_name:
                subprocess.Popen(["calc.exe"])
                return "Opening Calculator"
            elif "chrome" in app_name:
                subprocess.Popen(["start", "chrome"], shell=True)
                return "Opening Chrome"
            # Add more specific paths if needed
            else:
                 return f"I don't know the path for {app_name}"
        except Exception as e:
            return f"Error launching {app_name}: {e}"
