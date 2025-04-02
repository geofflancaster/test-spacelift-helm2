resource "helm_release" "opencost" {
  name             = "opencost"
  repository       = "https://opencost.github.io/opencost-helm-chart"
  chart            = "opencost"
  namespace        = "opencost"
  create_namespace = true

  atomic = true
  wait   = true
}


resource "helm_release" "pingdirectory" {
  name             = "pingdirectory"
  repository       = "oci://705370621539.dkr.ecr.us-west-2.amazonaws.com/dev"
  chart            = "p1as-pingdirectory"
  version          = "v2.1-calvin-pd-test-scim-hotfix-image"
  namespace        = "default"
  create_namespace = true

  atomic = true
  wait   = true

  set = [
    {
        name = "global.isMicroserviceDeploy"
        value = "false"
    },
    {
      name = "global.ecrRegistryName"
      value = "705370621539.dkr.ecr.us-west-2.amazonaws.com/dev"
    },
    {
      name = "global.imagePullPolicy"
      value = "IfNotPresent"
    },
    {
      name = "global.secrets.ping-cloud.sshIdKeyBase64"
      value = var.codecommit_key
    },
    {
        name ="global.cloudProvider"
        value = "" # set to non-"aws" so we dont deploy the discovery service for now
    },
    {
        name = "global.pingIdentityDevopsUser"
        value = var.devops_user
    }, 
    {
        name = "global.pingIdentityDevopsKey"    
        value = var.devops_key
    },
    {
        name = "pingdirectory.monitorBucketUrl"
        value = ""
    },
    {
        name = "global.logArchiveUrl"
        value = ""
    },
    {
        name = "global.serverProfileUrl"
        value = var.server_profile_url
    },
    {
        name = "global.sshKnownHosts"
        value = var.ssh_known_hosts
    }
  ]
  timeout = 1200
}
