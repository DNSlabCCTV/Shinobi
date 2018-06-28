<html>
  
  
# Shinobi

## Installation
In Ubuntu 16.04:</br>
<code>sudo su</code></br>
<code>apt install git -y</code></br>
<code>git clone https://gitlab.com/Shinobi-Systems/Shinobi.git Shinobi</code></br>
<code>cd Shinobi</code>
<code>chmod +x INSTALL/ubuntu.sh && INSTALL/ubuntu.sh</code></br>
Shinobi does some of his own questions.</br>
Shinobi - Do you want to enable superuser access?</br>
Shinobi - Do you want to Install FFMPEG?</br>
Shinobi - Do you want to use MariaDB or SQLite3?</br>
Shinobi - Do you want to Install MariaDB? Choose No if you already have it.</br>
Shinobi - Database Installation</br>
Shinobi - Start Shinobi and set to start on boot?</br>
</br>
To update Shinobi with git and restart :</br>
<code>cd Shinobi</code></br>
<code>git pull</code></br>
<code>pm2 restart camera.js</code></br>
<code>pm2 restart cron.js</code></br>
</br>
http://localhost:8080/</br>
</br>
To use docker:</br> 
<code>sudo apt install git</code></br>
<code>git clone https://gitlab.com/Shinobi-Systems/ShinobiDocker.git ShinobiDocker && cd ShinobiDocker</code></br>
<code>apt install docker-compose</code></br>
<code>sh start-image.sh</code></br>

Web Address : http://xxx.xxx.xxx.xxx:8080/super</br>
## link
https://shinobi.video/docs/start</br>
https://gitlab.com/Shinobi-Systems/Shinobi</br>
</br>
</html>
