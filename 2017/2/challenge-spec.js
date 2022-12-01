const challenge = require('./challenge.js');

describe('challenge', () => {
  let data;
  let rows;

  beforeEach(() => {
    data = '5 1 9 5\n7 5 3\n2 4 6 8';
    rows = [
      [5, 1, 9, 5],
      [7, 5, 3],
      [2, 4, 6, 8],
    ];
  });


  describe('parseInput', () => {
    it('can parse input to multi dimensional array', () => {
      const parsedRows = challenge.parseInput(data);
      expect(parsedRows).toEqual(rows);
    });
  });

  describe('first part', () => {
    it('can calculate and sum differences', () => {
      const result = challenge.solve(rows);
      expect(result).toBe(18);
    });
  });

  describe('second part', () => {
    beforeEach(() => {
      data = [
        [5, 9, 2, 8],
        [9, 4, 7, 3],
        [3, 8, 6, 5],
      ];
    });

    it('can find and sum divisible numbers', () => {
      const result = challenge.complete(data);
      expect(result).toBe(9);
    });
  });
});
