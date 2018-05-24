#!/usr/local/bin/bash

TARGET=$(ssh kali cat TARGET)
mkdir /data/shared/notes/$TARGET/screenshots/
scrot -s /data/shared/notes/$TARGET/screenshots/%d-%m-%Y-%H-%M-%S.png -q 100
