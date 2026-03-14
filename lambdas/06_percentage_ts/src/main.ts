import type { Handler } from "aws-lambda";

type PercentageEvent = {
  left: number;
  right: number;
  operation: string;
  requestedAt?: string;
};

type PercentageResult = PercentageEvent & {
  result: number;
  handledBy: string;
};

export const handler: Handler<PercentageEvent, PercentageResult> = async (event) => {
  return {
    ...event,
    result: (event.left * event.right) / 100,
    handledBy: "typescript-percentage",
  };
};
