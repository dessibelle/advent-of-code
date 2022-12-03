#!/bin/bash

session=$1
day=$2
dir=$(printf "%02d" $day)

cp -r template "${dir}"

echo 'curl -H "Cookie: session={session}" "https://adventofcode.com/2022/day/${day}/input" -o "./${dir}/input"'
curl -H "Cookie: session=${session}" "https://adventofcode.com/2022/day/${day}/input" -o "./${dir}/input"
