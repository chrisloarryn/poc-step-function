
exports.handler = async event => {
  var number = Math.floor(Math.random() * 100) + 1;
  console.log(`El numero generado es: ${number}`);
  
  console.log(`Hello world the number is ${number}`;

  return {number: number, is_even: number % 2 === 0};
};
