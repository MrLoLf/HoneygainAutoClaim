# HoneygainAutoClaim  
[![CodeQL](https://github.com/MrLoLf/HoneygainAutoClaim/actions/workflows/github-code-scanning/codeql/badge.svg)](https://github.com/MrLoLf/HoneygainAutoClaim/actions/workflows/github-code-scanning/codeql)  
  
HoneygainAutoClaim is a simple [Python](https://www.python.org/) script that **automatically claims your daily bonus**  
and **achievements** from [Honeygain](https://r.honeygain.me/ROSCH76C7D). Honeygain is a  
service that allows you to earn **passive income** by **sharing** your **internet** connection with others.  
  
## Disclaimer  
This script is **not** affiliated with or endorsed by Honeygain. Use it at your **own risk** and responsibility.  
The **author** is **not responsible** for any consequences that may arise from using this script. If Honeygain wants me 
to delete this bot I'll do it.  

 
## List of Content  
  
- [Installation/Usage](#usage)  
- [Creating a schedule](#create-a-schedule)  
- [Config changes](#config)  
  
## Requirements  
- [Python 3.10 or higher](https://www.python.org/downloads/)  
  
  
## <a id='usage'></a>Usage  
  
### Windows/Linux  
- **Clone** or **download** this repository.
```commandline
git clone https://github.com/MrLoLf/HoneygainAutoClaim.git
```
- Navigate in to the directory `HoneygainAutoClaim`
```commandline
cd HoneygainAutoClaim
```
- Install the **required** modules with  
```commandline  
python3 -m pip install -r requirements.txt  
```  
- If you run the cron job it's recommended to navigate back to your home directory with:
```commandline
cd ~
```
- Run the script with  
```commandline  
python3 /absolut folder path/main.py  
```  
- [Create a schedule](#schedule-linux) to run the program every day.  
- Enjoy your **daily bonus**!  

### GitHub Actions  
### Benefits
- Run w/o PC,VPS,On the fly
- Keep your email and password safe with env secret from GitHub
- Automatically run everyday

### Usage

  1. [Fork this repository](https://github.com/MrLoLf/HoneygainAutoClaim/fork)  
  2. Go to your forked repository
  3. Go to Settings > Secrets and Variables > Actions. And click the button `New Repository secret`
  4. For the secret name, use `MAIL_JWD` to set your honeygain mail and `PASS_JWD` for your password
  5. Go to your forked repository and go to the Actions tab and press the button `I understand my workflows, go ahead and enable them`

![GitSettings](https://github.com/gorouflex/HoneygainPot/assets/98001973/d8d33621-5717-488d-9a80-6db395c8ac9d)

### How to change the schedule to fit with my timezone before the pot is reset?

- Well, GitHub uses UTC time (UTC +0) for scheduling workflows, so we should convert it to our timezone.

- For example: If I want to set the daily trigger to trigger at 9:00 PM (UTC +7), I have to set it to 2:00 PM or 14:00 (24-hour format) (UTC±0) (2+7=9).

```
name: Daily claim
on:
  schedule:
    - cron: '0 14 * * *' # <- UTC Time, replace 0 14
```
- So, if I want the daily trigger to run at 5:00 AM (UTC +7), I have to set it to 10:00 PM (UTC±0) (use 24-hour format):
```
name: Daily claim
on:
  schedule:
    - cron: '0 22 * * *' # UTC Time
```

### Docker  
- **Clone** or **download** this repository.
```commandline
git clone https://github.com/MrLoLf/HoneygainAutoClaim.git
```
- Navigate in to the directory `HoneygainAutoClaim`
```commandline
cd HoneygainAutoClaim
```  
- To build the Dockerfile run the command below:  
```commandline  
docker build -t honeygainautoclaim .
```  
- To run the docker container  
```commandline  
docker run -it --restart unless-stopped honeygainautoclaim  
```  
- [Create a schedule](#schedule-docker) to run the program every day.  
- Enjoy your **daily bonus**!  
  
### <a id='create-a-schedule'></a>Create a schedule  
  
#### <a id='schedule-linux'></a>Linux  
  
1.  
```commandline  
crontab -e  
```  
2. Add this line at the **bottom** `0 8 * * * python3 /absolut folder path/main.py` to run the script every day at 8:00 am.  
  
#### <a id='schedule-docker'></a>Docker 
  

  
1. You can find the docker container ID by running  
``` commandline  
docker ps -a  
```  
2.  
```commandline  
crontab -e  
```  
or the windows equivalent via the Task Scheduler.  
3. Add this line at the **bottom**   `0 8 * * * docker start <container_id> && docker stop <container_id>`. Make sure to replace <container_id> with the ID of your Docker container.
After adding the start command you have to stop the docker conatiner or it will run multiple times per minute.
  
  
#### Windows

1. Open Task Scheduler.
2. Click on Create Task.
3. Enter task name: “HoneygainAutoClaim”.
4. Switch to Triggers tab.
5. Click on New.
6. Select On a schedule.
7. Set start date to today, time to 8:00 AM.
8. Select Daily in Settings.
9. Click on OK.
10. Switch to Actions tab.
11. Click on New.
12. Select Start a program.
13. Enter path to Python executable e.g. C:\Python39\python.exe.
14. Enter path to e.g. C:\HoneygainAutoClaim\main.py script in Add arguments.
15. Click on OK.
  
## <a id='config'></a>Config  
  
### Windows  
  
- Open the folder where the main.py is being located  
- Navigate in to Config  
- Open the file `HoneygainConfig.toml`  
  
### Linux  
  
-
```commandline  
nano /absoulut folder path/HoneygainAutoClaim/Config/HoneygainConfig.toml  
```
