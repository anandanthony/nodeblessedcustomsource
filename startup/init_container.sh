#!/usr/bin/env bash
cat >/etc/motd <<EOL 
  _____                               
  /  _  \ __________ _________   ____  
 /  /_\  \\___   /  |  \_  __ \_/ __ \ 
/    |    \/    /|  |  /|  | \/\  ___/ 
\____|__  /_____ \____/ |__|    \___  >
        \/      \/                  \/ 
A P P   S E R V I C E   O N   L I N U X

Documentation: http://aka.ms/webapp-linux
NodeJS quickstart: https://aka.ms/node-qs
NodeJS Version : `node --version`

EOL
cat /etc/motd

mkdir "$PM2HOME"
chmod 777 "$PM2HOME"
ln -s /home/LogFiles "$PM2HOME"/logs

# Get environment variables to show up in SSH session
eval $(printenv | sed -n "s/^\([^=]\+\)=\(.*\)$/export \1=\2/p" | sed 's/"/\\\"/g' | sed '/=/s//="/' | sed 's/$/"/' >> /etc/profile)

# starting sshd process
sed -i "s/SSH_PORT/$SSH_PORT/g" /etc/ssh/sshd_config
/usr/sbin/sshd

#STARTUP_COMMAND_PATH="/opt/startup/"
#ORYX_ARGS="-appPath /home/site/wwwroot -output $STARTUP_COMMAND_PATH -usePM2 -defaultApp=/opt/startup/default-static-site.js -userStartupCommand '$@'"


file="/home/site/wwwroot/app.js"
if [ -f "$file" ]
then
	echo "$file found."
    eavl "node /home/site/wwwroot/app.js"
else
	echo "$file not found in /home/site/wwwroot."
fi

file="/opt/startup/default-static-site.js"
if [ -f "$file" ]
then
	echo "$file found."
    eval "node /opt/startup/default-static-site.js"
else
	echo "$file not found."
fi

echo "Running Node App"
