#!/bin/bash

vboxmanage controlvm Jumphost-v1.0 poweroff
vboxmanage export Jumphost-v1.0 -o Jumphost-v1.0.ova
