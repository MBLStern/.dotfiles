#!/bin/bash

stowPackages(){
for file in *; do
    if [ -d $file ]; then
        echo "Executing command: stow $file"
        stow -t $HOME $file
    fi
done
}

if [ $# -ne 1 ]; then
    echo "Config not specified"
    echo "Available configs: desktop laptop"
elif [ $1 != "desktop" ] && [ $1 != "laptop" ]; then
    echo "Specified config does not exist"
    echo "Available configs: desktop laptop"
else
    cd both
    echo "Stowing packages for both"
    stowPackages
    cd ..
    cd $1
    echo "Stowing packages for $1"
    stowPackages
    cd ..
    echo "Finished stowing packages"
fi
