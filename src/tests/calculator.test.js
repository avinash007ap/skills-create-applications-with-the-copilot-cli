const { add, subtract, multiply, divide } = require('../calculator');

describe('Calculator operations', () => {
  test('addition: 2 + 3 = 5', () => {
    expect(add(2, 3)).toBe(5);
  });

  test('subtraction: 10 - 4 = 6', () => {
    expect(subtract(10, 4)).toBe(6);
  });

  test('multiplication: 45 * 2 = 90', () => {
    expect(multiply(45, 2)).toBe(90);
  });

  test('division: 20 / 5 = 4', () => {
    expect(divide(20, 5)).toBe(4);
  });

  test('addition with floats', () => {
    expect(add(1.5, 2.3)).toBeCloseTo(3.8);
  });

  test('subtraction negative result', () => {
    expect(subtract(3, 7)).toBe(-4);
  });

  test('multiplication by zero', () => {
    expect(multiply(123, 0)).toBe(0);
  });

  test('division resulting in fraction', () => {
    expect(divide(7, 2)).toBeCloseTo(3.5);
  });

  test('division by zero throws', () => {
    expect(() => divide(1, 0)).toThrow('Division by zero');
  });

  test('operations with negative numbers', () => {
    expect(add(-2, -3)).toBe(-5);
    expect(multiply(-4, 5)).toBe(-20);
    expect(subtract(-1, -1)).toBe(0);
  });
});
