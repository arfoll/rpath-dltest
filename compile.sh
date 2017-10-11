#!/usr/bin/env bash

# make lib locally
gcc -shared -o lib5.so -fPIC lib5.c

# make lib in lib10 folder
cd libnum/lib10/
gcc -shared -o lib5.so -fPIC lib10.c
cd ../
gcc -shared -o libnum.so -fPIC libnum.c -l5 -Wl,-rpath=XORIGIN/lib10/
chrpath -r "\$ORIGIN/lib10/" libnum.so

cd ../
# make binary
gcc executable.c -o executable -Llibnum/ -lnum -Wl,-rpath=libnum/

