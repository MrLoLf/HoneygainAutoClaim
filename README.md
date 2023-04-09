# HoneygainAutoClaim

HoneygainAutoClaim is a simple Python script that automatically claims your daily bonus from Honeygain. Honeygain is a 
service that allows you to earn passive income by sharing your internet connection with others. You can learn more 
about Honeygain [here](https://r.honeygain.me/ROSCH76C7D).


## Requirements
- Python 3


## Usage
1. Clone or download this repository.
2. Install the required modules with `pip install -r requirements.txt`
3. Run the script with `python3 main.py`
4. [Create a schedule](#Create-a-schedule) to run the program every day.
5. Enjoy your bonus!


## Disclaimer
This script is not affiliated with or endorsed by Honeygain. Use it at your own risk and responsibility. The author is not responsible for any consequences that may arise from using this script.

### Create a schedule

#### Linux

1. `crontab -e`
2. Add this line at the bottom `0 8 * * * python3 /absolut folder path/main.py` to run the script every day at 8:00 am.

#### Windows

1. Open the `Task Scheduler`
2. Create a new basic Task
3. Give the task a name
4. Choose a daily trigger
5. Select the time, when to run it
6. Select as action to start a program
7. Select the path to the main.py