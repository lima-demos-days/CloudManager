source ../aws/cluster-ref.nu

#Vincula el repositorio con el cluster del flujo de negocio o 'Manager-Cluster'
def "main flux bootstrap" [
    --repository:string = "CloudManager"
    --cluster-name:string = "Manager-Cluster"
    --owner:string = "jdarguello"
    --branch:string = "main"
    --path:string = "infra/gitops"
] {
    #1. Vincular el cluster de interés con kubectl
    main aws set-cluster --cluster-name=$cluster_name

    #2. Ejecutar bootstrap
    flux bootstrap github --token-auth --owner=$"($owner)" --repository=$"($repository)" --branch=$"($branch)" --path=$"($path)" --personal
}