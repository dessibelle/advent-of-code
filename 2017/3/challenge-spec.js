const challenge = require('./challenge.js');

describe('challenge', () => {
  describe('first part', () => {
    it('1 is carried 0 steps, since it\'s at the access port', () => {
      const result = challenge.solve(1);
      expect(result).toBe(0);
    });

    it('12 is carried 3 steps, such as: down, left, left', () => {
      const result = challenge.solve(12);
      expect(result).toBe(3);
    });

    it('23 is carried only 2 steps: up twice', () => {
      const result = challenge.solve(23);
      expect(result).toBe(2);
    });

    it('1024 must be carried 31 steps', () => {
      const result = challenge.solve(1024);
      expect(result).toBe(31);
    });
  });

  describe('second part', () => {
    it('can find repeating digit', () => {
      // const result = challenge.solve();
      // expect(result).toBe(1234);
    });

    /*
      Square 1 starts with the value 1.
      Square 2 has only one adjacent filled square (with value 1), so it also stores 1.
      Square 3 has both of the above squares as neighbors and stores the sum of their values, 2.
      Square 4 has all three of the aforementioned squares as neighbors and stores the sum of their values, 4.
      Square 5 only has the first and fourth squares as neighbors, so it gets the value 5.
    */
  });
});
