URL="https://repo.continuum.io/miniconda/"

versions="Miniconda2-4.3.11-Linux-x86_64.sh
          Miniconda2-4.3.11-MacOSX-x86_64.sh
          Miniconda2-4.3.11-Windows-x86.exe
          Miniconda2-4.3.11-Windows-x86_64.exe
          Miniconda3-4.3.11-Linux-x86_64.sh
          Miniconda3-4.3.11-MacOSX-x86_64.sh
          Miniconda3-4.3.11-Windows-x86.exe
          Miniconda3-4.3.11-Windows-x86_64.exe"

# miniconda installers
mkdir -p /tmp/extras
pushd /tmp/extras

for installer in $versions
do
    curl -O $URL$installer
done
