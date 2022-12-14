#!/bin/bash

#update
sudo apt update

#instalar .Net
wget -O - https://raw.githubusercontent.com/pjgpetecodes/dotnet6pi/master/install.sh | sudo bash


#voy a la carpeta donde voy a alojar el servicio
cd /home/pi/

#descargo los archivos
sudo git clone https://github.com/Ansel-dal/DCMDigitalSignagev2

#doy permisos para crear dcmdigitalsignage.service 
sudo chmod ugo+rwx /etc/systemd/system/

#creo dcmdigitalsignage.service 
echo -e "[Unit]
Description=dcmdigitalsignage 
[Service]
 WorkingDirectory=/home/pi/DCMDigitalSignagev2
 ExecStart=/opt/dotnet/dotnet /home/pi/DCMDigitalSignagev2/DCMDigitalSignagev2.Server.dll
 Restart=always   
 SyslogIdentifier=dotnet-dcmdigitalsignage    
 User=root
 Environment=ASPNETCORE_ENVIRONMENT=Production 
[Install]
 WantedBy=multi-user.target

" >> /etc/systemd/system/dcmdigitalsignage.service

#creo servicio
sudo systemctl enable dcmdigitalsignage.service

#inico servicio
sudo systemctl start dcmdigitalsignage.service
