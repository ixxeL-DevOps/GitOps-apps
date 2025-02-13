
# Manifest Hydration

To hydrate the manifests in this repository, run the following commands:

```shell

git clone https://github.com/ixxeL-DevOps/GitOps-apps.git
# cd into the cloned directory
git checkout 11c9957e50bc2b51108a160dd0057f1539dde075
helm template . --name-template hydrator-app --include-crds
```