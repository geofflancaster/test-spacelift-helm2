variable "customer_name" {
  type = string
}

variable "stages" {
  type = list(string)
}

variable "primary_region" {
  type = string

}
variable "secondary_regions" {
  type = list(string)
}
variable "products" {
  type = list(string)
}