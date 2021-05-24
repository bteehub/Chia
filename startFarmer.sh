#!/bin/bash

cd ~/chia-blockchain/

. ./activate
chia start farmer
deactivate
