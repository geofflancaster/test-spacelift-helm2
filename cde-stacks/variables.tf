variable "customers" {
    type = map(object({
        name = string
        stages = list(string),
        primary_region = string,
        secondary_regions = list(string),
        products = list(string),
    }))
}