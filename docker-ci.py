#!/usr/bin/env python3
from typer import Typer,echo
from os import getcwd
from docker import from_env

app = Typer()

@app.command()
def build():
    """
    Construit l'image Docker de l'application
    """
    client = from_env()
    generator = client.api.build(
        path=getcwd(),  # Utilise le répertoire courant
        tag=tag,        # Applique le tag si fourni
        decode=True     # Décode la sortie
    )
    
    # Affiche les logs de construction en temps réel
    for chunk in generator:
        if 'stream' in chunk:
            for line in chunk['stream'].splitlines():
                print(line)
                
@app.command()
def publish(image, username = None, password = None):
    """
    Publie une image Docker sur la registry GitLab
    
    Args:
        image (str): Nom complet de l'image à publier (ex: registry.gitlab.com/group/project/image)
        username (str): Nom d'utilisateur pour l'authentification à la registry
        password (str): Mot de passe ou jeton pour l'authentification
        
    Example:
        Pour publier une image sur GitLab Container Registry:
        ```
        python3 docker-ci.py publish registry.gitlab.com/your-gitlab-group/your-gitlab-project/snapshot --username username_du_jeton --password jeton
        ```
    """
    client = from_env()
    generator = client.api.push(

        repository = image,
        # tag = tag or f'{APPLICATION_TAG}/{version}', 
        auth_config = {
            "username": username, 
            "password": password, 
        },
        stream = True,
        decode = True)

    for line in generator:
        print(line)

if __name__ == "__main__":
    app()