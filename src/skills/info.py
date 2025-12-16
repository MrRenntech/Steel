import requests

class InfoSkills:
    def get_weather(self, city="New York"):
        try:
            # wttr.in is a simple weather service for text output
            url = f"https://wttr.in/{city}?format=%C+%t"
            response = requests.get(url)
            if response.status_code == 200:
                return f"The weather in {city} is {response.text.strip()}"
            else:
                return "Could not fetch weather data."
        except:
            return "Network error getting weather."

    def get_news(self):
        # Without an API key, getting real news is hard. 
        # We will return a placeholder or use a public RSS if needed.
        # For now, let's keep it simple.
        return "I cannot fetch live news without a configured NewsAPI key yet."
