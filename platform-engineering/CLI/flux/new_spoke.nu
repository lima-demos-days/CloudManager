source ../github/push.nu

def --env "main flux new-spoke" [
    --spoke-name:string
    --spoke-ns:string
    --git-url:string
    --git-ref:string
    --git-branch:string
    --flux-path:string
    --pr-title:string
    --pr-body:string

] {
    #1. Entrar a la sección de 'config'
    let current_directory = pwd
    cd ../../config/kubernetes/spokes

    #2. Registrar el nuevo 'spoke' en kustomization.yaml
    mut kustomization_spoke = open kustomization.yaml
    $kustomization_spoke.resources = $kustomization_spoke.resources     
                                        | append $"($spoke_name)/"
    
    $kustomization_spoke | to yaml | save kustomization.yaml --force

    #3. Crear la nueva carpeta del 'spoke' y adicionarle los archivos
    cp -r template $spoke_name

    #4. Editar la configuración yaml
    cd $spoke_name

    #4.1 setup-config.yaml
    mut setup_config = open setup-config.yaml
    $setup_config.spec.postBuild.substitute.SPOKE_NS = $spoke_ns
    $setup_config.spec.postBuild.substitute.GIT_URL = $git_url
    $setup_config.spec.postBuild.substitute.GIT_REF = $git_ref
    $setup_config.spec.postBuild.substitute.FLUX_PATH = $flux_path

    $setup_config | save setup-config.yaml --force

    #4.2 spoke-management.yaml
    mut spoke_management = open spoke-manegement.yaml
    $spoke_management.spec.postBuild.substitute.SPOKE_NS = $spoke_ns
    $spoke_management.spec.postBuild.substitute.GIT_URL = $git_url
    $spoke_management.spec.postBuild.substitute.GIT_REF = $git_branch
    $spoke_management.spec.postBuild.substitute.FLUX_PATH = $flux_path

    $spoke_management | save spoke-manegement.yaml --force

    #5. Subir los cambios al repo
    main github push --title $pr_title --body $pr_body

    #6. Regresar al directorio original
    cd $current_directory
}

def "flux reconcile" [] {

}