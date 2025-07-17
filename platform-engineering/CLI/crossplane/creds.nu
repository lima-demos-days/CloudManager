source ../aws/cluster-ref.nu

def --env "main crossplane set-creds" [
    --businessflow-name:string
] {
    #1. Generar conexión con cluster del flujo de negocio
    main aws set-cluster --cluster-name $"($businessflow_name)-Cluster"

    #2. Guardar las credenciales de conexión en un archivo
    let aws_creds = $"[default]\naws_access_key_id = ($env.AWS_ACCESS_KEY_ID)\naws_secret_access_key = ($env.AWS_SECRET_ACCESS_KEY)"
    $aws_creds | save aws-creds.txt --force

    #3. Revisar si existe el ns y el secret para crearlos
    let ns = kubectl get ns | detect columns | get NAME | where ($it == "crossplane-system")
    if ($ns | is-empty) {   #No está creado el ns crossplane-system
        kubectl create ns crossplane-system
        kubectl create secret generic -n crossplane-system aws-creds --from-file=creds=aws-creds.txt
    } else {                #Está creado el ns
        let secret = kubectl get secret -n crossplane-system | detect columns
        if ($secret | is-empty) {   #Si no existe, créelo
            kubectl create secret generic -n crossplane-system aws-creds --from-file=creds=aws-creds.txt
        }
    }
}