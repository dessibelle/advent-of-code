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
  });
});
