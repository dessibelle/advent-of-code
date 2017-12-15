const fs = require('fs');
const _ = require('lodash');

function parseInput(data) {
  const rawRows = data.trim().split('\n');
  return rawRows.map(row => row.trim().split(/\s+/).map(col => parseInt(col, 10)));
}

function solve(rows) {
  const diffs = rows.map(row => _.max(row) - _.min(row));
  return _.sum(diffs);
}

function complete(rows) {
  const divisions = rows.map((row) => {
    const sortedValues = _.orderBy(row, obj => parseInt(obj, 10), 'desc');

    const rowDivisions = [];
    for (let nominatorIdx = 0; nominatorIdx < sortedValues.length; nominatorIdx += 1) {
      for (let denominatorIdx = sortedValues.length - 1; denominatorIdx > nominatorIdx; denominatorIdx -= 1) {
        const nominator = sortedValues[nominatorIdx];
        const denominator = sortedValues[denominatorIdx];
        if (nominator % denominator === 0) {
          rowDivisions.push(nominator / denominator);
        }
      }
    }
    return _.sum(rowDivisions);
  });
  return _.sum(divisions);
}

function run() {
  fs.readFile('input', 'utf8', (err, data) => {
    const rows = parseInput(data);

    const answer1 = solve(rows);
    process.stdout.write(`Answer 1: ${answer1}\n`);

    const answer2 = complete(rows);
    process.stdout.write(`Answer 2: ${answer2}\n`);
  });
}


module.exports = {
  parseInput,
  solve,
  complete,
  run,
};
