source ../aws/cluster-ref.nu

def --env "main crossplane set-creds" [
    --businessflow-name:string
] {
    #1. Generar conexión con cluster del flujo de negocio
    main aws set-cluster --cluster-name $"($businessflow_name)-Cluster"

    #2. Guardar las credenciales de conexión en un archivo
    let aws_creds = $"[default]\naws_access_key_id = ($env.AWS_ACCESS_KEY_ID)\naws_secret_access_key = ($env.AWS_SECRET_ACCESS_KEY)"
    open aws-creds.txt
        | $aws_creds
    
    #3. Generar el secreto en el cluster
    kubectl create secret generic -n crossplane_system aws-creds --from-file=creds=aws-creds.txt
}