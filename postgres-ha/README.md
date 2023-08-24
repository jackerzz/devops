# 参考资料
- [postgres-ha-on-kubernetes](https://lqingcloud.cn/post/postgres-ha-on-kubernetes/)
- [k8s-ha](https://www.cnblogs.com/lfl17718347843/p/16080054.html)


# 目录结构

postgres-ha
├── postgres # PostgreSQL StatefulSet
│   └── postgres.yaml 
├── service.yaml # Service和Endpoint对象  
├── pvc.yaml # PV和PVC
├── postgres-monitor.yaml
└── README.md # 文档说明



好的,针对我们编写的postgres-ha.yaml文件,部署到Kubernetes集群的命令如下:

1. 创建Namespace:

```
kubectl create ns postgres-ha
```

2. 创建存储类:

```  
kubectl apply -f storageclass.yaml
```

storageclass.yaml中定义NFS或其他存储类。

3. 创建StatefulSet:

```
kubectl -n postgres-ha apply -f postgres-ha.yaml
``` 

4. 获取Pod IP并生成Endpoints:

```
# 获取Pod IP
primary_ip=$(kubectl -n postgres-ha get pod postgres-0 -o jsonpath='{.status.podIP}')
standby_ip=$(kubectl -n postgres-ha get pod postgres-1 -o jsonpath='{.status.podIP}')

# 生成Endpoint对象
kubectl -n postgres-ha apply -f endpoint.yaml
```

endpoint.yaml中定义端点,使用模板注入Pod IP。

5. 配置服务和ingress暴露访问:

```  
kubectl -n postgres-ha apply -f service.yaml
kubectl -n postgres-ha apply -f ingress.yaml
```

至此PostgreSQL高可用集群部署完成。我们可以验证服务运行状态和进行故障测试。

请您确认我描述的部署步骤是否准确完整。如果有任何疑问或建议,非常欢迎提出!


## 本次搭建流程(30分钟完成1个主节点2个子节点的k8s集群搭建)

export KKZONE=cn
curl -sfL https://get-kk.kubesphere.io | VERSION=v2.2.2 sh -
./kk create config --with-kubesphere
vi config-sample.yaml

yum install -y tcp_wrappers tcp_wrappers-devel readline-devel openssl-devel gcc socat conntrack ebtables ipset
yum install socat conntrack ebtables ipset
./kk create cluster -f config-sample.yaml

```yaml

apiVersion: kubekey.kubesphere.io/v1alpha2
kind: Cluster
metadata:
  name: sample
spec:
  hosts:
  - {name: master, address: 192.168.95.111, internalAddress: 192.168.95.111, user: root, password: '123456'}
  - {name: node1, address: 192.168.95.112, internalAddress: 192.168.95.112, user: root, password: '123456'}
  - {name: node2, address: 192.168.95.113, internalAddress: 192.168.95.113, user: root, password: '123456'}
  roleGroups:
    etcd:
    - master
    control-plane: 
    - master
    worker:
    - node1
    - node2
  controlPlaneEndpoint:
    ## Internal loadbalancer for apiservers 
    # internalLoadbalancer: haproxy

    domain: lb.kubesphere.local
    address: ""
    port: 6443
  kubernetes:
    version: v1.23.8
    clusterName: cluster.local
    autoRenewCerts: true
    containerManager: docker
  etcd:
    type: kubekey
  network:
    plugin: calico
    kubePodsCIDR: 10.233.64.0/18
    kubeServiceCIDR: 10.233.0.0/18
    ## multus support. https://github.com/k8snetworkplumbingwg/multus-cni
    multusCNI:
      enabled: false
  registry:
    privateRegistry: ""
    namespaceOverride: ""
    registryMirrors: []
    insecureRegistries: []
  addons: []



---
apiVersion: installer.kubesphere.io/v1alpha1
kind: ClusterConfiguration
metadata:
  name: ks-installer
  namespace: kubesphere-system
  labels:
    version: v3.3.0
spec:
  persistence:
    storageClass: ""
  authentication:
    jwtSecret: ""
  zone: ""
  local_registry: ""
  namespace_override: ""
  # dev_tag: ""
  etcd:
    monitoring: false
    endpointIps: localhost
    port: 2379
    tlsEnable: true
  common:
    core:
      console:
        enableMultiLogin: true
        port: 30880
        type: NodePort
    # apiserver:
    #  resources: {}
    # controllerManager:
    #  resources: {}
    redis:
      enabled: false
      volumeSize: 2Gi
    openldap:
      enabled: false
      volumeSize: 2Gi
    minio:
      volumeSize: 20Gi
    monitoring:
      # type: external
      endpoint: http://prometheus-operated.kubesphere-monitoring-system.svc:9090
      GPUMonitoring:
        enabled: false
    gpu:
      kinds:
      - resourceName: "nvidia.com/gpu"
        resourceType: "GPU"
        default: true
    es:
      # master:
      #   volumeSize: 4Gi
      #   replicas: 1
      #   resources: {}
      # data:
      #   volumeSize: 20Gi
      #   replicas: 1
      #   resources: {}
      logMaxAge: 7
      elkPrefix: logstash
      basicAuth:
        enabled: false
        username: ""
        password: ""
      externalElasticsearchHost: ""
      externalElasticsearchPort: ""
  alerting:
    enabled: false
    # thanosruler:
    #   replicas: 1
    #   resources: {}
  auditing:
    enabled: false
    # operator:
    #   resources: {}
    # webhook:
    #   resources: {}
  devops:
    enabled: false
    # resources: {}
    jenkinsMemoryLim: 2Gi
    jenkinsMemoryReq: 1500Mi
    jenkinsVolumeSize: 8Gi
    jenkinsJavaOpts_Xms: 1200m
    jenkinsJavaOpts_Xmx: 1600m
    jenkinsJavaOpts_MaxRAM: 2g
  events:
    enabled: false
    # operator:
    #   resources: {}
    # exporter:
    #   resources: {}
    # ruler:
    #   enabled: true
    #   replicas: 2
    #   resources: {}
  logging:
    enabled: false
    logsidecar:
      enabled: true
      replicas: 2
      # resources: {}
  metrics_server:
    enabled: false
  monitoring:
    storageClass: ""
    node_exporter:
      port: 9100
      # resources: {}
    # kube_rbac_proxy:
    #   resources: {}
    # kube_state_metrics:
    #   resources: {}
    # prometheus:
    #   replicas: 1
    #   volumeSize: 20Gi
    #   resources: {}
    #   operator:
    #     resources: {}
    # alertmanager:
    #   replicas: 1
    #   resources: {}
    # notification_manager:
    #   resources: {}
    #   operator:
    #     resources: {}
    #   proxy:
    #     resources: {}
    gpu:
      nvidia_dcgm_exporter:
        enabled: false
        # resources: {}
  multicluster:
    clusterRole: none
  network:
    networkpolicy:
      enabled: false
    ippool:
      type: none
    topology:
      type: none
  openpitrix:
    store:
      enabled: false
  servicemesh:
    enabled: false
    istio:
      components:
        ingressGateways:
        - name: istio-ingressgateway
          enabled: false
        cni:
          enabled: false
  edgeruntime:
    enabled: false
    kubeedge:
      enabled: false
      cloudCore:
        cloudHub:
          advertiseAddress:
            - ""
        service:
          cloudhubNodePort: "30000"
          cloudhubQuicNodePort: "30001"
          cloudhubHttpsNodePort: "30002"
          cloudstreamNodePort: "30003"
          tunnelNodePort: "30004"
        # resources: {}
        # hostNetWork: false
      iptables-manager:
        enabled: true
        mode: "external"
        # resources: {}
      # edgeService:
      #   resources: {}
  terminal:
    timeout: 600
```