// Basic calculator operations and expanded functionality
module.exports = {
  add: (a, b) => a + b,
  subtract: (a, b) => a - b,
  multiply: (a, b) => a * b,
  divide: (a, b) => {
    if (b === 0) throw new Error('Division by zero');
    return a / b;
  },
  modulo: (a, b) => {
    if (b === 0) throw new Error('Division by zero');
    return a % b;
  },
  power: (a, b) => Math.pow(a, b),
  sqrt: (a) => {
    if (a < 0) throw new Error('Square root of negative number');
    return Math.sqrt(a);
  }
};
