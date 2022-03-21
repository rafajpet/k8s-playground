# k8s-playground

## Start

Install k3s cluster + all required components:

```
./start-all.sh
```

Run `./setup-local-dns.sh` and  edit `/etc/hosts`
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

## Loki
    
Access loki via port-forward:
```
kubectl -n monitoring port-forward svc/loki 3100:3100
```

Query loki via cli:

```
logcli query '{namespace="frontend"}'
```