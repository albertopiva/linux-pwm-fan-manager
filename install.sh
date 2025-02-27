echo "Installing fan-manager"

if [[ $EUID -ne 0 ]]; then
   echo "This script must be run as root" 
   exit 1
fi

echo "Creating the directory .fan-manager..."
mkdir /home/$USER/.fan-manager

echo "Copying the files to the correct locations..."
# Copy the script file
cp files/fan-manager.sh /home/$USER/.fan-manager/fan-manager.sh
sudo chmod +x /home/$USER/.fan-manager/fan-manager.sh
# Copy the configuration file
cp files/fan-manager.conf /home/$USER/.fan-manager/fan-manager.conf

# Create the service
echo "Creating the service..."
sudo cp files/fan-manager.service /etc/systemd/system/fan-manager.service
sudo systemctl daemon-reload
sudo systemctl enable fan-manager.service
sudo systemctl start fan-manager.service