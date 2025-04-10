resource "spacelift_stack" "aws_infra" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "P1AS AWS Infrastructure"
  name         = "AWS Infra"
  project_root = "inf"
  repository   = "geoff-github"
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_context_attachment" "aws_infra_aws_context" {
  for_each   = spacelift_stack.aws_infra
  context_id = "csgbeluga"
  stack_id   = each.value.id
  priority   = 0
}

resource "spacelift_stack" "tools" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "P1AS Tools"
  name         = "Tools"
  project_root = "tools"
  repository   = "geoff-github"
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_context_attachment" "tools_aws_context" {
  for_each   = spacelift_stack.tools
  context_id = "csgbeluga"
  stack_id   = each.value.id
  priority   = 0
}

resource "spacelift_stack" "apps" {
  for_each = local.cdes

  autodeploy  = true
  branch      = "master"
  description = "P1AS apps"
  name        = "Apps"
  repository  = "geoff-github"
  space_id    = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_context_attachment" "apps_aws_context" {
  for_each   = spacelift_stack.apps
  context_id = "csgbeluga"
  stack_id   = each.value.id
  priority   = 0
}

resource "spacelift_stack" "config" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "P1AS Application Config"
  name         = "Application Config"
  project_root = "configuration"
  repository   = "geoff-github"
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_stack" "karpenter" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "Karpenter"
  name         = "Karpenter"
  project_root = "karpenter"
  repository   = "geoff-github"
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_context_attachment" "karpenter_aws_context" {
  for_each   = spacelift_stack.karpenter
  context_id = "csgbeluga"
  stack_id   = each.value.id
  priority   = 0
}
