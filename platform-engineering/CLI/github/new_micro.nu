source new_repo.nu

def "main github new-micro" [
    --name: string                                              #Nombre del flujo de negocio
    --template:string = "jdarguello/micro-template"      #Template base para flujos de negocio
    --description:string = ""                                   #(Opcional) Descripción del flujo de negocio
] {
    #1. Autenticación
    github auth

    #2. Creación del repo
    github newrepo --name=$"($name)-micro" --template=$template --description=$description
}   