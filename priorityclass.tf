resource "kubernetes_manifest" "priorityclass" {
    depends_on = [ helm_release.karpenter ]
    manifest = {
        apiVersion = "scheduling.k8s.io/v1"
        kind       = "PriorityClass"
        metadata = {
            name = "high-priority-apps-to-avoid-pending-state"
        }
        # globalDefault = false
        value = 1000000
        # preemptionPolicy = "Never"
    }
}
