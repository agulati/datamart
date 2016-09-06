#!/bin/bash

kill -s QUIT $(ps aux | grep '[r]esque-1.' | awk '{print $2}')
kill -s QUIT $(ps aux | grep '[r]esque-scheduler.' | awk '{print $2}')
sleep 2
echo -en "\n\n"