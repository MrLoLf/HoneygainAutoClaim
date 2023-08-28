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
- [Python 3](https://www.python.org/downloads/)  
  
  
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
  
1. Open the `Task Scheduler`  
2. Create a new **basic Task**  
3. Give the task a **name**  
4. Choose a **daily trigger**  
5. Select the **time**, when to run it  
6. Select as action to **start a program**  
7. Select the path to the **main.py**  
  
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
