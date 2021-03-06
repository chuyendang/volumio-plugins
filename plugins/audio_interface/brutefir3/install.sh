#!/bin/bash

echo "Installing brutefir dependencies"
echo "unload Loopback module if exists"
sudo rmmod snd_aloop
echo "remove previous configuration"
if [ ! -f "/data/configuration/audio_interface/brutefir/config.json" ];
	then
		echo "file doesn't exist, nothing to do"
	else
		echo "File exists removing it"
		sudo rm -Rf /data/configuration/audio_interface/brutefir
fi


sudo apt-get update
sudo apt-get -y install brutefir drc
		cp /data/plugins/audio_interface/brutefir/brutefir.service.tar /
		cd /
		sudo tar -xvf brutefir.service.tar
		rm /brutefir.service.tar

echo "creating filters folder and copying demo filters"
mkdir -m 777 /data/INTERNAL/Dsp
mkdir -m 777 /data/INTERNAL/Dsp/tools
mkdir -m 777 /data/INTERNAL/Dsp/filters
mkdir -m 777 /data/INTERNAL/Dsp/VoBAFfilters
mkdir -m 777 /data/INTERNAL/Dsp/filter-sources
mkdir -m 777 /data/INTERNAL/Dsp/target-curves
echo "copying demo flters"
cp /data/plugins/audio_interface/brutefir/filters/* /data/INTERNAL/Dsp/filters/
cp /data/plugins/audio_interface/brutefir/VoBAFfilters/* /data/INTERNAL/Dsp/VoBAFfilters
cp /data/plugins/audio_interface/brutefir/target-curves/* /data/INTERNAL/Dsp/target-curves/
cp /data/plugins/audio_interface/brutefir/filter-sources/* /data/INTERNAL/Dsp/filter-sources/
rm -Rf /data/plugins/audio_interface/brutefir/filters
rm -Rf /data/plugins/audio_interface/brutefir/VoBAFfilters
rm -Rf /data/plugins/audio_interface/brutefir/target-curves
rm -Rf /data/plugins/audio_interface/brutefir/filters-sources


echo "copying hw detection script"
# Find arch
cpu=$(lscpu | awk 'FNR == 1 {print $2}')
echo "Detected cpu architecture as $cpu"
if [ $cpu = "armv7l" ] || [ $cpu = "aarch64" ] || [ $cpu = "armv6l" ]
then
sudo cp /data/plugins/audio_interface/brutefir/c/hw_params_arm /data/plugins/audio_interface/brutefir/hw_params
sudo chmod +x /data/plugins/audio_interface/brutefir/hw_params
elif [ $cpu = "x86_64" ] || [ $cpu = "i686" ]
then
sudo cp /data/plugins/audio_interface/brutefir/c/hw_params_x86 /data/plugins/audio_interface/brutefir/hw_params
sudo chmod +x /data/plugins/audio_interface/brutefir/hw_params
else
        echo "Sorry, cpu is $cpu and your device is not yet supported !"
	echo "exit now..."
	exit -1
fi

#required to end the plugin install
echo "plugininstallend"
