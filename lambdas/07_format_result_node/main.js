const operationLabels = {
  add: "+",
  subtract: "-",
  multiply: "*",
  divide: "/",
  percentage: "%",
};

exports.handler = async (event = {}) => {
  const symbol = operationLabels[event.operation] ?? event.operation;
  const summary =
    event.operation === "percentage"
      ? `${event.left} * ${event.right}% = ${event.result}`
      : `${event.left} ${symbol} ${event.right} = ${event.result}`;

  return {
    ...event,
    summary,
    completedAt: new Date().toISOString(),
  };
};
