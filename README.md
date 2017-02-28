# Install-Rstudio-in-ARM
I created this repository in order to install R studio in ARM. I modified the ARM script provided by https://github.com/dashaub/ARM-RStudio in order to get the latest version or RStudio desktop. I have tested it on a sid debian. 

#Changes to the file provided by dashaub/ARM-RStudio

1. I modify the /etc/apt/sources.list in order to the get the latest version of R
2. I omit the installation of qt-sdk, but I installed the needed components of the qt requested by cmake
3. I omit the installation of boost provided by rstudio repository, it is outdated and I render to error while compiling
3. I add the installation of libclang provided by rstudio repository 
3. I modify a line of the file ...

Enjoy the latest version of RStudio in R
