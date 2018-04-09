#!/bin/bash

if [ $# -eq 0 ]
	then
		echo "IP Address Required"
	else
		echo "Starting aggressive scan"
		nmap -A $1 > Aggressive-$1.txt
		echo "Aggressive scan complete"
		echo "Starting full TCP Scan"
		nmap -vv -Pn -sS -sC -p- -T3 $1 -script-args=unsafe=1 > Full-TCP-$1.txt
		echo "Full TCP scan complete"
		echo "Starting UDP Scan"
		nmap -sC -sV -sU $1 > Full-UDP-$1.txt
		echo "UDP scan complete"
fi
