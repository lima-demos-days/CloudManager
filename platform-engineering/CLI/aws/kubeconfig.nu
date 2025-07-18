source cluster-ref.nu

def "main aws get-kubeconfig" [
    --cluster-name:string = "Manager-Cluster"
    --region:string = "us-east-1"
    --generate-yaml = true
    --kube-out:string = "kubeconfig-dot.yaml"
] {
    #1. Actualizar kubeconfig
    main aws set-cluster --region $region --cluster-name $cluster_name

    #2. Guardarlo como archivo
    if ($generate_yaml) {
        cat ~/.kube/config | save $kube_out --force
    }
}

def "main aws clean-kubeconfig" [] {
    #1. Obtener y eliminar todos los contexts
    let contexts = kubectl config get-contexts | detect columns
    for $context in $contexts {
        kubectl config delete-context $context.NAME
    }

    #2. Obtener y eliminar todos los clusters
    let clusters = kubectl config get-clusters | detect columns
    for $cluster in $clusters {
        kubectl config delete-cluster $cluster.NAME
    }
}