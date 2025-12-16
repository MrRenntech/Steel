import os
from dotenv import load_dotenv

# Load environment variables from .env file
load_dotenv()

class Config:
    # Credentials
    MAIL_EMAIL = os.getenv('MAIL_EMAIL')
    MAIL_PASSWORD = os.getenv('MAIL_PASSWORD')
    MAIL_SEND = os.getenv('MAIL_SEND')

    FACEBOOK_MAIL = os.getenv('FACEBOOK_MAIL')
    FACEBOOK_PASSWORD = os.getenv('FACEBOOK_PASSWORD')

    NETFLIX_LOGIN = os.getenv('NETFLIX_LOGIN')
    NETFLIX_PASSWORD = os.getenv('NETFLIX_PASSWORD')

    INSTAGRAM_MAIL = os.getenv('INSTAGRAM_MAIL')
    INSTAGRAM_PASSWORD = os.getenv('INSTAGRAM_PASSWORD')

    TWITTER_MAIL = os.getenv('TWITTER_MAIL')
    TWITTER_PASSWORD = os.getenv('TWITTER_PASSWORD')

    DISCORD_MAIL = os.getenv('DISCORD_MAIL')
    DISCORD_PASSWORD = os.getenv('DISCORD_PASSWORD')

    # API Keys
    WOLFRAM_ALPHA_APP_ID = os.getenv('WOLFRAM_ALPHA_APP_ID', 'T5JWT6-X8VXYT9KY5')

    # Paths
    CHROMEDRIVER_PATH = os.getenv('CHROMEDRIVER_PATH', 'chromedriver.exe')
    
    # Theme
    THEME = os.getenv('BS_THEME', 'dark')
