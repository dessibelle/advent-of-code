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

function solve(value) {
  return manhattanDistance(value);
}

function complete() {

}

function run() {
  fs.readFile('input', 'utf8', (err, data) => {
    const squareId = parseInt(data, 10);

    const answer1 = solve(squareId);
    process.stdout.write(`Answer 1: ${answer1}\n`);

    const answer2 = complete(squareId);
    process.stdout.write(`Answer 2: ${answer2}\n`);
  });
}


module.exports = {
  solve,
  complete,
  run,
};
