#! /bin/bash
cd ~/
cp ~ctbrown/remote-computing.cache/condarc .condarc
bash ~ctbrown/remote-computing.cache/Miniconda3-py39_4.10.3-Linux-x86_64.sh -p $HOME/miniconda3 -b

eval "$(miniconda3/bin/conda shell.bash hook)"
conda init

echo 'source .bashrc' > ~/.bash_profile

source .bashrc
conda install -y mamba
