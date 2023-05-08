#!/bin/bash
# This takes the new password as an argument
sed -i "s/password='admin'/password='$1'/g" /usr/lib/python2.7/dist-packages/aos/sdk/client.py
