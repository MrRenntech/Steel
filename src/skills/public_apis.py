import requests
import random

class PublicSkills:
    def get_crypto_price(self, coin_id="bitcoin"):
        try:
            # CoinGecko free API
            url = f"https://api.coingecko.com/api/v3/simple/price?ids={coin_id}&vs_currencies=usd"
            response = requests.get(url, timeout=5)
            data = response.json()
            if coin_id in data:
                price = data[coin_id]['usd']
                return f"The current price of {coin_id} is ${price}."
            return f"Could not find price for {coin_id}."
        except Exception as e:
            return "Could not fetch crypto prices."

    def get_joke(self):
        try:
            # Official Joke API
            url = "https://official-joke-api.appspot.com/random_joke"
            response = requests.get(url, timeout=5)
            data = response.json()
            return f"{data['setup']} ... {data['punchline']}"
        except:
            return "Why did the chicken cross the road? To get to the other side."

    def get_definition(self, word):
        try:
            url = f"https://api.dictionaryapi.dev/api/v2/entries/en/{word}"
            response = requests.get(url, timeout=5)
            if response.status_code == 200:
                data = response.json()
                definition = data[0]['meanings'][0]['definitions'][0]['definition']
                return f"{word}: {definition}"
            return f"I couldn't define {word}."
        except:
            return "Dictionary is unavailable."
