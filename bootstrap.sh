#!/usr/bin/env bash


#########################################################
# Source https://mailinabox.email/ https://github.com/mail-in-a-box/mailinabox
# Updated by cryptopool.builders for crypto use...
# This script is intended to be run like this:
#
#   curl https://raw.githubusercontent.com/cryptopool-builders/Multi-Pool-Installer/master/bootstrap.sh | bash
#
#########################################################
if [ -z "${TAG}" ]; then
	TAG=v2.55
fi


# Clone the MultiPool repository if it doesn't exist.
if [ ! -d $HOME/multipool ]; then
	if [ ! -f /usr/bin/git ]; then
		echo Installing git . . .
		apt-get -q -q update
		DEBIAN_FRONTEND=noninteractive apt-get -q -q install -y git < /dev/null
		echo
	fi

	echo Downloading MultiPool Installer ${TAG}. . .
	git clone \
		-b ${TAG} --depth 1 \
		https://github.com/cryptopool-builders/multipool_setup \
		"$HOME"/multipool/install \
		< /dev/null 2> /dev/null

	echo
fi

# Set permission and change directory to it.
cd $HOME/multipool/install

# Update it.
sudo chown -R $USER $HOME/multipool/install/.git/
if [ "${TAG}" != `git describe --tags` ]; then
	echo Updating MultiPool Installer to ${TAG} . . .
	git fetch --depth 1 --force --prune origin tag ${TAG}
	if ! git checkout -q ${TAG}; then
		echo "Update failed. Did you modify something in `pwd`?"
		exit
	fi
	echo
fi

# Start setup script.
bash $HOME/multipool/install/start.sh
