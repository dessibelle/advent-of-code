const fs = require('fs');
const lodash  = require('lodash');


function solve() {

}

function complete() {

}

function run() {
  fs.readFile('input', 'utf8', (err, data) => {
    const answer1 = solve(data);
    process.stdout.write(`Answer 1: ${answer1}\n`);

    const answer2 = complete(data);
    process.stdout.write(`Answer 2: ${answer2}\n`);
  });
}


module.exports = {
  solve,
  complete,
  run,
};
