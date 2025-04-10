module "cde-stacks" {
    source = "./module"

    for_each = var.customers
    
    name = each.value.name
    stages = each.value.stages
    primary_region = each.value.primary_region
    secondary_regions = each.value.secondary_regions
    products = each.value.products

}