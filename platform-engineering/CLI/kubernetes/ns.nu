#Define el manifiesto de ns en JSON
def "kubernetes namespace" [
    --name:string   #Nombre del namespace
] {
    return {
        "kind": "Namespace",
        "apiVersion": "v1",
        "metadata": {
            "name": $name,
        },
        "spec": {},
        "status": {}
    }
}
