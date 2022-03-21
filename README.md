# k8s-playground

## Start

Install k3s cluster + all required components:

```
./start-all.sh
```

Run `./setup-local-dns.sh` and  `/etc/hosts`
```
./setup-local-dns.sh
```

Export KUBECONFIG

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

Get grafana admin password:
```
./grafana-password.sh
```

Login to [http://monitoring.playground.local](http://monitoring.playground.local) via username/password: `admin/{output_from_previous_command}`


Check kubectl context:

```
kubectl get pods -A
```

Delete whole cluster:

```
k3s-uninstall.sh
```