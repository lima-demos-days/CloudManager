def "main infra" [] {
    print (
"Description:
    Operaciones de infraestructura con Terraform.

Usage:
    manager infra <parameter>

Parameters:
    setup:      Levanta la infraestructura base (VPCs, subnets y clusters EKS)
    teardown:   Destruye toda la infraestructura del proyecto.
"
    )
}

def --env "main infra setup" [
    --dry-run="server"      #Define si se aplica la infraestructura o sólo el plan de Terraform
] {
    #1. Ir al directorio de infra
    cd ../../infra/clusters
    #2. Ejecutar el plan de Terraform ($dry_run == "client")
    if $dry_run == "client" {
        terraform plan --var=github-token=$env.GITHUB_TOKEN
    }
    #3. Ejecutar terraform (($dry_run == "server"))
    print $"A levantar! ($current_dir)"
}

def "main infra new-spoke" [] {

}

def "main infra delete-spoke" [] {

}