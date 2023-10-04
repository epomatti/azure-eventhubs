variable "location" {
  type    = string
  default = "eastus"
}

### Event Hub ###

variable "evh_sku" {
  type    = string
  default = "Standard"
}

variable "evh_capacity" {
  type    = number
  default = 1
}

variable "evh_partition_count" {
  type    = number
  default = 2
}

variable "evh_message_retention" {
  type    = number
  default = 1
}

variable "evh_interval_in_seconds" {
  type    = number
  default = 60
}

variable "evh_size_limit_in_bytes" {
  type    = number
  default = 10485760
}
