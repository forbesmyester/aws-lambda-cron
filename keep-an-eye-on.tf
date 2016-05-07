variable "aws_profile" {}

provider "aws" {
    profile = "${var.aws_profile}"
    region = "us-east-1"
}

resource "aws_iam_role" "iam_for_lambda" {
    name = "iam_for_lambda"
    assume_role_policy = "${file("./iam_for_lambda.json")}"
}

resource "aws_iam_role_policy" "iam_for_lambda" {
    name = "iam_for_lambda_policy"
    role = "${aws_iam_role.iam_for_lambda.id}"
    policy = "${file("./iam_for_lambda_policy.json")}"
}

resource "aws_cloudwatch_event_rule" "fire_every_minute" {
    name = "fire_every_minute"
    schedule_expression = "cron(* * * * ? *)"
}

resource "aws_lambda_function" "fire_every_minute" {
    filename = "./minutely_push_to_sqs.zip"
    function_name = "fire_every_minute"
    handler = "index.handler"
    runtime = "nodejs4.3"
    role = "${aws_iam_role.iam_for_lambda.arn}"
}

resource "aws_cloudwatch_event_target" "fire_every_minute" {
  rule = "${aws_cloudwatch_event_rule.fire_every_minute.name}"
  arn = "${aws_lambda_function.fire_every_minute.arn}"
}

resource "aws_lambda_permission" "allow_cloudwatch" {
    statement_id = "AllowExecutionFromCloudWatch"
    action = "lambda:InvokeFunction"
    function_name = "${aws_lambda_function.fire_every_minute.arn}"
    principal = "events.amazonaws.com"
    source_arn = "${aws_cloudwatch_event_rule.fire_every_minute.arn}"
}
