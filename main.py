"""HoneygainAutoClaim
@author : Fabian Roscher
@author : gorouflex
@license : MIT

Automatically claims the Lucky pot, achievements and it prints out current stats.
"""
# !/usr/bin/env python3
import configparser
import json
import logging
import os
import sys
import shutil
from configparser import ConfigParser
from getpass import getpass

import colorama
import requests
from colorama import Fore
from requests import Response

# Path to the token file, Config Folder
config_folder: str = 'Config'
token_file: str = f'{config_folder}/HoneygainToken.json'
config_path: str = f'{config_folder}/HoneygainConfig.toml'

# Creates a Logs folder
if not os.path.exists('Logs'):
    os.mkdir('Logs')

logging.basicConfig(filename='Logs/HoneygainAutoClaim.log', filemode='w', encoding='utf-8',
                    level=logging.INFO, format='%(levelname)s ' '%(asctime)s ' '%(message)s',
                    datefmt='%d/%m/%Y %H:%M:%S')

# Initialize Colorama for colored logging
colorama.init()

# Create a StreamHandler for printing logs to the console
console_handler = logging.StreamHandler()
console_handler.setLevel(logging.INFO)

# Add the console handler to the root logger
logging.getLogger().addHandler(console_handler)

# All color codes in shorter variables
WHITE = Fore.LIGHTWHITE_EX
YELLOW = Fore.LIGHTYELLOW_EX
RED = Fore.LIGHTRED_EX

config: ConfigParser = ConfigParser()

logging.info("%sStarted HoneygainAutoClaim!", WHITE)


def check_up_to_date_github() -> None:
    """
    This function checks if the environment is GitHub and checks for newer commits on the host
    that doesn't align with the latest commit of the original repo
    """
    if os.getenv('GITHUB_ACTIONS') == 'true':
        user_repo = os.getenv('GITHUB_REPOSITORY')
        original_repo = 'MrLoLf/HoneygainAutoClaim'
        user_url = f'https://api.github.com/repos/{user_repo}/commits?path=main.py'
        original_url = f'https://api.github.com/repos/{original_repo}/commits?path=main.py'
        user_response = requests.get(user_url, timeout=10000)
        original_response = requests.get(original_url, timeout=10000)
        # Checks if the response is valid.
        if user_response.status_code == 200 and original_response.status_code == 200:
            # Get the sha of the last user commit and the original repo and look if they are the
            # same if not tell the user to update.
            user_commit = user_response.json()[0]['sha']
            original_commit = original_response.json()[0]['sha']
            if user_commit == original_commit:
                logging.info('%sYour repo is up-to-date with the original repo', WHITE)
            else:
                logging.warning('%sYour repo is not up-to-date with the original repo', YELLOW)
                logging.warning('%sPlease update your repo to the latest commit to get new updates '
                                'and bug fixes', YELLOW)
        else:
            # The sites where not available
            logging.error('%sFailed to fetch commit information', RED)


def create_config() -> None:
    """
    Creates a config with default values.
    """
    logging.warning('%sGenerating new Config.', YELLOW)
    cfg: ConfigParser = ConfigParser()

    # Adding User section with email password and token, which is filled in afterward
    cfg.add_section('User')
    cfg.set('User', 'email', "")
    cfg.set('User', 'password', "")
    cfg.set('User', 'token', "")

    # Check if we are running via GitHub Actions or (Docker or via machine)
    if os.getenv('GITHUB_ACTIONS') == 'true':
        if os.getenv('IsJWT') == '1':
            token = os.getenv('JWT_TOKEN')
            cfg.set('User', 'token', f"{token}")
            cfg.set('User', 'IsJWT', '1')
        else:
            email = os.getenv('MAIL')
            password = os.getenv('PASS')
            cfg.set('User', 'email', f"{email}")
            cfg.set('User', 'password', f"{password}")
            cfg.set('User', 'IsJWT', '0')
    else:
        # Takes user input via commandline
        logging.info("%sPlease choose authentication method:", WHITE)
        logging.info("%s1. Using Token", WHITE)
        logging.info("%s2. Using Email and Password", WHITE)
        choice = input(WHITE + "Enter your choice (1 or 2): ")
        if choice == '1':
            token = input(WHITE + "Token: ")
            cfg.set('User', 'token', f"{token}")
            cfg.set('User', 'IsJWT', '1')
            os.environ['IsJWT'] = '1'
        elif choice == '2':
            email = input(WHITE + "Email: ")
            password = getpass(WHITE + "Password: ")
            cfg.set('User', 'email', f"{email}")
            cfg.set('User', 'password', f"{password}")
            cfg.set('User', 'IsJWT', '0')
        else:
            logging.error("%sWrong Input could not read it correctly. Try again!", RED)
            create_config()
    # Adding Settings section, which allows the user to disable the lucky pot or achievements.
    cfg.add_section('Settings')
    cfg.set('Settings', 'Lucky Pot', 'True')
    cfg.set('Settings', 'Achievements', 'True')

    # This section holds all urls which are required for the program to run. This is made so if
    # the project gets abandoned the user doesn't have to change them in code. Instead, they can be
    # changed in a config file, if the code would still work.
    cfg.add_section('Url')
    cfg.set('Url', 'login', 'https://dashboard.honeygain.com/api/v1/users/tokens')
    cfg.set('Url', 'pot', 'https://dashboard.honeygain.com/api/v1/contest_winnings')
    cfg.set('Url', 'balance', 'https://dashboard.honeygain.com/api/v1/users/balances')
    cfg.set('Url', 'achievements', 'https://dashboard.honeygain.com/api/v1/achievements/')
    cfg.set('Url', 'achievement_claim', 'https://dashboard.honeygain.com/api/v1/achievements/claim')

    # Write config to file
    with open(config_path, 'w', encoding='utf-8') as configfile:
        configfile.truncate(0)
        configfile.seek(0)
        cfg.write(configfile)


