module "queue" {
  source = "./modules/sqs"
  name   = "queue"
}

module "topic" {
  source = "./modules/sns"
  name   = "topic"
}
