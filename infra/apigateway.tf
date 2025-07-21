resource "aws_apigatewayv2_vpc_link" "api_vpc_link" {
  name               = "${var.project_name}-link"
  subnet_ids         = module.vpc.private_subnets
  security_group_ids = [aws_security_group.ecs_sg.id]
  tags               = var.tags
}

resource "aws_apigatewayv2_api" "api" {
  name          = "${var.project_name}-api-gw"
  protocol_type = "HTTP"
  tags          = var.tags
}

resource "aws_apigatewayv2_integration" "api_integration" {
  api_id             = aws_apigatewayv2_api.api.id
  integration_type   = "HTTP_PROXY"
  connection_type    = "VPC_LINK"
  connection_id      = aws_apigatewayv2_vpc_link.api_vpc_link.id
  integration_method = "ANY"
  integration_uri    = aws_lb_listener.nlb_listener.arn
}

resource "aws_apigatewayv2_route" "proxy_route" {
  api_id    = aws_apigatewayv2_api.api.id
  route_key = "ANY /{proxy+}"
  target    = "integrations/${aws_apigatewayv2_integration.api_integration.id}"
}

resource "aws_apigatewayv2_stage" "default" {
  api_id      = aws_apigatewayv2_api.api.id
  name        = "$default"
  auto_deploy = true
  tags        = var.tags
}
