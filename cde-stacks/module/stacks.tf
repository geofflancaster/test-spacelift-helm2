resource "spacelift_stack" "aws_infra" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "P1AS AWS Infrastructure"
  name         = "${var.customer_name} ${each.key} AWS Infra"
  raw_git {
    namespace = "geofflancaster"
    url = "https://github.com/geofflancaster/test-spacelift-helm2"
  }
  repository = "test-spacelift-helm2"
  project_root = "/inf"

  terraform_version = "1.9.0"
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_smart_sanitization = true

  additional_project_globs = [""]
  enable_well_known_secret_masking = true
  github_action_deploy = false

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
  name         = "${var.customer_name} ${each.key} Tools"
  raw_git {
    namespace = "geofflancaster"
    url = "https://github.com/geofflancaster/test-spacelift-helm2"
  }
  repository = "test-spacelift-helm2"
  project_root = "/tools"

  terraform_version = "1.9.0"
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_smart_sanitization = true

  additional_project_globs = [""]
  enable_well_known_secret_masking = true
  github_action_deploy = false
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
  name         = "${var.customer_name} ${each.key} Ping Apps"
  raw_git {
    namespace = "geofflancaster"
    url = "https://github.com/geofflancaster/test-spacelift-helm2"
  }
  repository = "test-spacelift-helm2"

  terraform_version = "1.9.0"
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_smart_sanitization = true

  additional_project_globs = [""]
  enable_well_known_secret_masking = true
  github_action_deploy = false
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
  name         = "${var.customer_name} ${each.key} Application Config"
  raw_git {
    namespace = "geofflancaster"
    url = "https://github.com/geofflancaster/test-spacelift-helm2"
  }
  repository = "test-spacelift-helm2"
  project_root = "/configuration"

  terraform_version = "1.9.0"
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_smart_sanitization = true

  additional_project_globs = [""]
  enable_well_known_secret_masking = true
  github_action_deploy = false
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"
}

resource "spacelift_stack" "karpenter" {
  for_each = local.cdes

  autodeploy   = true
  branch       = "master"
  description  = "Karpenter"
  name         = "${var.customer_name} ${each.key} Karpenter"
  raw_git {
    namespace = "geofflancaster"
    url = "https://github.com/geofflancaster/test-spacelift-helm2"
  }
  repository = "test-spacelift-helm2"
  project_root = "/karpenter"

  terraform_version = "1.9.0"
  terraform_workflow_tool = "OPEN_TOFU"
  terraform_smart_sanitization = true

  additional_project_globs = [""]
  enable_well_known_secret_masking = true
  github_action_deploy = false
  space_id     = "lab-01JQFX8YRP7DH4MCQYETZG4ET6"

  terraform {
    backend {
      backend_type = "s3"
    }
  }
}

resource "spacelift_context_attachment" "karpenter_aws_context" {
  for_each   = spacelift_stack.karpenter
  context_id = "csgbeluga"
  stack_id   = each.value.id
  priority   = 0
}
