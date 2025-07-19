def "main aws set-cluster" [
    --cluster-name:string
    --region:string = "us-east-1"
] {
    #1. Definición de conexión con EKS
    aws eks update-kubeconfig --region $region --name $cluster_name

    #2. Obtener el kubeconfig generado
    mut kubeconfig = open ~/.kube/config | from yaml

    #3. Obtener el nombre del 'usuario' (cluster-arn)
    mut cluster_arn = ""
    for $cluster in $kubeconfig.clusters {
        if ($cluster.name | str contains $cluster_name) {
            $cluster_arn = $cluster.name
        }
    }

    #4. Introducir el token en la sección de users
    for $user in ($kubeconfig.users | enumerate) {
        if ($user.item.name | str contains $cluster_name) {
            #3.1 Genear token
            let token = aws eks get-token --cluster-name $cluster_name --region $region | from json

            #3.2 Vincularlo al user
            let user_info = {
                name: $cluster_arn
                user: {
                    token: $token.status.token
                }
            }

            #3.3 Guardar user
            $kubeconfig.users = $kubeconfig.users | update $user.index $user_info
            
            break
        }
    }

    #5. Guardar kubeconfig en ruta oficial
    $kubeconfig | to yaml | save ~/.kube/config --force
}