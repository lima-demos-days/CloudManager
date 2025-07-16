def "main flux bootstrap" [
    --repository:string
    --owner:string = "jdarguello"
    --branch:string = "main"
    --path:string = "infra/gitops"
] {
    flux bootstrap github 
        --token-auth 
        --owner=my-github-username 
        --repository=my-repository-name 
        --branch=main 
        --path=clusters/my-cluster 
        --personal
}