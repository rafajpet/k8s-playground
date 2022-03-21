#!/bin/bash

# Nginx
NGINX_NS="frontend"
NGINX_VERSION="4.0.18"
NGINX_VALUES_PATH="./values/nginx.yaml"
# Monitoring
KUBE_PROMETHEUS_STACK_NS="monitoring"
KUBE_PROMETHEUS_STACK_VERSION="34.1.1"
KUBE_PROMETHEUS_STACK_VALUES_PATH="./values/kube-prometheus-stack.yaml"
# Loki
LOKI_NS="monitoring"
LOKI_VERSION="2.10.1"
LOKI_VALUES_PATH="./values/loki.yaml"
PROMTAIL_VERSION=3.11.0
PROMTAIL_VALUES_PATH="./values/promtail.yaml"

DEBUG=true
INSTALL_K3S=false
INSTALL_NGINX=false
INSTALL_KUBE_PROMETHEUS_STACK=false
INSTALL_LOKI=false
INSTALL_RESOURCES=false

debug() {
  if [ "$DEBUG" = true ] ; then
    echo "DEBUG: $@"
  fi
}

parse_inputs(){
  for i in "$@"
  do
  case ${i} in
      --k3s=*)
      INSTALL_K3S="${i#*=}"
      debug "K3s: ${INSTALL_K3S}"
      shift
      ;;
      --nginx=*)
      INSTALL_NGINX="${i#*=}"
      debug "Nginx: ${INSTALL_NGINX}"
      shift
      ;;
      --prometheus=*)
      INSTALL_KUBE_PROMETHEUS_STACK="${i#*=}"
      debug "Prometheus stack: ${INSTALL_KUBE_PROMETHEUS_STACK}"
      shift
      ;;
      --loki=*)
      INSTALL_LOKI="${i#*=}"
      debug "Loki: ${INSTALL_LOKI}"
      shift
      ;;
      --resources=*)
      INSTALL_RESOURCES="${i#*=}"
      debug "Resources: ${INSTALL_RESOURCES}"
      shift
      ;;
      *)
      debug "Parameter: ${i} not part of application"
      shift
      ;;
  esac
  done
}

install_k3s() {
  debug "Install latest k3s "
  sudo curl -sfL https://get.k3s.io | sh -s - --write-kubeconfig-mode 644 --disable=traefik
}

install_nginx(){
  debug "Install Nginx and create ns: ${NGINX_NS}"
  helm repo add ingress-nginx https://kubernetes.github.io/ingress-nginx
  helm repo update
  helm upgrade --install --create-namespace -n ${NGINX_NS} \
      ingress-nginx ingress-nginx/ingress-nginx \
      --version ${NGINX_VERSION} \
      -f ${NGINX_VALUES_PATH}
}

install_prometheus_stack(){
  debug "Install prometheus stack"
  helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
  helm repo update
  helm upgrade --install --create-namespace -n ${KUBE_PROMETHEUS_STACK_NS} \
  kube-prometheus-stack prometheus-community/kube-prometheus-stack \
  --version ${KUBE_PROMETHEUS_STACK_VERSION} \
  -f ${KUBE_PROMETHEUS_STACK_VALUES_PATH}
}

install_loki(){
  debug "Install loki"
  helm repo add grafana https://grafana.github.io/helm-charts
  helm repo update
  helm upgrade --install --create-namespace -n ${LOKI_NS} \
  loki grafana/loki \
  --version ${LOKI_VERSION} \
  -f ${LOKI_VALUES_PATH}
  helm upgrade --install -n ${LOKI_NS} \
  promtail grafana/promtail \
  --version ${PROMTAIL_VERSION} \
  -f ${PROMTAIL_VALUES_PATH}
}

install_resources(){
  debug "Install resources"
  kubectl apply -f ./resources/*
}


parse_inputs $@

if [ "$INSTALL_K3S" = true ] ; then
install_k3s
fi

debug "Export KUBECONFIG"
export KUBECONFIG=/etc/rancher/k3s/k3s.yaml

if [ "$INSTALL_NGINX" = true ] ; then
install_nginx
fi

if [ "$INSTALL_KUBE_PROMETHEUS_STACK" = true ] ; then
install_prometheus_stack
fi

if [ "$INSTALL_LOKI" = true ] ; then
install_loki
fi

if [ "$INSTALL_RESOURCES" = true ] ; then
install_resources
fi





