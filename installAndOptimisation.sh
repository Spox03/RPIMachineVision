purge=0
installdep=0
getOpenCV=0
getpip=0
buildOpenCV=0
finalizing=0
# Pre-purge
if [[ ${purge} -eq 1 ]]
then
    echo 'purge ON\nPress a key to continue'
    read
    sudo aptitude purge wolfram-engine
    sudo aptitude purge libreoffice*
    sudo aptitude clean
    sudo aptitude autoremove
else
    echo 'purge OFF\n'
fi
if [[ ${installdep} -eq 1 ]]
then
    echo 'installation des dependance\nPress a key to continue'
    read
    sudo apt-get update && sudo apt-get upgrade
    sudo apt-get install build-essential cmake pkg-config
    sudo apt-get install libjpeg-dev libtiff5-dev libjasper-dev libpng12-dev
    sudo apt-get install libavcodec-dev libavformat-dev libswscale-dev libv4l-dev
    sudo apt-get install libxvidcore-dev libx264-dev
    sudo apt-get install libgtk2.0-dev libgtk-3-dev
    sudo apt-get install libcanberra-gtk*
    sudo apt-get install libatlas-base-dev gfortran
    sudo apt-get install python2.7-dev python3-dev
fi
if [[ ${getOpenCV} -eq 1 ]]
then
    echo 'downloading OpenCV & OpenCV_contrib\n'
    read
    wget -O opencv.zip https://github.com/opencv/opencv/archive/master.zip
    wget -O opencv_contrib.zip https://github.com/opencv/opencv_contrib/archive/master.zip
    echo 'Unziping Both\n'
    read
    unzip opencv.zip
    unzip opencv_contrib.zip
fi
if [[ ${getpip} -eq 1 ]]
then
    echo 'Get pip and install it\n'
    read
    wget https://bootstrap.pypa.io/get-pip.py
    sudo python get-pip.py
    sudo python3 get-pip.py
    sudo pip install virtualenv virtualenvwrapper
    sudo rm -rf ~/.cache/pip
    echo 'add the following to ~/.profile\n'
    echo '# virtualenv and virtualenvwrapper\n'
    echo 'export WORKON_HOME=$HOME/.virtualenvs\n'
    echo 'source /usr/local/bin/virtualenvwrapper.sh\n'
    echo 'then source ~/.profile\n'
fi
echo 'create python venv : mkvirtualenv cv -p python3\n'
echo 'pip install numpy\n'
echo 'workon cv\n'
if [[ ${buildOpenCV} -eq 1 ]]
then
    echo "let's build opencv\n"
    echo "you may want to extend the swap size :\n"
    echo "nano /etc/dphys-swapfile then edit line CONF_SWAPSIZE\n"
    echo "/etc/init.d/dphys-swapfile stop then /etc/init.d/dphys-swapfile start\n"
    read
    cd "opencv*/"
    mkdir 'build'
    cd 'build'
    cmake -D CMAKE_BUILD_TYPE=RELEASE \
    -D CMAKE_INSTALL_PREFIX=/usr/local \
    -D OPENCV_EXTRA_MODULES_PATH=~/opencv_contrib-3.3.0/modules \
    -D ENABLE_NEON=ON \
    -D ENABLE_VFPV3=ON \
    -D BUILD_TESTS=OFF \
    -D INSTALL_PYTHON_EXAMPLES=OFF \
    -D BUILD_EXAMPLES=OFF ..
    make -j4
    make install
    ldconfig
fi
if [[ ${finalizing} -eq 1 ]]
then
    find '/usr/local/lib/' -iname "*cv2*"
    echo "ln -s \"~/.virtualenvs/cv/lib/python*/site-packages/cv2.cpython-*-arm-linux-gnueabihf.so\" \"cv2.so\"\n"
fi
