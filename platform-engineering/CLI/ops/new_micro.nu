source ../utils.nu
source ../github/push.nu
source ../kubernetes/ns.nu
source ../kubernetes/kustomization.nu

def "main ops new-micro" [
    --businessflow-name:string                              #Nombre del flujo de negocio
    --micro-name:string                                     #Nombre del microservicio
    --host:string = "https://github.com/jdarguello/"        #Dirección base de repositorios
    --path:string="infra/platform-engineering/components"    #Path base de GitOps
] {
    #0. Adecuar carpetas
    let current_directory = pwd
    mkdir tmp 
    cd tmp

    #1. Clonar el businessflow repo y entrar a él
    let repo_name = $"($businessflow_name)-Businessflow"
    let repo_url = $host + $repo_name
    git clone $repo_url
    cd $repo_name
    cd $path

    #2. Estructura del nuevo micro dentro del repo
    mkdir $micro_name

    #2.1 Añadir micro a kustomization.yaml del root
    kustomization append --append-name=$"($micro_name)/"

    #2.2 Define el kustomization.yaml en el micro
    cd $micro_name
    kubernetes kustomization | to yaml | save kustomization.yaml --force
    
    #3. Crear un ns para el micro
    kubernetes namespace --name=$micro_name | to yaml | save ns.yaml --force

    #3.1 Registrar ns en kustomization.yaml
    kustomization append --append-name="ns.yaml"

    #4. Guardar cambios
    cd $current_directory
    cd tmp
    cd $repo_name
    main git push --commit-msg=$"platform: nuevo micro - ($micro_name)"

    #5. Borrar repo
    cd $current_directory
    rm -r tmp
}
