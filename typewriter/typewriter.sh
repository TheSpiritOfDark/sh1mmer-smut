#!/bin/bash

if [ "$EUID" -ne 0 ]; then
	echo "Please run as root"
	exit 1
fi

echo "Welcome to typewriter.sh, a SMUT shim-building automation tool"
echo "Made by rainestorme"

echo "Before you start, confirm that you have the following files in the /typewriter folder:"
echo " - raw_shim.bin - your raw shim for the board you want to build for"
echo " - reco_image.bin - your v105 recovery image for the board you want to build for"
echo "Also make sure this script was run as root!"
echo " Press enter to continue, Ctrl+C to exit"
read -r

echo "Copying reco image (this will take a while)..."
cp ./reco_image.bin ./murkmod_image.bin

echo "Patching murkmod reco image..."
./image_patcher.sh ./murkmod_image.bin

echo "Moving reco images to smut-reco payloads folder..."
mkdir -p ../wax/smut-reco
mv ./murkmod_image.bin ../wax/smut-reco/murkmod.bin
mv ./reco_image.bin ../wax/smut-reco/recovery.bin

echo "Moving shim to wax folder..."
mv ./raw_shim.bin ../wax/raw_shim.bin

echo "Building shim (this will take a while)..."
pushd ../wax/
    wget https://dl.sh1mmer.me/build-tools/chromebrew/chromebrew-dev.tar.gz
    bash wax.sh $(pwd)/raw_shim.bin --dev
popd

mv ../wax/raw_shim.bin ./sh1mmer_smut.bin

echo "Everything should be done, your new shim should be located in the /typewriter directory!"
