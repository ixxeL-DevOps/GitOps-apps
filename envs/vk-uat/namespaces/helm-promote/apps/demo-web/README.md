
# Manifest Hydration

To hydrate the manifests in this repository, run the following commands:

```shell

git clone https://github.com/ixxeL-DevOps/GitOps-apps.git
# cd into the cloned directory
git checkout bd5b1d7435261d897265cdcd8a0906482dfea3be
helm template . --name-template hydrator-app --include-crds
```