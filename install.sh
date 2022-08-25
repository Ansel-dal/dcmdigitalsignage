#!/bin/bash

#update
sudo apt update

#instalar .Net
curl -sSL https://dot.net/v1/dotnet-install.sh | bash /dev/stdin --channel Current

#crear la carpeta del servicio
sudo mkdir [direccion]

#voy a la carpeta del serivicio
sudo cd [direccion]

#descargo los archivos
sudo git clone --bare https://github.com/Ansel-dal/DCMDigitalSignagev2.git

#creo dcmdigitalsignage.service 
echo -e "[Unit]
Description=dcmdigitalsignage 
[Service]
 WorkingDirectory=[direccion]
 ExecStart=/opt/dotnet/dotnet [direccion]
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

