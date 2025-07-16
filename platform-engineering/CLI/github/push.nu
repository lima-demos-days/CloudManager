def "main github push" [
    --title:string
    --body:string
] {
    #1. Ir al directorio root
    let current_directory = pwd
    cd ../../

    #2. Realizar push
    gh pr create --title $title --body $body

    #3. Retornar al CLI
    cd $current_directory
}