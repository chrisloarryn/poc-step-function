import type { Handler } from "aws-lambda";

type Operation = "add" | "subtract" | "multiply" | "divide" | "percentage";

type IncomingEvent = {
  left?: number | string;
  right?: number | string;
  operation?: string;
  action?: string;
};

type ValidatedRequest = {
  left: number;
  right: number;
  operation: Operation;
  requestedAt: string;
};

const operationAliases: Record<string, Operation> = {
  "+": "add",
  add: "add",
  sum: "add",
  "-": "subtract",
  subtract: "subtract",
  substract: "subtract",
  "*": "multiply",
  multiply: "multiply",
  x: "multiply",
  "/": "divide",
  divide: "divide",
  percentage: "percentage",
  percent: "percentage",
  "%": "percentage",
};

const parseNumber = (value: number | string | undefined, fieldName: string): number => {
  const parsed = Number(value);

  if (!Number.isFinite(parsed)) {
    throw new Error(`The field '${fieldName}' must be a valid number.`);
  }

  return parsed;
};

const normalizeOperation = (value: string | undefined): Operation => {
  const normalized = operationAliases[(value ?? "").trim().toLowerCase()];

  if (!normalized) {
    throw new Error("Unsupported operation. Use add, subtract, multiply, divide or percentage.");
  }

  return normalized;
};

export const handler: Handler<IncomingEvent, ValidatedRequest> = async (event = {}) => {
  const left = parseNumber(event.left, "left");
  const right = parseNumber(event.right, "right");
  const operation = normalizeOperation(event.operation ?? event.action);

  if (operation === "divide" && right === 0) {
    throw new Error("Division by zero is not allowed.");
  }

  return {
    left,
    right,
    operation,
    requestedAt: new Date().toISOString(),
  };
};
