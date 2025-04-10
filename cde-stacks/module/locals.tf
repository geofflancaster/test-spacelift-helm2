locals {
  multi_region_stages = ["stage", "prod"]
  cde_maps = [
    for tuple in setunion(
      setproduct(toset(var.stages), toset([var.primary_region])),
      length(var.secondary_regions) > 0 ? setproduct(setintersection(local.multi_region_stages, toset(var.stages)), toset(var.secondary_regions)) : toset([])
      ) : {
      stage  = tuple[0]
      region = tuple[1]
    }
  ]
  cdes = {
    for cde_map in local.cde_maps : "${cde_map.stage}-${cde_map.region}" => cde_map
  }
}