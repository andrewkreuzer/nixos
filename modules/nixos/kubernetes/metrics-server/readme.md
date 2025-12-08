# Metrics Server

### Known Issues
The front proxy cert is signed by a different CA than the cluster CA so in order
to correctly authenticate incoming requests this front proxy CA must be passed
in `--requestheader-client-ca-file=/ca/front-proxy-ca.crt`

More info can be found in the [known issues](https://github.com/kubernetes-sigs/metrics-server/blob/master/KNOWN_ISSUES.md#incorrectly-configured-front-proxy-certificate)
section of the metrics-server repo

Although the front proxy cert is specified by the api server argument `--requestheader-client-ca-file=${proxyClientCaFile}`
and is presented in the `extension-apiserver-authentication` configmap, the
metrics-server does not seem to load this correctly and so we must provide it
explicitly :(

### Fix

Create the front-proxy-ca configmap in the kube-system namespace

```
kubectl -nkube-system create configmap front-proxy-ca \
    --from-file=front-proxy-ca.crt=./pki/front-proxy-ca.pem -o yaml \
| kubectl -nkube-system replace configmap front-proxy-ca -f -
```

Mount it into the metrics-server

```
      - args:
        - --requestheader-client-ca-file=/ca/front-proxy-ca.crt // ADD THIS!
        - --cert-dir=/tmp
        - --secure-port=10250
        volumeMounts:
        - mountPath: /tmp
          name: tmp-dir
        - mountPath: /ca // ADD THIS!
          name: ca-dir

      volumes:
      - emptyDir: {}
        name: tmp-dir
      - configMap: // ADD THIS!
          defaultMode: 420
          name: front-proxy-ca
        name: ca-dir
```

