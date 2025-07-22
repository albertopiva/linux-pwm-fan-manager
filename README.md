# linux-fan-manager

This is a simple shell script to manage a PWM fan on Radxa Rock Pi 4SE with Linux. It is tested using the official Radxa Debian OS avilable here: https://docs.radxa.com/en/rock4/official-images

## Automatic install

Using the **install.sh** script you can easily set up all the needed files and service.

You may need to add the execution flag to the install and uninstall files. In order to do so, you can use the follwing code:

```shell
chmod +x install.sh

chmod +x uninstall.sh
```

## Manual install

Copy the shell script and make it executable if it is not.

```shell
cp files/fan-manager.sh /usr/local/bin/fan-manager.sh
sudo chmod +x /usr/local/bin/fan-manager.sh
```

Copy the fan config file, it has 4 levels of fan power (25%, 50%, 75% and 100%) and you can assign custom temperature values.

```shell
cp files/fan.conf /etc/fan.conf
```

Then you have to create the system service

```shell
sudo cp files/fan-manager.service /etc/systemd/system/fan-manager.service
```

reloading the **systemctl** service, it is able to see the new added service.

```shell
sudo systemctl daemon-reload
```

Finally you can add the service to the boot execution and start it.

```shell
sudo systemctl enable fan-manager.service
sudo systemctl start fan-manager.service
```

## Hardware

The PWM fan pin should be connected to pwm0, see [here](https://wiki.radxa.com/Rock4/hardware/gpio) the schematic.

Note that you should enable the pwm0 (for example using the command _rsetup_)
