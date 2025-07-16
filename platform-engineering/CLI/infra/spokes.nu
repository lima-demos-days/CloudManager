source setup.nu

def "main infra new-spoke" [
    --cluster-name:string           #Nombre del clúster de EKS
    --min-size=1                    #Mínimo número de nodos
    --max-size=2                    #Máximo número de nodos
    --desired-size=1                #Tamaño deseado
    --instance-type="m6i.large"     #Tipo de instancias
    --cidr="172.0.0.0/16"           #CIDR de la VPC
    --dry-run="server"
] {
    #1. Preparar metadata del nuevo clúster
    let new_spoke = {
        cluster_name: $cluster_name,
        cluster_config: {
            instance_type: [$instance_type],
            min_size: $min_size,
            max_size: $max_size,
            desired_size: $desired_size,
            tags: {
                Environment: "dev",
                "Terraform": "true",
                "Name": $cluster_name
            }
        },
        vpc: {
            name: $cluster_name,
            cidr: $cidr,
            tags: {
                Name: $cluster_name,
                CostCenter: "Grupo Cibest"
            }
        }
    }

    #2. Cambiar al directorio de la configuración Terraform
    cd ../../infra/clusters

    #3. Añadir a la lista de clústers
    let original = open clusters.auto.tfvars.json
    let clusters = $original.clusters
                    | append $new_spoke

    #4. Guardar el archivo actualizado
    {"clusters": $clusters} | save clusters.auto.tfvars.json --force

    #5. Crear infraestructura 
    main infra setup --dry-run=$dry_run

    if $dry_run == "client" {
        $original | save clusters.auto.tfvars.json --force
    }
}

def "main infra delete-spoke" [
    --cluster-name:string
] {
    #1. Cambio de directorio
    cd ../../infra/clusters

    #2. Obtener información de los clusters
    let clusters_list = (open clusters.auto.tfvars.json).clusters

    #3. Encontrar el cluster a eliminar
    let new_list = $clusters_list | where $it.cluster_name != $cluster_name

    #5. Guardar y ejecutar el update
    {"clusters": $new_list} | save clusters.auto.tfvars.json --force
    
    main infra setup    #Se eliminó el spoke de la lista, se ejecuta Terraform para reconciliar
}

def "main infra get-spokes" [] {
    #1. Cambio de directorio
    cd ../../infra/clusters

    #2. Obtener información de los clusters
    let clusters_list = (open clusters.auto.tfvars.json).clusters

    return $clusters_list
}