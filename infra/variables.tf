variable "location" {
  type    = string
  default = "eastus"
}

variable "sku" {
  type    = string
  default = "Standard"
}

variable "capacity" {
  type    = number
  default = 1
}

variable "partition_count" {
  type    = number
  default = 2
}

variable "message_retention" {
  type    = number
  default = 1
}

variable "interval_in_seconds" {
  type    = number
  default = 60
}

variable "size_limit_in_bytes" {
  type    = number
  default = 10485760
}
