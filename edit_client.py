#!/bin/bash

sed -i "s/password='admin'/password='$1'/g" /usr/lib/python2.7/dist-packages/aos/sdk/client.py
