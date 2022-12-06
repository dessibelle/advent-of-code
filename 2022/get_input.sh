#!/bin/bash

session=$1
day=$2
dir=$(printf "%02d" $day)

if [ ! -f "lib/day${dir}.ex" ]; then
    sed "s/Day00/Day${dir}/" .template.ex > "lib/day${dir}.ex"
fi
if [ ! -f "test/day${dir}_test.exs" ]; then
    sed "s/00/${dir}/" .template_test.exs > "test/day${dir}_test.exs"
fi

mkdir -p "./input/${dir}"
touch "./input/${dir}/test"

# echo 'curl -H "Cookie: session={session}" "https://adventofcode.com/2022/day/${day}/input" -o "./$input/${dir}/input"'
curl -H "Cookie: session=${session}" "https://adventofcode.com/2022/day/${day}/input" -o "./input/${dir}/input"
