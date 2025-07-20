#Formato de creación de un microservicio con base de datos
def "crossplane microdb" [
    --microdb-name:string
    --namespace:string
    --image:string
    --db-name:string
    --replicas:number = 1
    --region:string = "us-east-1"
] {
    return {
        "apiVersion": "bancolombia.businessflows/v1",
        "kind": "Micro",
        "metadata": {
            "namespace": $namespace,
            "name": $microdb_name
        },
        "spec": {
            "image": $image,
            "replicas": $replicas,
            "aws-resources": {
                "region": $region,
                "db-name": ($db_name | str replace -r "-" "")
            }
        }
    }
} 