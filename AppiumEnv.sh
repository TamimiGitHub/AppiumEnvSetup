#!/bin/bash

#This script is used to setup the machine environment with the right setup before running any 
#appium related activities 

### HOW TO ###
# 1. Open Terminal
# 2. Navigate to directory where the script was downloaded in `cd ~/Downloads`
# 3. Make this script executable by typing `sudo chmod +x AppiumEnv.sh` from your terminal
# 4. Run script by typing `./AppiumEnv.sh`


##Functions used in script
addAlias (){
	echo " " >> $1 #to fix eol issue
    echo "alias xcode7='sudo xcode-select -s /Applications/Xcode7.app'" >> $1
    echo "alias xcode8='sudo xcode-select -s /Applications/Xcode.app'" >> $1
    echo "alias xcv='xcodebuild -version'" >> $1
}

aliasExist (){
	grep -E "sudo xcode-select -s |sudo xcode-select --switch | xcode-select -p" "$1"> /dev/null
}

setAlias (){
	if [ -f ~/.profile ]; then
		if ! aliasExist ~/.profile ; then
			addAlias ~/.profile
			source ~/.profile
		fi
	else
		if ! aliasExist ~/.bash_profile; then
			addAlias ~/.bash_profile
			source ~/.bash_profile
		fi
	fi
	echo "Aliases are set. To switch between Xcode 7 and 8 just type 'xcode7' or 'xcode8'"
	echo "The current running xcode version is ('xcodebuild -version'): "
	xcodebuild -version
}

#Obselete
installCapsUtil (){ #temp. TODO: replace with 'sudo gem install yi_appium_caps_util -n /usr/local/bin' once gem is published
	git clone https://github.com/YOU-i-Labs/yi_appium_caps_util
	cd yi_appium_caps_util
	gem build yi_appium_caps_util.gemspec
	sudo gem install yi_appium_caps_util-1.0.0.gem
	cd ../
	rm -fr yi_appium_caps_util
}

##Checking if xcode developer tools are installed
if ! [ -d /Applications/Xcode.app/Contents/Developer ] || ! [ -d /Library/Developer/CommandLineTools ]
then
     echo "installing xcode dev tools..."
     xcode-select --install
fi
echo "**Xcode Dev Tools installed**"-

##Checking if brew is installed
if ! type "brew" > /dev/null; then
	ruby -e "$(curl -fsSL https://raw.githubusercontent.com/Homebrew/install/master/install)"
fi
echo "**Homebrew installed**"

##Checking if ruby is installed
if ! type "rbenv" > /dev/null; then
    echo "Installing ruby..."
	brew install rbenv
	brew install ruby-build
	eval "$(rbenv init -)"
	rbenv install 2.2.3
	rbenv rehash
	rbenv global 2.2.3
	sudo gem install ruby_protobuf -n/usr/local/bin
fi
echo "**rbenv installed**"

curVersion=$(rbenv version | awk {'print $1}')
minVersion=$"2.2.0"

##Updating ruby to a newer version if user's version is out of date
if [[ "$curVersion" < "$minVersion" ]]
then
    echo "updating brew..."
    brew update
    echo "Ruby version updating to 2.2.3..."
    rbenv install 2.2.3
    rbenv rehash
    rbenv global 2.2.3
fi
echo "**Ruby is up-to-date**"

##Checking if node is installed
if ! type "node" > /dev/null; then
	brew install node 
fi
echo "**Node.js installed**"

##Checking if appium is installed
if ! type "appium" > /dev/null; then
	npm install -g appium@1.6
fi
version=$(npm view appium version)
echo "**Appium server installed. Version $version**"

#The following gems are needed for the ruby client

##Checking if bundler gem is installed
if ! gem list bundler -i > /dev/null ;then
	sudo gem install bundler -n /usr/local/bin
fi
echo "**Bundler installed**"

##Checking if appium_lib gem is installed
if ! gem list appium_lib -i > /dev/null; then
	sudo gem install appium_lib -n /usr/local/bin
fi
echo "**appium_lib installed**"

##Checking if appium_console gem is installed
if ! gem list appium_console -i > /dev/null; then
	sudo gem install appium_console -n /usr/local/bin
fi
echo "**appium_console installed**"

# The following are needed for the yi_appium_lib gem

##Checking if libimobiledevice is installed
if [ ! -z "$(brew ls --versions libimobiledevice)" ]; then
	echo "libimobiledevice installed"
else
	brew install libimobiledevice
fi

##Checking if ideviceinstaller is installed
if [ ! -z "$(brew ls --versions ideviceinstaller)" ]; then
	echo "ideviceinstaller installed"
else
	brew install ideviceinstaller
fi

##Checking if carthage is installed
if [ ! -z "$(brew ls --versions carthage)" ]; then
	echo "carthage installed"
else
	brew install carthage
fi

##Checking if ios-deploy is installed
if [ ! -z "$(brew ls --versions ios-deploy)" ]; then
	echo "ios-deploy installed"
else
	brew install ios-deploy
fi

##Checking if ipaddress gem is installed
if ! gem list ipaddress -i > /dev/null; then
	sudo gem install ipaddress -n /usr/local/bin
fi
echo "**ipaddress installed**"

##Checking if toml gem is installed
if ! gem list toml -i > /dev/null; then
	sudo gem install toml -n /usr/local/bin
fi
echo "**toml installed**"

##Checking if yi_appium_caps_util gem is installed
if ! gem list yi_appium_caps_util -i > /dev/null; then
	sudo gem install yi_appium_caps_util
	# installCapsUtil
fi

##Checking if rspec gem is installed
if ! gem list rspec -i > /dev/null; then
	sudo gem install rspec -n /usr/local/bin
fi
echo "**rspec installed**"

echo "**** Appium environment setup done ****"
echo "**** yi_appium_lib installed ****"

#Cheking if xcode7 is installed and setting aliases if installed
echo "."
echo "."
echo "Checking if Xcode7 is installed"
echo "."
echo "."
if [ ! -d /Applications/Xcode7.app ]; then
	echo -e "\033[1;31m Download xcode7! Please go to https://developer.apple.com/services-account/download?path=/Developer_Tools/Xcode_7.3.1/Xcode_7.3.1.dmg \033[0m"
	echo "After downloading Xcode 7, make sure its renamed to 'Xcode7' in your 'Applications' directory. Rerun the script after download"
else
	setAlias
fi
