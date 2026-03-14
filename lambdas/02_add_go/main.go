package main

import (
	"context"

	"github.com/aws/aws-lambda-go/lambda"
)

type CalculatorEvent struct {
	Left      float64 `json:"left"`
	Right     float64 `json:"right"`
	Operation string  `json:"operation"`
}

type CalculatorResult struct {
	Left      float64 `json:"left"`
	Right     float64 `json:"right"`
	Operation string  `json:"operation"`
	Result    float64 `json:"result"`
	HandledBy string  `json:"handledBy"`
}

func handler(_ context.Context, event CalculatorEvent) (CalculatorResult, error) {
	return CalculatorResult{
		Left:      event.Left,
		Right:     event.Right,
		Operation: event.Operation,
		Result:    event.Left + event.Right,
		HandledBy: "go-add",
	}, nil
}

func main() {
	lambda.Start(handler)
}
