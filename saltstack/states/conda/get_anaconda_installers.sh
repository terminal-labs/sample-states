URL="https://repo.continuum.io/archive/"

versions="Anaconda3-4.3.1-Linux-x86_64.sh
          Anaconda3-4.3.1-MacOSX-x86_64.pkg
          Anaconda3-4.3.1-MacOSX-x86_64.sh
          Anaconda3-4.3.1-Windows-x86.exe
          Anaconda3-4.3.1-Windows-x86_64.exe
          Anaconda2-4.3.1-Linux-x86_64.sh
          Anaconda2-4.3.1-MacOSX-x86_64.pkg
          Anaconda2-4.3.1-MacOSX-x86_64.sh
          Anaconda2-4.3.1-Windows-x86.exe
          Anaconda2-4.3.1-Windows-x86_64.exe"

# miniconda installers
mkdir -p /tmp/extras
pushd /tmp/extras

for installer in $versions
do
    curl -O $URL$installer
done
