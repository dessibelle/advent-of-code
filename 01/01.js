const fs = require('fs')

async function getInput() {
    return new Promise((resolve, reject) => {
        fs.readFile('./input.txt', 'utf8' , (err, data) => {
            if (err) {
                reject(err);
            }
            return resolve(data);
        });
    });
}

function getReadingsInWindow(allReadings, index, windowSize) {
    let sum = 0;
    for (i = 0; i < windowSize; i++) {
        sum += allReadings[index - i];
    }
    return sum;
}

async function answer(windowSize = 1) {
    const input = await getInput();
    const readings = input.split('\n').map(r => parseInt(r));
    
    const comparisons = readings.map((reading, i) => {
        let comparison = 'N/A;'
        if (i > (windowSize - 1)) {
            const currentWindow = getReadingsInWindow(readings, i, windowSize);
            const previousWindow = getReadingsInWindow(readings, i - 1, windowSize);
            if (currentWindow > previousWindow) {
                comparison = 'increased';
            } else if (currentWindow < previousWindow) {
                comparison = 'decreased';
            } else {
                comparison = 'equal';
            }
        }
        return comparison;
        // return `${reading} (${comparison})`;
    });
    return comparisons.filter(c => c === 'increased').length;
}


async function main() {
    console.log('1:', await answer(1));
    console.log('2:', await answer(3));
}

main();