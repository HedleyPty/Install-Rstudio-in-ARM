#!/bin/bash
#This script installs R and builds RStudio Desktop for ARM Chromebooks running Ubuntu 14.04

#Install R
export owner="$(whoami)" 
echo "deb http://httpredir.debian.org/debian/ sid main non-free contrib" |sudo tee -a /etc/apt/source.tmp
echo "deb-src http://httpredir.debian.org/debian/ sid main non-free contrib"|sudo tee -a /etc/apt/source.tmp
sudo mv /etc/apt/sources.list /etc/apt/tmp
sudo mv /etc/apt/source.tmp /etc/apt/sources.list


sudo apt-get update
sudo apt-get install -y r-base r-base-dev
sudo mv /etc/apt/tmp /etc/apt/sources.list
sudo apt-get update

#Download RStudio source
#Set RStudio version
VERS=v1.0.136
#0.98.982
cd
wget https://github.com/rstudio/rstudio/tarball/$VERS
mkdir rstudio-$VERS && tar xvf $VERS -C rstudio-$VERS --strip-components 1
rm $VERS

#Install RStudio build dependencies
sudo apt-get install -y git
sudo apt-get install -y build-essential pkg-config fakeroot cmake ant 
#libjpeg62
sudo apt-get install -y uuid-dev libssl-dev libbz2-dev zlib1g-dev libpam-dev
sudo apt-get install -y libapparmor1 apparmor-utils libboost-all-dev libpango1.0-dev
sudo apt-get install -y openjdk-7-jdk
sudo apt-get install -y cabal-install
sudo apt-get install -y ghc
sudo apt-get install qtbase5-dev -y
sudo apt-get install -y libqt5webkit5-dev qtpositioning5-dev libqt5sensors5-dev libqt5svg5-dev libqt5xmlpatterns5-dev
sudo apt-get install -y pandoc  texlive-extra-utils 
#Changing permissions of the file
sudo chown $owner:root -R rstudio-$VERS
arm_lib="$(ls /usr/lib |grep ^arm)"
qmake_bin="\/usr\/lib\/$arm_lib\/qt5\/bin\/qmake"
sed -i "s/get_filename.*/get_filename(QT_BIN_DIR $qmake_bin PATH)/" rstudio-$VERS/src/cpp/desktop/CMakeLists.txt

#Run common environment preparation scripts

cd rstudio-$VERS/dependencies/common/
mkdir ~/rstudio-$VERS/dependencies/common/pandoc
cd ~/rstudio-$VERS/dependencies/common/
./install-gwt
./install-dictionaries
./install-mathjax
./install-libclang
./install-packages

#Get Closure Compiler and replace compiler.jar
#cd
#wget http://dl.google.com/closure-compiler/compiler-latest.zip
#unzip compiler-latest.zip
#rm COPYING README.md compiler-latest.zip
#sudo mv closure-compiler*.jar ~/rstudio-$VERS/src/gwt/tools/compiler/compiler.jar

#Configure cmake and build RStudio
cd ~/rstudio-$VERS/
mkdir build
sudo cmake -DRSTUDIO_TARGET=Desktop -DCMAKE_BUILD_TYPE=Release
sudo make install

#Clean the system of packages used for building
#cd
#sudo apt-get autoremove -y cabal-install ghc pandoc libboost-all-dev
#sudo rm -r -f rstudio-$VERS
#sudo apt-get autoremove -y