def check_config_integrity(conf: ConfigParser) -> None:
    """
    Checks if the config file, is not empty, and folder exists.
    """
    if not os.path.exists(config_folder):
        logging.warning('%sCreating config folder!', YELLOW)
        os.mkdir(config_folder)

    # check if the config file exists and isn't empty if not create a new one
    if not os.path.isfile(config_path) or os.stat(config_path).st_size == 0:
        create_config()
        return

    # the user already has a config, so make sure the config file has all required sections.
    conf.read(config_path)
    if (not conf.has_section('User') or not conf.has_section('Settings')
            or not conf.has_section('Url')):
        create_config()


check_config_integrity(config)
# The user has a good enough config to work with, so load it
config.read(config_path)

is_jwt = config.get('User', 'IsJWT', fallback='0')


def get_urls(cfg: ConfigParser) -> dict[str, str]:
    """
    :param cfg: config object that contains the config
    :return: a dictionary with all urls of the config
    """
    urls_conf: dict[str, str] = {}
    try:
        urls_conf: dict[str, str] = {'login': cfg.get('Url', 'login'),
                                     'pot': cfg.get('Url', 'pot'),
                                     'balance': cfg.get('Url', 'balance'),
                                     'achievements': cfg.get('Url', 'achievements'),
                                     'achievement_claim': cfg.get('Url', 'achievement_claim')}
    except configparser.NoOptionError:
        create_config()
    except configparser.NoSectionError:
        create_config()
    return urls_conf


def get_login(cfg: ConfigParser) -> dict[str, str]:
    """
        :param cfg: config object that contains the config
        :return: a dictionary with all user information of the config
        """
    user: dict[str, str] = {}
    try:
        if is_jwt == '1':
            token = cfg.get('User', 'token')
            user: dict[str, str] = {'token': token}
        else:
            user: dict[str, str] = {'email': cfg.get('User', 'email'),
                                    'password': cfg.get('User', 'password')}
    except configparser.NoOptionError:
        create_config()
    except configparser.NoSectionError:
        create_config()
    return user


def get_settings(cfg: ConfigParser) -> dict[str, bool]:
    """
        :param cfg: config object that contains the config
        :return: a dictionary with all settings of the config
        """
    settings_dict: dict[str, bool] = {}
    try:
        settings_dict: dict[str, bool] = {'lucky_pot': cfg.getboolean('Settings', 'Lucky Pot'),
                                          'achievements_bool': cfg.getboolean('Settings',
                                                                              'Achievements')}
    except configparser.NoOptionError:
        create_config()
    except configparser.NoSectionError:
        create_config()
    return settings_dict


# Try to get info of the config file. If it fails for some reason create a new config and try again.
try:
    # Settings
    settings: dict[str, bool] = get_settings(config)
    # Urls
    urls: dict[str, str] = get_urls(config)
    # User credentials
    payload: dict[str, str] = get_login(config)

except configparser.NoOptionError:
    # Creating a new config if the there were some changes in the config file
    create_config()

except configparser.NoSectionError:
    # Creating a new config if the there were some changes in the config file
    create_config()

finally:
    # Settings
    settings: dict[str, bool] = get_settings(config)
    # Urls
    urls: dict[str, str] = get_urls(config)
    # User credentials
    payload: dict[str, str] = get_login(config)


def login(s: requests.session) -> json.loads:
    """
    Gets the new token with login data.
    :param s: currently used session
    :return: json containing the new token
    """
    logging.warning('%sLogging in to Honeygain!', YELLOW)

    if is_jwt == '1':
        return {'data': {'access_token': payload['token']}}
    token: Response = s.post(urls['login'], json=payload)
    try:
        return json.loads(token.text)
    except json.decoder.JSONDecodeError:
        logging.error('%s You have exceeded your login tries.\n\nPlease wait a few hours or '
                      'return tomorrow.', RED)
        sys.exit(-1)


