variable "name" {
  type        = string
  description = "The name of the table, this needs to be unique within a region."
}

variable "hash_key_name" {
  type        = string
  description = "The attribute to use as the hash (partition) key"
}

variable "hash_key_type" {
  type        = string
  description = "Attribute type, which must be a scalar type: S, N, or B for (S)tring, (N)umber or (B)inary data"
  default     = "S"
}