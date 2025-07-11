source new_repo.nu

def "main github new-businessflow" [
    --name: string                                              #Nombre del flujo de negocio
    --template:string = "jdarguello/businessflow-template"      #Template base para flujos de negocio
    --description:string = ""                                   #(Opcional) Descripción del flujo de negocio
] {
    #1. Autenticación
    github auth

    #2. Creación del repo
    github newrepo --name=$"($name)-Businessflow" --template=$template --description=$description
}   