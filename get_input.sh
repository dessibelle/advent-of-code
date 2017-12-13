#!/bin/bash

session=$1
day=$2

mkdir -p "./${day}"

echo 'curl -H "Cookie: session={session}" "https://adventofcode.com/2017/day/${day}/input" -o "./${day}/input"'
curl -H "Cookie: session=${session}" "https://adventofcode.com/2017/day/${day}/input" -o "./${day}/input"
