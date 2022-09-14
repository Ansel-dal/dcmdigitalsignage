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

#creo el script para reiniciar al detectar ping
echo -e "#!/bin/bash
host=192.168.2.178
ping_result="NOT_OK"
until ping -q -c 4 $host >/dev/null
do
echo "No hay conexión"
done
sudo systemctl restart dcmlocker.service
echo "reiniciado"


" >> /home/pi/Desktop/script.sh

sudo rm -r /etc/rc.local
#creo el nuevo archivo rc.local
echo -e "#!/bin/sh -e
#
# rc.local
#
# This script is executed at the end of each multiuser runlevel.
# Make sure that the script will "exit 0" on success or any other
# value on error.
#
# In order to enable or disable this script just change the execution
# bits.
#
# By default this script does nothing.

# Print the IP address
_IP=$(hostname -I) || true
if [ "$_IP" ]; then
  printf "My IP address is %s\n" "$_IP"
fi

bash /home/pi/Desktop/script.sh

exit 0



" >> /etc/rc.local


