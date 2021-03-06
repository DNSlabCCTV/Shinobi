<html>
  
  
# Shinobi
## Features
Time-lapse Viewer (Watch a hours worth of footage in a few minutes)</br>
</br>
Records IP Cameras and Local Cameras</br>
Streams by WebSocket, HLS (includes audio), and MJPEG</br>
Save to WebM and MP4 - Can save Audio</br>
</br>
Push Events - When a video is finished it will appear in the dashboard without a refresh</br>
1 Process for Each Camera to do both, Recording and Streaming</br>
Cron Filters can be set based on master account</br>
</br>
## Docker Container & Addtional Function & Modify
### To use docker : 
<code>sudo apt install git</code></br>
<code>git clone https://gitlab.com/Shinobi-Systems/ShinobiDocker.git ShinobiDocker && cd ShinobiDocker</code></br>
<code>apt install docker-compose</code></br>
<code>sh start-image.sh</code></br>

Web Address : http://xxx.xxx.xxx.xxx:8080/super</br>

### After config:
<code>sudo rm -rf ~/ShinobiDocker </code></br>
<code>docker stop shinobidocker_shinobi_1 </code></br>
<code>docker rm shinobidocker_shinobi_1 </code></br>
<code>docker rmi shinobidocker_shinobi </code></br>
<code>git clone https://gitlab.com/Shinobi-Systems/ShinobiDocker.git ShinobiDocker && cd ShinobiDocker </code></br>
<code>cd ~/ShinobiDocker</code></br>
<code>rm Dockerfile docker-compose.yml docker-entrypoint.sh pm2Shinobi.yml</code></br>
<code>cd ~</code></br>
<code>mkdir test</code></br>
<code>cd test</code></br>
<code>git clone https://github.com/DNSlabCCTV/Shinobi </code></br>
<code>cp ~/test/Shinobi/Dockerfile ~/ShinobiDocker</code></br>
<code>cp ~/test/Shinobi/docker-compose.yml ~/ShinobiDocker</code></br>
<code>cp ~/test/Shinobi/docker-entrypoint.sh ~/ShinobiDocker</code></br>
<code>cp ~/test/Shinobi/pm2Shinobi.yml ~/ShinobiDocker</code></br>
<code>cp -rf ~/test/Shinobi/cascades ~/ShinobiDocker</code></br>
<code>cd ~/ShinobiDocker</code></br>
<code>sh start-image.sh</code></br>

##### ■ Default Login</br>
[ docker-entrypoint.sh ]</br>
<code>mysql -u root <  /opt/shinobi/sql/framework.sql</code></br>
<code>mysql --user=root ccio < /opt/shinobi/sql/default_data.sql</code></br>
<code>mysql -u root --password="" <<-EOSQL</code></br>
<code>INSERT INTO mysql.user (host,user,authentication_string,ssl_cipher, x509_issuer, x509_subject) VALUES ('%','root',password(''),'','','');</code></br>
<code>GRANT ALL PRIVILEGES ON *.* TO 'root'@'%';</code></br>
<code>FLUSH PRIVILEGES;</code></br>
<code>EOSQL</code></br>

##### ■ Plus Motion Detection</br>
![Motion Detection](motion.png)</br>
[ Dockerfile ]</br>
[ pm2Shinobi.yml ]</br>

## Test API
![아키텍쳐](testapi.PNG)</br>
##### ■ Add Cameras in Node.JS
Use Shinobi.ShinobiSetup Function

##### ■ Delete Cameras in Node.JS
Use Shinobi.ShinobiDeleteMonitor Function

## link
https://shinobi.video/docs/start</br>
https://gitlab.com/Shinobi-Systems/Shinobi</br>
</br>
</html>
