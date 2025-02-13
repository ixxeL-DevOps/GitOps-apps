
# Manifest Hydration

To hydrate the manifests in this repository, run the following commands:

```shell

git clone https://github.com/ixxeL-DevOps/GitOps-apps.git
# cd into the cloned directory
git checkout 4fa19ea3eb8900a11ac04957c6760f2329d3edb7
helm template . --name-template hydrator-app --include-crds
```