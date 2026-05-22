const calc = require('../calculator');

test('modulo', () => {
  expect(calc.modulo(10, 3)).toBe(1);
});

test('power', () => {
  expect(calc.power(2, 3)).toBe(8);
});

test('square root', () => {
  expect(calc.sqrt(9)).toBe(3);
});
