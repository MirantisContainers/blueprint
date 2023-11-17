---
title: "Using an existing cluster"
draft: false
weight: 3
---

1. Install Boundless Operator
   ```shell
   kubectl apply -f https://raw.githubusercontent.com/mirantis/boundless/main/deploy/static/boundless-operator.yaml
   ```
2. Wait for boundless operator to be ready
   ```shell
   kubectl get deploy -n boundless-system
   NAME                                    READY   UP-TO-DATE   AVAILABLE   AGE
   boundless-operator-controller-manager   1/1     1            1           33s
   ```
3. Create a blueprint file `blueprint.yaml`:
   ```yaml
   apiVersion: boundless.mirantis.com/v1alpha1
   kind: Blueprint
   metadata:
     name: boundless-cluster
   spec:
    components:
      addons:
        - name: example-server
          kind: HelmAddon
          enabled: true
          namespace: default
          chart:
            name: nginx
            repo: https://charts.bitnami.com/bitnami
            version: 15.1.1
            values: |
              "service":
                "type": "ClusterIP"
   ```
   The above example installs a addon by specifying a helm chart
4. Apply the blueprint
   ```shell
   kubectl apply -f blueprint.yaml
   ```
5. After a while, the components specified in the blueprint will be installed:
   ```shell
   kubectl get deploy
   NAME    READY   UP-TO-DATE   AVAILABLE   AGE
   nginx   1/1     1            1           35s
   ```
