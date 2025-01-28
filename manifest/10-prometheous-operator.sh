kubectl create namespace monitoring
helm repo add prometheus-community https://prometheus-community.github.io/helm-charts
helm repo update
helm install prometheus-operator prometheus-community/kube-prometheus-stack -n monitoring
kubectl get pods -n monitoring
kubectl get svc -n monitoring
nohup kubectl port-forward svc/prometheus-operator-kube-p-prometheu -n monitoring 9090:9090 > prometheus-port-forward.log 2>&1 &
nohup kubectl port-forward svc/prometheus-operator-grafana -n monitoring 8080:80 > grafana-port-forward.log 2>&1 &
grafana_password=$(kubectl get secret prometheus-operator-grafana -n monitoring -o jsonpath="{.data.admin-password}" | base64 --decode)
echo "Run grafana on http://127.0.0.1:8080 and password is {grafana_password}"
echo "Run prometheous on http://127.0.0.1:9090"