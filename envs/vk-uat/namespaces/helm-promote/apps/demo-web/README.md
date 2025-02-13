
# Manifest Hydration

To hydrate the manifests in this repository, run the following commands:

```shell

git clone https://github.com/ixxeL-DevOps/GitOps-apps.git
# cd into the cloned directory
git checkout a34a380c9cd9b2b4fca8fc9822b5ae0f37a80b0e
helm template . --name-template hydrator-app --include-crds
```