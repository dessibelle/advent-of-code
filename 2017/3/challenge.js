const fs = require('fs');
const lodash  = require('lodash');

function layerForNumItems(value) {
  return value ? Math.ceil((Math.sqrt(value) + 1) / 2) : 0;
}

function numItemsForLayer(value) {
  return value ? Math.pow(2 * value - 1, 2) : 0;
}

function manhattanDistance(value) {
  const layer = layerForNumItems(value);
  const layersToTravel = layer - 1;

  const itemsInLayer = numItemsForLayer(layer) - numItemsForLayer(layer - 1);
  const offsetInLayer = value - numItemsForLayer(layer - 1);

  const itemsOnSide = parseInt(itemsInLayer / 4, 10);
  const offsetOnSide = itemsOnSide ? offsetInLayer % itemsOnSide : 0;

  const sideCenterIdx = parseInt(itemsOnSide / 2, 10) + 1;
  const positionOnSide = offsetOnSide + 1;

  const distanceToCenter = Math.abs(sideCenterIdx - positionOnSide);

  return layersToTravel + distanceToCenter;
}


function neighboursForIndex(idx) {

}

function solve(value) {
  return manhattanDistance(value);
}

function complete(target) {
  let currentSum = 0;
  let index = -1;
  const values = [];

  while (index < target) {
    index += 1;

    if (!values.length) {
      values.push(1);
    } else {
      let sum = 0;
      for (let i = index - 1; i >=0; i--) {
        sum += values[i];
      }
      values.push(sum);
      // const layer = layerForNumItems(index);

      // const itemsInLayer = numItemsForLayer(layer) - numItemsForLayer(layer - 1);
      // const offsetInLayer = index - numItemsForLayer(layer - 1);

      // const itemsOnSide = parseInt(itemsInLayer / 4, 10);
      // const offsetOnSide = itemsOnSide ? offsetInLayer % itemsOnSide : 0;

      // const sideCenterIdx = parseInt(itemsOnSide / 2, 10) + 1;
      // const positionOnSide = offsetOnSide + 1;

      // console.log(index, offsetInLayer);
    }

    currentSum = index;
  }

  console.log(values);

  return currentSum;

  /*
     0 => [0]             // center
     1 => [0]             // layer
     2 => [0, 1]          // corner 1
     3 => [0, 1, 2]
     4 => [0, 3]          // corner 2
     5 => [0, 3, 4]
     6 => [0, 5]          // corner 3
     7 => [0, 5, 6]
     8 => [0, 1, 7]       // corner 4
     9 => [1, 8]          // layer
    10 => [1, 2, 8, 9]
    11 => [1, 2, 10]
    12 => [2, 11]         // corner 1
    13 => [2, 11, 12]
    14 => [2, 3, 4, 13]
    15 => [3, 4, 14]
    16 => [4, 15]         // corner 2
    17 => [4, 15, 16]
    18 => [4, 5, 17]
    19 => [5, 6, 18]
    20 => [5, 19]         // corner 3
    21 => [20]
    22 => [21]
    23 => [22]
    24 => [23]            // corner 4
    25 => [24]            // layer
  */

  /*
    Once a square is written, its value does not change. Therefore, the first few squares would receive the following values:

    147  142  133  122   59
    304    5    4    2   57
    330   10    1    1   54
    351   11   23   25   26
    362  747  806--->   ...

    What is the first value written that is larger than your puzzle input?
  */
}

function run() {
  fs.readFile('input', 'utf8', (err, data) => {
    const squareId = parseInt(data, 10);

    const answer1 = solve(squareId);
    process.stdout.write(`Answer 1: ${answer1}\n`);

    const answer2 = complete(20);
    process.stdout.write(`Answer 2: ${answer2}\n`);
  });
}


module.exports = {
  solve,
  complete,
  run,
};
