#!/bin/bash
file="envs/talos/namespaces/demo/apps/demo-web/Chart.yaml"
# for dep in $(yq e '.dependencies[]' $file)
# do 
#   echo $dep
# done

# yq e '.dependencies[]' "$file" | while read -r dep; do
#   DEP_NAME=$(echo "$dep" | yq e '.name' -)
#   DEP_VERSION=$(echo "$dep" | yq e '.version' -)
#   DEP_REPO=$(echo "$dep" | yq e '.repository' -)

#   echo "dep infos : name -> $DEP_NAME version -> $DEP_VERSION repo -> $DEP_REPO"
# done

yq eval '.dependencies[] | {"name": .name, "version": .version, "repository": .repository}' "$file" | while IFS= read -r line; do
  # Vérifier si c'est une ligne contenant une clé

  if [[ $line == *"name:"* ]]; then
    name=$(echo "$line" | cut -d':' -f2 | xargs)
  elif [[ $line == *"version:"* ]]; then
    version=$(echo "$line" | cut -d':' -f2 | xargs)
  elif [[ $line == *"repository:"* ]]; then
    repository=$(echo "$line" | cut -d':' -f2 | xargs)

    # Afficher les infos une fois qu'on a trouvé le repository
    echo "Name: $name"
    echo "Version: $version"
    echo "Repository: $repository"
    echo "END"
  fi
done
