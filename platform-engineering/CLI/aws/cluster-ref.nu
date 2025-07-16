def "main aws set-cluster" [
    --cluster-name:string
    --region:string = "us-east-1"
] {
    aws eks update-kubeconfig --region $region --name $cluster_name
}