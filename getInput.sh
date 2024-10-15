#!/usr/bin/env bash

TZ=":US/Eastern"
cookie=cookies.txt
year="$(date +%Y)"
day="$(date +%-d)"
language=ruby

while getopts c:y:d: flag; do
    echo $OPTARG
    case "${flag}" in
        c)
            cookie=$OPTARG
        ;;
        y)
            year=$OPTARG
        ;;
        d)
            day=$OPTARG
        ;;
    esac
done
echo $day

url="https://adventofcode.com/$year/day/$day/input"
directory="./$year/input/$(printf %02d $day).txt"
curl $url -b $cookie -o $directory