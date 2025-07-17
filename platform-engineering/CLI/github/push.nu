def "main github push manager" [
    --spoke-name:string
] {
    #1. Ir al directorio root
    let current_directory = pwd
    cd ../../

    #2. Realizar push
    git pull
    git add .
    git commit -m $"config: nuevo spoke - ($spoke_name)"
    git push

    #3. Retornar al CLI
    cd $current_directory
}

def "main github push spoke" [] {
    
}