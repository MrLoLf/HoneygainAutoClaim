# HoneygainAutoClaim

HoneygainAutoClaim is a simple [Python](https://www.python.org/) script that **automatically claims your daily bonus** 
and **achievements** from [Honeygain](https://r.honeygain.me/ROSCH76C7D). Honeygain is a 
service that allows you to earn **passive income** by **sharing** your **internet** connection with others.

## List of Content

- [Installation/Usage](#usage)
- [Creating a schedule](#create-a-schedule)
- [Config changes](#config)

## Requirements
- [Python 3](https://www.python.org/downloads/)


## Usage
- **Clone** or **download** this repository. 
- Navigate in to the directory `HoneyGainAutoClaim`
- Install the **required** modules with 
```commandline 
python3 -m pip install -r requirements.txt
```  
- Run the script with 
```commandline
python3 /absolut folder path/main.py
```
- [Create a schedule](#create-a-schedule) to run the program every day.
- Enjoy your **daily bonus**!


## Disclaimer
This script is **not** affiliated with or endorsed by Honeygain. Use it at your **own risk** and responsibility. The **author** is **not responsible** for any consequences that may arise from using this script.

### Create a schedule

#### Linux

1. ```commandline
   crontab -e
   ```
2. Add this line at the **bottom** `0 8 * * * python3 /absolut folder path/main.py` to run the script every day at 8:00 am.

#### Windows

1. Open the `Task Scheduler`
2. Create a new **basic Task**
3. Give the task a **name**
4. Choose a **daily trigger**
5. Select the **time**, when to run it
6. Select as action to **start a program**
7. Select the path to the **main.py**

## Config

### Windows

- Open the folder where the main.py is being located
- Navigate in to Config
- Open the file `HoneygainConfig.toml`

### Linux

- ```commandline
  nano /absoulut folder path/HoneyGainAutoClaim/Config/HoneygainConfig.toml
  ```
