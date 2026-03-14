def handler(event, _context):
    left = float(event["left"])
    right = float(event["right"])

    return {
        "left": left,
        "right": right,
        "operation": event["operation"],
        "result": left * right,
        "handledBy": "python-multiply",
    }
