def "main tf backend" [
    --bucket-name:string = "tf"
] {
    #1. Crear el s3
    aws s3api create-bucket \
        --bucket <BUCKET_NAME> \
        --region <REGION> \
        --create-bucket-configuration LocationConstraint=<REGION>

}