#!/usr/bin/env python3
import configparser
import json
import os
import tempfile
from configparser import ConfigParser

import requests
from requests import Response
from getpass import getpass

# path to the token file
tmp_dir: str = tempfile.gettempdir()
token_file: str = os.path.join(tmp_dir, 'HoneygainToken.json')
config_path: str = os.path.join(tmp_dir, 'HoneygainConfig.toml')


def create_config() -> None:
    """
    Creates a config with default values.
    """
    cfg: ConfigParser = ConfigParser()

    cfg.add_section('user')
    email: str = input("Email: ")
    cfg.set('user', 'email', f'{email}')
    password: str = getpass()
    cfg.set('user', 'password', f"{password}")

    cfg.add_section('url')
    cfg.set('url', 'login', 'https://dashboard.honeygain.com/api/v1/users/tokens')
    cfg.set('url', 'pot', 'https://dashboard.honeygain.com/api/v1/contest_winnings')
    cfg.set('url', 'balance', 'https://dashboard.honeygain.com/api/v1/users/balances')
    cfg.set('url', 'achievements', 'https://dashboard.honeygain.com/api/v1/achievements/')
    cfg.set('ulr', 'achievment_claim', 'https://dashboard.honeygain.com/api/v1/achievements/claim')

    with open(config_path, 'w') as configfile:
        configfile.truncate(0)
        configfile.seek(0)
        cfg.write(configfile)


if not os.path.isfile(config_path) or os.stat(config_path).st_size == 0:
    create_config()

config: ConfigParser = ConfigParser()
config.read(config_path)
try:
    # urls to use
    url_login: str = config.get('url', 'login')
    url_pot: str = config.get('url', 'pot')
    url_current_balance: str = config.get('url', 'balance')
    url_achievements: str = config.get('url', 'achievements')
    url_achievment_claim: str = config.get('url', 'achievment_claim')

    # user credentials
    payload: dict[str | str] = {
        'email': config.get('user', 'email'),
        'password': config.get('user', 'password')
    }
except configparser.NoOptionError:
    create_config()
    url_login: str = config.get('url', 'login')
    url_pot: str = config.get('url', 'pot')
    url_current_balance: str = config.get('url', 'balance')
    url_achievements: str = config.get('url', 'achievements')
    url_achievment_claim: str = config.get('url', 'achievment_claim')

    # user credentials
    payload: dict[str | str] = {
        'email': config.get('user', 'email'),
        'password': config.get('user', 'password')
    }

# default login header
login_header: dict[str | str] = {
    'Host': 'dashboard.honeygain.com',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Content-Type': 'application/json',
    'Content-Length': '68',
    'Origin': 'https://dashboard.honeygain.com',
    'Connection': 'keep-alive',
    'Referer': 'https://dashboard.honeygain.com/login',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-GPC': '1',
    'TE': 'trailers'
}
header: dict[str | str] = {
    'Host': 'dashboard.honeygain.com',
    'User-Agent': 'Mozilla/5.0 (Windows NT 10.0; Win64; x64; rv:109.0) Gecko/20100101 Firefox/111.0',
    'Accept': 'application/json, text/plain, */*',
    'Accept-Language': 'en-US,en;q=0.5',
    'Accept-Encoding': 'gzip, deflate',
    'Origin': 'https://dashboard.honeygain.com',
    'Connection': 'keep-alive',
    'Referer': 'https://dashboard.honeygain.com/',
    'Sec-Fetch-Dest': 'empty',
    'Sec-Fetch-Mode': 'cors',
    'Sec-Fetch-Site': 'same-origin',
    'Sec-GPC': '1',
    'Content-Length': '0',
    'TE': 'trailers'
}


def login(s: requests.session) -> json.loads:
    """
    Gets the new token with login data.
    :param s: currently used session
    :return: json containing the new token
    """
    token: Response = s.post(url_login, json=payload, headers=login_header)
    try:
        return json.loads(token.text)
    except json.decoder.JSONDecodeError:
        print("You have exceeded your login tries.\n\nPlease wait a few hours or return tomorrow.")
        exit(-1)


def gen_token(s: requests.session, invalid: bool = False) -> str:
    """
    Gets the token from the HoneygainToken.json if existent and valid, if not generates a new one.
    :param s: currently used session
    :param invalid: true if the token read before was invalid
    :return: string containing the token
    """
    # creating token.json if not existent
    if not os.path.isfile(token_file) or os.stat(token_file).st_size == 0 or invalid:
        # generating new token if the file is empty or is invalid
        with open(token_file, 'w') as f:
            # remove what ever was in the file and jump to the beginning
            f.truncate(0)
            f.seek(0)
            # get json and write it to the file
            token: dict = login(s)
            json.dump(token, f)

    # reading the token from the file
    with open(token_file, 'r+') as f:
        token: dict = json.load(f)

    # get the token
    return token["data"]["access_token"]


def main() -> None:
    """
    Automatically claims the Lucky pot and prints out current stats.
    """
    # starting a new session
    with requests.session() as s:
        token: str = gen_token(s)
        # header for all further requests
        header['Authorization'] = f'Bearer {token}'

        dashboard: Response = s.get(url_current_balance, headers=header)
        dashboard: dict = dashboard.json()
        if 'code' in dashboard and dashboard['code'] == 401:
            print('Invalid token generating new one.')
            token: str = gen_token(s, True)
            header['Authorization'] = f'Bearer {token}'

        # The post below sends the request, so that the claim gets made
        pot_claim: Response = s.post(url_pot, headers=header)
        pot_claim: dict = pot_claim.json()
        # check for an invalid token
        print(pot_claim)

        achievements: Response = s.get(url_achievements, headers=header)
        achievements: dict = achievements.json()
        for achievment in achievements['data']:
            if achievment['progresses']['current_progress'] == achievment['progresses']['total_progress:'] and not achievment['is_claimed']:
                print(f'Claimed {achievment["title"]}')
                s.post(url_achievment_claim, json={"user_achievement_id": achievment['id']}, headers=header)

        # gets the pot winning credits
        pot_winning: Response = s.get(url_pot, headers=header)
        pot_winning: dict = pot_winning.json()
        print(pot_winning)

        # gets the current balance
        balance: Response = s.get(url_current_balance, headers=header)
        balance: dict = balance.json()
        print(balance)


if __name__ == '__main__':
    main()
