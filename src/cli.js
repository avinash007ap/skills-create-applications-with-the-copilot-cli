#!/usr/bin/env node
const { add, subtract, multiply, divide } = require('./calculator');

function isOperatorToken(op) {
  return ['+','-','*','/','x','×','÷'].includes(op);
}

function toNum(s) {
  const n = Number(s);
  if (Number.isNaN(n)) {
    console.error('Invalid number:', s);
    process.exit(2);
  }
  return n;
}

const args = process.argv.slice(2);
if (args.length === 0) {
  console.error('Usage: node src/cli.js <add|subtract|multiply|divide> a b OR node src/cli.js "a + b"');
  process.exit(1);
}

let result;
try {
  if (args.length === 1) {
    // expression form: "1 + 2"
    const expr = args[0].replace(/×/g,'*').replace(/[xX]/g,'*').replace(/÷/g,'/').trim();
    const m = expr.match(/^\s*([-+]?[0-9]*\.?[0-9]+)\s*([\+\-\*\/])\s*([-+]?[0-9]*\.?[0-9]+)\s*$/);
    if (!m) {
      console.error('Invalid expression. Expected format: "a + b"');
      process.exit(2);
    }
    const a = toNum(m[1]), b = toNum(m[3]), op = m[2];
    switch (op) {
      case '+': result = add(a, b); break;
      case '-': result = subtract(a, b); break;
      case '*': result = multiply(a, b); break;
      case '/': result = divide(a, b); break;
    }
  } else {
    const cmd = args[0].toLowerCase();
    const a = toNum(args[1]);
    const b = toNum(args[2]);
    switch (cmd) {
      case 'add': result = add(a, b); break;
      case 'subtract': result = subtract(a, b); break;
      case 'multiply': result = multiply(a, b); break;
      case 'divide': result = divide(a, b); break;
      default:
        if (isOperatorToken(cmd)) {
          const op = cmd;
          if (op === '+') result = add(a, b);
          else if (op === '-') result = subtract(a, b);
          else if (op === '*' || op.toLowerCase() === 'x' || op === '×') result = multiply(a, b);
          else if (op === '/' || op === '÷') result = divide(a, b);
          else { console.error('Unknown operation:', cmd); process.exit(2); }
        } else {
          console.error('Unknown command:', cmd);
          process.exit(2);
        }
    }
  }
  console.log(result);
} catch (err) {
  console.error('Error:', err.message);
  process.exit(3);
}
