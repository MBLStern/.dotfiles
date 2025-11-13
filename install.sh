#!/bin/bash

for file in *; do
    if [ -d $file ]; then
        echo "Executing command: stow $file"
        stow $file
    fi
done
