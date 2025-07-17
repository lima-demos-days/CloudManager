source ../aws/kubeconfig.nu

def "main flux build" [
    --cluster-name:string = "Manager-Cluster"
] {
    #1. Conexión al cluster
    main aws get-kubeconfig --cluster-name=$cluster_name --generate-yaml=false

    #2. Crear flux-system ns
    kubectl create ns flux-system

    #3. Crear token de GitHub como secreto
    kubectl create secret generic -n flux-system flux-system

}

def "main flux pre-build" [
    --spoke-cluster:string
    --hub-cluster:string = "Manager-Cluster"
    --region:string = "us-east-1"
] {
    #1. Limpiar todas las conexiones del kubeconfig
    main aws clean-kubeconfig

    #2. Establcer conexión con el spoke-cluster y guardar su kubeconfig
    main aws get-kubeconfig --cluster-name=$spoke_cluster --kube-out="spoke-kubeconfig.yaml"

    #3. Establecer conexión con el hub-cluster y crear el namespace del spoke-cluster
    main aws get-kubeconfig --cluster-name=$hub_cluster --generate-yaml=false

    let ns_name = $spoke_cluster | str downcase
    kubectl create ns $ns_name

    #4. Registrar el spoke-kubeconfig como secreto en el ns del spoke-cluster
    kubectl create secret generic -n $ns_name cluster-kubeconfig --from-file=value=spoke-kubeconfig.yaml
}