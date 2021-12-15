#!/bin/bash


url=$1
countRequestExpected=$2


countRequest=0
while [ 0 ]
do
	result=$(curl $url --silent)
	countRequest=$((countRequest + 1))
	if [ $countRequest -eq $countRequestExpected ]
	then
		break
	fi
done
