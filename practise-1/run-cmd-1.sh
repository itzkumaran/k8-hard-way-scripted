k run busybox --image=busybox:1.28 $nr --rm -it -- wget -O- 10.200.0.10:80
kubectl run busybox --image=busybox --rm -it --restart=Never -- wget -O- $(kubectl get pod nginx -o jsonpath='{.status.podIP}:{.spec.containers[0].ports[0].containerPort}')
