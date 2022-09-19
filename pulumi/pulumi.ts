import * as pulumi from "@pulumi/pulumi";
import * as kubernetes from "@pulumi/kubernetes";

const ethGeth_anishDeployment = new kubernetes.apps.v1.Deployment("ethGeth_anishDeployment", {
    apiVersion: "apps/v1",
    kind: "Deployment",
    metadata: {
        name: "geth-anish",
        namespace: "eth",
        labels: {
            app: "geth-anish",
            project: "anish-task-1",
        },
    },
    spec: {
        replicas: 3,
        revisionHistoryLimit: 1,
        selector: {
            matchLabels: {
                app: "geth-anish",
                project: "anish-task-1",
            },
        },
        template: {
            metadata: {
                labels: {
                    app: "geth-anish",
                    project: "anish-task-1",
                },
            },
            spec: {
                containers: [{
                    name: "geth-anish",
                    image: "ethereum/client-go:v1.10.25",
                    imagePullPolicy: "IfNotPresent",
                    resources: {
                        limits: {
                            cpu: ".5",
                        },
                        requests: {
                            cpu: "0.25",
                        },
                    },
                    command: ["/bin/sh"],
                    args: [
                        "-c",
                        "geth --bootnodes=`cat /root/.ethereum/bootnodes` --mine --etherbase=0 --rpc --rpcapi=db,eth,net,web3,personal --rpcaddr=0.0.0.0 --rpccorsdomain='*' --ws --networkid=${NETWORK_ID} --ethstats=${HOSTNAME}:${ETHSTATS_SECRET}@${ETHSTATS_SVC} --verbosity=5",
                    ],
                    env: [
                        {
                            name: "ETHSTATS_SVC",
                            value: "ethstats",
                        },
                        {
                            name: "ETHSTATS_SECRET",
                            valueFrom: {
                                secretKeyRef: {
                                    name: "ethstats-secret",
                                    key: "WS_SECRET",
                                },
                            },
                        },
                        {
                            name: "NETWORK_ID",
                            valueFrom: {
                                configMapKeyRef: {
                                    name: "geth-config",
                                    key: "networkid",
                                },
                            },
                        },
                    ],
                    ports: [
                        {
                            name: "rpc",
                            containerPort: 8545,
                        },
                        {
                            name: "ws",
                            containerPort: 8546,
                        },
                        {
                            name: "discovery-udp",
                            containerPort: 30303,
                            protocol: "UDP",
                        },
                        {
                            name: "discovery-tcp",
                            containerPort: 30303,
                        },
                    ],
                    volumeMounts: [{
                        name: "data",
                        mountPath: "/root/.ethereum",
                    }],
                }],
                initContainers: [
                    {
                        name: "init-genesis",
                        image: "ethereum/client-go:v1.10.25",
                        imagePullPolicy: "IfNotPresent",
                        args: [
                            "init",
                            "/var/geth/genesis.json",
                        ],
                        volumeMounts: [
                            {
                                name: "data",
                                mountPath: "/root/.ethereum",
                            },
                            {
                                name: "config",
                                mountPath: "/var/geth",
                            },
                        ],
                    },
                    {
                        name: "create-account",
                        image: "ethereum/client-go:v1.10.25",
                        imagePullPolicy: "IfNotPresent",
                        command: ["/bin/sh"],
                        args: [
                            "-c",
                            `printf '$(ACCOUNT_SECRET)\n$(ACCOUNT_SECRET)\n' | geth account new`,
                        ],
                        env: [{
                            name: "ACCOUNT_SECRET",
                            valueFrom: {
                                secretKeyRef: {
                                    name: "geth-anish-secret",
                                    key: "accountsecret",
                                },
                            },
                        }],
                        volumeMounts: [{
                            name: "data",
                            mountPath: "/root/.ethereum",
                        }],
                    },
                    {
                        name: "get-bootnodes",
                        image: "ethereum/client-go:v1.10.25",
                        imagePullPolicy: "IfNotPresent",
                        command: ["/bin/sh"],
                        args: ["-c","|-
                          apk add --no-cache curl;
                          CNT=0;
                          echo "retreiving bootnodes from $BOOTNODE_REGISTRAR_SVC"
                          while [ $CNT -le 90 ]
                          do
                            curl -m 5 -s $BOOTNODE_REGISTRAR_SVC | xargs echo -n >> /geth/bootnodes;
                            if [ -s /geth/bootnodes ]
                            then
                              cat /geth/bootnodes;
                              exit 0;
                            fi;
                            echo "no bootnodes found. retrying $CNT...";
                            sleep 2 || break;
                            CNT=$((CNT+1));
                          done;
                          echo "WARNING. unable to find bootnodes. continuing but geth may not be able to find any peers.";
                          exit 0;"],
                        env: [{
                            name: "BOOTNODE_REGISTRAR_SVC",
                            value: "bootnode-registrar",
                        }],
                        volumeMounts: [{
                            name: "data",
                            mountPath: "/geth",
                        }],
                    },
                ],
                volumes: [
                    {
                        name: "data",
                        emptyDir: {},
                    },
                    {
                        name: "config",
                        configMap: {
                            name: "geth-config",
                        },
                    },
                ],
            },
        },
    },
});
