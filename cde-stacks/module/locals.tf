locals {
  multi_region_stages = ["stage", "prod"]
  cdes = [
    for tuple in setunion(
      setproduct(toset(var.stages), toset([var.primary_region])),
      length(var.secondary_regions) > 0 ? setproduct(setintersection(local.multi_region_stages, toset(var.stages)), toset(var.secondary_regions)) : toset([])
      ) : {
      stage  = tuple[0]
      region = tuple[1]
    }
  ]
}