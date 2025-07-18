def "kustomization append" [
    --append-name:string        #Nombre de lo que se agrega
] {
    mut kustomization = open kustomization.yaml
    $kustomization.resources = $kustomization.resources | append $append_name
    $kustomization | to yaml | save kustomization.yaml --force
}