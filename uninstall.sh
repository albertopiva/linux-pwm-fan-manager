echo "Uninstall fan-manager"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

# Remove the service
echo "Remove the service..."
sudo systemctl stop fan-manager.service
sudo rm /etc/systemd/system/fan-manager.service
sudo systemctl daemon-reload

echo "Remove the directory .fan-manager..."
sudo rm -R /home/$USER/.fan-manager