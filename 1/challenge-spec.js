/*
 *
 */

const captcha = require('./challenge.js');

describe('captcha', () => {
  describe('solve', () => {
    it('can find repeating digit', () => {
      const result = captcha.solve('1122');
      expect(result).toBe(3);
    });

    it('can handle multiple repeating digits correctly', () => {
      const result = captcha.solve('1111');
      expect(result).toBe(4);
    });

    it('does not find false positives', () => {
      const result = captcha.solve('1234');
      expect(result).toBe(0);
    });

    it('can wrap input digits', () => {
      const result = captcha.solve('91212129');
      expect(result).toBe(9);
    });
  });

  describe('complete', () => {
    it('the list contains 4 items, and all four digits match the digit 2 items ahead.', () => {
      const result = captcha.complete('1212');
      expect(result).toBe(6);
    });

    it('because every comparison is between a 1 and a 2.', () => {
      const result = captcha.complete('1221');
      expect(result).toBe(0);
    });

    it('because both 2s match each other, but no other digit has a match.', () => {
      const result = captcha.complete('123425');
      expect(result).toBe(4);
    });

    it('', () => {
      const result = captcha.complete('123123');
      expect(result).toBe(12);
    });

    it('', () => {
      const result = captcha.complete('12131415');
      expect(result).toBe(4);
    });
  });
});
