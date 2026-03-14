use lambda_runtime::{service_fn, Error, LambdaEvent};
use serde::{Deserialize, Serialize};

#[derive(Debug, Deserialize)]
struct CalculatorEvent {
    left: f64,
    right: f64,
    operation: String,
}

#[derive(Debug, Serialize)]
#[serde(rename_all = "camelCase")]
struct CalculatorResult {
    left: f64,
    right: f64,
    operation: String,
    result: f64,
    handled_by: String,
}

async fn handler(event: LambdaEvent<CalculatorEvent>) -> Result<CalculatorResult, Error> {
    let payload = event.payload;

    Ok(CalculatorResult {
        left: payload.left,
        right: payload.right,
        operation: payload.operation,
        result: payload.left - payload.right,
        handled_by: String::from("rust-subtract"),
    })
}

#[tokio::main]
async fn main() -> Result<(), Error> {
    lambda_runtime::run(service_fn(handler)).await
}
