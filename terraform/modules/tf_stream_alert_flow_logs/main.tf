provider "aws" {
  region = "${var.region}"
}

resource "aws_flow_log" "vpc_flow_log" {
  count          = "${length(var.vpcs)}"
  vpc_id         = "${element(var.vpcs, count.index)}"
  log_group_name = "${aws_cloudwatch_log_group.flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.flow_log_role.arn}"
  traffic_type   = "ALL"
}

resource "aws_flow_log" "subnet_flow_log" {
  count          = "${length(var.subnets)}"
  subnet_id      = "${element(var.subnets, count.index)}"
  log_group_name = "${aws_cloudwatch_log_group.flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.flow_log_role.arn}"
  traffic_type   = "ALL"
}

resource "aws_flow_log" "eni_flow_log" {
  count          = "${length(var.enis)}"
  eni_id         = "${element(var.enis, count.index)}"
  log_group_name = "${aws_cloudwatch_log_group.flow_log_group.name}"
  iam_role_arn   = "${aws_iam_role.flow_log_role.arn}"
  traffic_type   = "ALL"
}

resource "aws_cloudwatch_log_group" "flow_log_group" {
  name = "${var.flow_log_group_name}"
}

resource "aws_cloudwatch_log_subscription_filter" "flow_logs" {
  name            = "${aws_cloudwatch_log_group.flow_log_group.name}_to_lambda"
  log_group_name  = "${aws_cloudwatch_log_group.flow_log_group.name}"
  filter_pattern  = "${var.flow_log_filter}"
  destination_arn = "${var.destination_stream_arn}"
  role_arn        = "${aws_iam_role.flow_log_subscription_role.arn}"
}
