def "main aws get-kubeconfig" [
    --cluster-name:string = "Manager-Cluster"
    --region:string = "us-east-1"
    --kube-out:string = "kubeconfig-dot.yaml"
] {
    #1. Actualizar kubeconfig
    aws eks update-kubeconfig --region $region --name $cluster_name

    #2. Guardarlo como archivo
    cat ~/.kube/config | save $kube_out --force
}