def gen_token(s: requests.session, invalid: bool = False) -> str | None:
    """
    Gets the token from the HoneygainToken.json if existent and valid, if not generates a new one.
    :param s: currently used session
    :param invalid: true if the token read before was invalid
    :return: string containing the token
    """
    # Creating token.json if not existent
    if not os.path.isfile(token_file) or os.stat(token_file).st_size == 0 or invalid:
        logging.warning('%sGenerating new Token!', YELLOW)

        # Generating new token if the file is empty or is invalid
        with open(token_file, 'w', encoding='utf-8') as f:
            # Remove what ever was in the file and jump to the beginning
            f.truncate(0)
            f.seek(0)

            # Get json with the token
            token: dict = login(s)

            # Check if token is valid and doesn't have false credentials in it.
            if "title" in token:
                logging.error('%sWrong Login Credentials. Please enter the right ones.', RED)
                return None
            # Write the token to the token file
            json.dump(token, f)

    # Reading the token from the file
    with open(token_file, 'r+', encoding='utf-8') as f:
        token: dict = json.load(f)

    # get the token
    return token["data"]["access_token"]


def achievements_claim(s: requests.session, header: dict[str, str]) -> bool:
    """
    function to claim achievements
    """
    # If the user disabled achievement claiming return False
    if not settings['achievements_bool']:
        return False

    # Get all achievements
    achievements: Response = s.get(urls['achievements'], headers=header)
    achievements: dict = achievements.json()

    # Check if the get is successful
    if 'data' not in achievements:
        return False

    # Loop over all achievements and claim them.
    for achievement in achievements['data']:
        # This checks if the achievment has progress and if it does do the check on elif
        # otherwise try to claim it.
        if (not achievement['is_claimed'] and 'progresses' in achievement and
                achievement['progresses'] == []):

            # This trys to claim the achievment when no progress bar is present
            s.post(urls['achievement_claim'],
                   json={"user_achievement_id": achievement['id']},
                   headers=header)
            logging.info(f'%sTrying to claim {achievement["title"]}.', WHITE)

        # If the progress is complete and the achievement isn't claimed do so.
        elif (not achievement['is_claimed'] and 'progresses' in achievement and
              not achievement['progresses'] == [] and
              achievement['progresses'][0]['current_progress'] ==
              achievement['progresses'][0]['total_progress']):

            # This claims the achievment if the progress is complete
            s.post(urls['achievement_claim'],
                   json={"user_achievement_id": achievement['id']},
                   headers=header)
            logging.info(f'%sClaimed {achievement["title"]}.', WHITE)

    # Tried to claim achievements successfully
    return True


def main() -> None:
    """
    Automatically claims the Lucky pot and prints out current stats.
    """

    check_up_to_date_github()

    # Starting a new session
    with requests.session() as s:
        token: str = gen_token(s)

        if token is None:
            logging.info("%sClosing HoneygainAutoClaim! Due to false login Credentials.", WHITE)
            sys.exit(-1)

        # Header for all further requests
        header: dict[str, str] = {'Authorization': f'Bearer {token}'}

        if not achievements_claim(s, header):
            logging.error('%sFailed to claim achievements.', RED)

        # Check if the token is valid by trying to get the current balance with it
        dashboard: Response = s.get(urls['balance'], headers=header)
        dashboard: dict = dashboard.json()
        if 'code' in dashboard and dashboard['code'] == 401:
            logging.error('%sInvalid token generating new one.', RED)
            token: str = gen_token(s, True)
            header['Authorization'] = f'Bearer {token}'

        # Gets the pot winning credits
        pot_winning: Response = s.get(urls['pot'], headers=header)
        pot_winning: dict = pot_winning.json()
        # Check if the response is valid if not close the program
        if 'data' not in pot_winning:
            logging.error('%sYour login credentials might be false, make sure to they are right '
                          'and try again.', RED)
            sys.exit(-1)
        # Checks if the user wants to claim the lucky pot and do so if the pot isn't claimed yet.
        if settings['lucky_pot'] and pot_winning['data']['winning_credits'] is None:
            # The post below sends the request, so that the pot claim gets made.
            pot_claim: Response = s.post(urls['pot'], headers=header)
            pot_claim: dict = pot_claim.json()

            # Check if the claim was successful, if not exit normally.
            if 'type' in pot_claim and pot_claim['type'] == 400:
                logging.error('%sYou don\'t have enough traffic shared yet to claim you reward. '
                              'Please try again later.', RED)
                return

            logging.info(f'%sClaimed {pot_claim["data"]["credits"]} Credits.', WHITE)

        # Gets the pot winning credits
        pot_winning: Response = s.get(urls['pot'], headers=header)
        pot_winning: dict = pot_winning.json()
        logging.info(f'%sWon today {pot_winning["data"]["winning_credits"]} Credits.', WHITE)

        # Gets the current balance
        balance: Response = s.get(urls['balance'], headers=header)
        balance: dict = balance.json()
        logging.info(f'%sYou currently have {balance["data"]["payout"]["credits"]} Credits.', WHITE)


if __name__ == '__main__':
    main()
    if os.getenv('GITHUB_ACTIONS') == 'true':
        try:
            shutil.rmtree(config_folder)
        # Cannot delete the Config folder for some reason then quit and tell users about that
        except shutil.Error:
            logging.error(
                '%sCannot delete Config folder, check if any programs are using it or not?', RED)
            exit(-1)
    logging.info('%sClosing HoneygainAutoClaim!', WHITE)
