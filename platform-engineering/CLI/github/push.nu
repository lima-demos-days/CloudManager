def "main github push manager" [
    --spoke-name:string
] {
    #1. Ir al directorio root
    let current_directory = pwd
    cd ../../

    #2. Realizar push
    main git push --commit-msg=$"config: nuevo spoke - ($spoke_name)"

    #3. Retornar al CLI
    cd $current_directory
}

def "main github push spoke" [] {
    
}

#Ejecuta git-push dentro del repo
def "main git push" [
    --commit-msg:string
] {
    git pull
    git config --global user.email "jdarguello"
    git config --global user.name "Juan David Arguello"
    git add .
    git commit -m $commit_msg
    git push
}