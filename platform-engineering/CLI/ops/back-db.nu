source ../utils.nu
source ../crossplane/micro.nu

def "main ops back-db new" [
    --businessflow-name:string                              #Nombre del flujo de negocio
    --micro-name:string                                     #Nombre del microservicio
    --backend-name:string                                   #Nombre del servicio backend
    --replicas:number                                       #Número de replicas
    --image:string                                          #Imagen base de los contenedores
    --region:string = "us-east-1"                           #Región cloud
    --host:string = "github.com"                            #Dirección base de repositorios
    --path:string="infra/platform-engineering/components"   #Path base de GitOps
    --github-workflow = false                               #¿Es un workflow de GitHub?
] {
    #0. Adecuar carpetas
    let current_directory = pwd

    let repo_name = $"($businessflow_name)-Businessflow"
    if (not $github_workflow) {
        mkdir tmp 
        cd tmp

        #1. Clonar el businessflow repo y entrar a él
        let repo_url = $"https://($env.GITHUB_USER):($env.GITHUB_TOKEN)@($host)/jdarguello/($repo_name)"
        git clone $repo_url
    } else {
        cd tmp
    }
    
    cd $repo_name
    cd $path
    cd $micro_name

    #2. Crear el service
    let microdb = crossplane microdb --microdb-name=$backend_name --namespace=$micro_name --image=$image --db-name=$backend_name --replicas=$replicas --region=$region
    let filename = $"($backend_name).yaml"
    $microdb | to yaml | save $filename --force

    #3. Añadir el service al kustomization.yaml
    kustomization append --append-name=$filename

    #4. Guardar cambios
    cd $current_directory
    cd tmp
    cd $repo_name
    main git push --commit-msg=$"platform: nuevo micro - ($micro_name)"

    #5. Borrar repo tmp
    cd $current_directory
    rm -r tmp


}

def "main ops back-db update" [] {

}