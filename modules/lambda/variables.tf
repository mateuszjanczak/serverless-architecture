variable "name" {
  type        = string
  description = "Unique name for your Lambda Function."
}

variable "src" {
  type        = string
  description = "Path to the function's deployment package within the local filesystem."
}

variable "handler" {
  type        = string
  description = "Function entrypoint in your code."
}

variable "runtime" {
  type        = string
  description = "Identifier of the function's runtime."
}

variable "environment_variables" {
  type        = map(string)
  description = "Map of environment variables that are accessible from the function code during execution."
}