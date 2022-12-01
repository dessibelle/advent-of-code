const fs = require('fs');

function stringToArray(data) {
  return data.trim().split('').map(integer => parseInt(integer, 10));
}

function solve(data, offset = 1) {
  const integers = stringToArray(data);

  const sum = integers.reduce((accumulator, value, idx) => {
    const nextIndex = (idx + offset) % integers.length;
    const increment = value === integers[nextIndex] ? value : 0;
    return accumulator + increment;
  }, 0);

  return sum;
}

const complete = data => solve(data, parseInt(data.length / 2, 10));

function run() {
  fs.readFile('input', 'utf8', (err, data) => {
    const answer1 = solve(data);
    process.stdout.write(`Answer 1: ${answer1}\n`);

    const answer2 = complete(data);
    process.stdout.write(`Answer 2: ${answer2}\n`);
  });
}


module.exports = {
  stringToArray,
  solve,
  complete,
  run,
};
