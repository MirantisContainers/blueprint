---
title: "Update a cluster"
draft: false
weight: 2
---

#### Update cluster

1. Add a wordpress addon to the `blueprint.yaml`:
   ```YAML
   - name: wordpress
     kind: helm
     enabled: true
     namespace: wordpress
     chart:
       name: wordpress
       repo: https://charts.bitnami.com/bitnami
       version: 18.0.11
   ```

2. Update your cluster with the updated blueprint:
   ```shell
   bctl update --config blueprint.yaml
   ```

3. Verify that the wordpress addon is installed and running:

   ```shell
   kubectl get pods --namespace wordpress
   ```

   ```shell
   NAME                           READY   STATUS      RESTARTS   AGE
   helm-install-wordpress-st8rh   0/1     Completed   0          2m58s
   wordpress-79d45fc94c-vg7n7     1/1     Running     0          2m49s
   wordpress-mariadb-0            1/1     Running     0          2m49s
   ```

4. Connect to the wordpress page. You can forward requests to the server by running:

   ```shell
   kubectl port-forward --namespace wordpress wordpress-79d45fc94c-vg7n7 8080:8080
   ```
   > This command will need to be left running in the background. It does not return.

You can then access the wordpress page at http://localhost:8080 in your browser.
