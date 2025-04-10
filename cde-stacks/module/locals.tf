locals {
  multi_region_stages = ["stage", "prod"]
  cdes = [
    for tuple in setunion(
      setproduct(toset(var.stages), toset([var.primary_region])),
      setproduct(setintersection(local.multi_region_stages, toset(var.stages)), toset(var.secondary_regions))
      ) : {
      stage  = tuple[0]
      region = tuple[1]
    }
  ]
}