def --env "github auth" [] {
    #1. Tratamiento al token
    rm token.txt --force
    let old_token = $env.GITHUB_TOKEN 
    ($env.GITHUB_TOKEN | str trim) | save token.txt
    $env.GITHUB_TOKEN = ""
    
    #2. Realizar la Autenticación
    open token.txt 
        | str trim 
        | gh auth login --with-token

    #3. Retornar el token
    $env.GITHUB_TOKEN = $old_token
    rm token.txt
}

def "github newrepo" [
    --name: string                  #Nombre del repo
    --template: string              #Template base para la creación del repo
    --public = true           #Tipo de repo (públic/privado)
    --description: string = ""      #(Opcional) Descripción del repo
] {
    let repo_name = "jdarguello/" + $name
    
    if $public {
        gh repo create $repo_name --template $template --public --description $description
    } else {
        gh repo create $repo_name --template $template --private --description $description
    }
    
}