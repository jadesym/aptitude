gh --version >/dev/null 2>&1

if [ $? -eq 0 ]  ; then
	echo >&2 "Github CLI is already installed. Aborting installation script...";
  exit 1;
else
  echo "Github CLI is not yet installed. Beginning installation script...";
fi

sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-key C99B11DEB97541F0
sudo apt-add-repository https://cli.github.com/packages
sudo apt update
sudo apt install gh

gh --version
