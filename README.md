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

Get grafana admin password:
```
./grafana-password.sh
```

Login to [http://monitoring.playground.local](http://monitoring.playground.local) via username/password: `admin/{output_from_previous_command}`

Export KUBECONFIG

```
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml
```

Delete whole cluster:

```
k3s-uninstall.sh
```