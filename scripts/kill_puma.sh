#!/bin/bash

kill -s QUIT $(ps aux | grep 'puma 3.4.0' | grep -v 'grep' | awk '{print $2}')
sleep 2
echo -en "\n\n"

