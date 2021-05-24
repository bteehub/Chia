#!/bin/bash

cd ~/chia-blockchain/

. ./activate
chia stop all
deactivate

mkdir -p ~/archive
tar cfz ~/archive/chia_$(date +%Y%m%d_%H%M%S).tar.gz -C ~ .chia

git fetch
git checkout latest
git pull

sh install.sh

. ./activate
chia init
deactivate
