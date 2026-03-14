exports.handler = async (event = {}) => {
  const left = Number(event.left);
  const right = Number(event.right);

  if (right === 0) {
    throw new Error("Division by zero is not allowed.");
  }

  return {
    ...event,
    result: left / right,
    handledBy: "node-divide",
  };
};
