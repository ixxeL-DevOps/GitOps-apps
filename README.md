# GitOps-apps
Repository dedicated to custom/home made applications with dynamic generation

## Structure

This repository is the ArgoCD application repository. It is used by developers applications and is based on a predefined structure allowing the dynamic creation of applications.

The structural pattern of folders is as follows:

- `<cluster>/<namespace>/<chart-name>/<application-name>`

```bash
.
└── <cluster>
    └── <namespace>
         ├── <chart-name>
         │   ├── <application-name>
         │   └── <application-name>
         └── <chart-name>
             ├── <application-name>
             └── <application-name>
```

This structure works for any type of `helm chart` and will be coupled to `ArgoCD ImageUpdater` respecting the imposed structure. It is extremely important to be rigorous about naming because all automation is based on it.

- `cluster`: Do not modify the name of this folder, this is a core ArgoCD parameter for creating applications.
- `namespace`: This section is important to send your application in the correct kubernetes namespace.
- `chart-name`: You must name this folder exactly like the name of the helm chart you are using. It is also the name of the root key of `values.yaml` and the dependency of `Chart.yaml`. If the name is incorrect, the ImageUpdater part will be broken.
- `application-name`: This information will determine the name of your application in ArgoCD and in the cluster. The application name is automatically prefixed with `quanti` and sometimes suffixed with `dev` or `stg` or `prd` depending on the case. The prefix and suffix are automatic; you don't need to predict them.

The framework also accepts `plain YAML` deployments. To do this, simply consider the `<chart-name>` element as a folder to ignore, for example:

```bash
.
└── <cluster>
    └── <namespace>
         ├── <chart-name>
         │   ├── <application-name>
         │   └── <application-name>
         └── plain-yaml
             ├── <application-name>
             └── <application-name>
```

Real example:

```bash
└── prod
    └── backend
        ├── connectors
        │   ├── api
        │   │   ├── .argocd-source-api.yaml
        │   │   ├── Chart.yaml
        │   │   └── values.yaml
        │   └── orchestrator
        │       ├── .argocd-source-orchestrator.yaml
        │       ├── Chart.yaml
        │       └── values.yaml
        └── plain-yaml
            └── istio-certificates
                └── certs.yaml
```
N.B: If the structure is not respected, the behavior of ArgoCD will not be as expected. Either the application is not created, or side effects will be observed.

## Applications

### Creation

Vos applications doivent etre creees dans des sous-dossiers portant le nom de l'application comme explique plus haut. Par exemple `adobe-datasource`. Pas besoin de prefixer avec `quanti`, ce prefix est ajoute automatiquement par le process de creation automatique. Un suffixe sera egalement ajoute automatiquement en fonction du dossier dans lequel vous creez votre application (voir plus haut).

Pour creer une application de type helm, il y a plusieurs methodes mais l'approche recommandee est d'utiliser une umbrella chart


Your applications must be created in subfolders bearing the application name as explained above. For example `api`.

To create a helm type application, there are several methods but the recommended approach is to use an umbrella chart


Here is an example of a `Chart.yaml` file to create an umbrella chart for an api connector:
```yaml
---
apiVersion: v2
name: connectors
type: application
version: 0.1.0
dependencies:
  - name: connectors
    version: 0.1.0
    repository: oci://europe-west9-docker.pkg.dev/example/charts
```

Il est important d'accompagner le fichier `Chart.yaml` d'un autre fichier `values.yaml` de maniere a override les parametres d'origine.

Dans votre fichier `values.yaml` vous pouvez specifier les valeurs que vous souhaiter pour personnaliser votre installation.

Pour gerer les updates automatiques via ArgoCD ImageUpdater, il faut egalement accompagner votre application d'un fichier supplementaire `.argocd-source-<appName>.yaml`. Ici, `<appName>` doit correspondre au nom final de votre application ArgoCD. Voici un exemple pour l'application `adobe-datasource`:



It is important to accompany the `Chart.yaml` file with another `values.yaml` file so as to override the original settings.

In your `values.yaml` file you can specify the values you want to personalize your installation.

To manage automatic updates via ArgoCD ImageUpdater, you must also accompany your application with an additional file `.argocd-source-<appName>.yaml`. Here, `<appName>` should match the final name of your ArgoCD application. Here is an example for the `api` application:


File `.argocd-source-api.yaml` :
```yaml
helm:
  parameters:
  - name: connectors.image.name
    value: europe-west9-docker.pkg.dev/example/docker/api
    forcestring: true
  - name: connectors.image.tag
    value: dev-54f1bb55
    forcestring: true
```

Ultimately the structure of your file should look like this:

```
api/
├── .argocd-source-api.yaml
├── Chart.yaml
└── values.yaml
```

/!\ An important thing to take into consideration for the `values.yaml`!!

This approach is an `umbrella chart` approach. This technique only defines dependencies in the `Chart.yaml`.
It is therefore necessary to adapt the `values.yaml` file compared to a classic helm installation.

You must indicate all the parameters of your application under the key corresponding to the dependency to which these keys belong.

Example:

```yaml
connectors:
  replicaCount: 1
  namespace: prod
  [...]
```

Here all the values in `values.yaml` are under the `connectors` key which refers to the name of my dependency in my `Chart.yaml` file.
