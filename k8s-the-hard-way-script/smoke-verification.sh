
echo "============== List the containers running under gVisor:"
sudo runsc --root  /run/containerd/runsc/k8s.io list
echo "============== output should be like this"
cat << EOF
I0930 19:27:13.255142   20832 x:0] ***************************
I0930 19:27:13.255326   20832 x:0] Args: [runsc --root /run/containerd/runsc/k8s.io list]
I0930 19:27:13.255386   20832 x:0] Git Revision: 50c283b9f56bb7200938d9e207355f05f79f0d17
I0930 19:27:13.255429   20832 x:0] PID: 20832
I0930 19:27:13.255472   20832 x:0] UID: 0, GID: 0
I0930 19:27:13.255591   20832 x:0] Configuration:
I0930 19:27:13.255654   20832 x:0]              RootDir: /run/containerd/runsc/k8s.io
I0930 19:27:13.255781   20832 x:0]              Platform: ptrace
I0930 19:27:13.255893   20832 x:0]              FileAccess: exclusive, overlay: false
I0930 19:27:13.256004   20832 x:0]              Network: sandbox, logging: false
I0930 19:27:13.256128   20832 x:0]              Strace: false, max size: 1024, syscalls: []
I0930 19:27:13.256238   20832 x:0] ***************************
ID                                                                 PID         STATUS      BUNDLE                                                                                                                   CREATED                OWNER
79e74d0cec52a1ff4bc2c9b0bb9662f73ea918959c08bca5bcf07ddb6cb0e1fd   20449       running     /run/containerd/io.containerd.runtime.v1.linux/k8s.io/79e74d0cec52a1ff4bc2c9b0bb9662f73ea918959c08bca5bcf07ddb6cb0e1fd   0001-01-01T00:00:00Z
af7470029008a4520b5db9fb5b358c65d64c9f748fae050afb6eaf014a59fea5   20510       running     /run/containerd/io.containerd.runtime.v1.linux/k8s.io/af7470029008a4520b5db9fb5b358c65d64c9f748fae050afb6eaf014a59fea5   0001-01-01T00:00:00Z
I0930 19:27:13.259733   20832 x:0] Exiting with status: 0
EOF

echo "============== Get the ID of the untrusted pod:"
POD_ID=$(sudo crictl -r unix:///var/run/containerd/containerd.sock \
  pods --name untrusted -q)

echo "============== Get the ID of the webserver container running in the untrusted pod:"
CONTAINER_ID=$(sudo crictl -r unix:///var/run/containerd/containerd.sock \
  ps -p ${POD_ID} -q)

echo "============== Use the gVisor runsc command to display the processes running inside the webserver container:"
sudo runsc --root /run/containerd/runsc/k8s.io ps ${CONTAINER_ID}

echo "============== output should be like this"
cat << EOF
I0930 19:31:31.419765   21217 x:0] ***************************
I0930 19:31:31.419907   21217 x:0] Args: [runsc --root /run/containerd/runsc/k8s.io ps af7470029008a4520b5db9fb5b358c65d64c9f748fae050afb6eaf014a59fea5]
I0930 19:31:31.419959   21217 x:0] Git Revision: 50c283b9f56bb7200938d9e207355f05f79f0d17
I0930 19:31:31.420000   21217 x:0] PID: 21217
I0930 19:31:31.420041   21217 x:0] UID: 0, GID: 0
I0930 19:31:31.420081   21217 x:0] Configuration:
I0930 19:31:31.420115   21217 x:0]              RootDir: /run/containerd/runsc/k8s.io
I0930 19:31:31.420188   21217 x:0]              Platform: ptrace
I0930 19:31:31.420266   21217 x:0]              FileAccess: exclusive, overlay: false
I0930 19:31:31.420424   21217 x:0]              Network: sandbox, logging: false
I0930 19:31:31.420515   21217 x:0]              Strace: false, max size: 1024, syscalls: []
I0930 19:31:31.420676   21217 x:0] ***************************
UID       PID       PPID      C         STIME     TIME      CMD
0         1         0         0         19:26     10ms      app
I0930 19:31:31.422022   21217 x:0] Exiting with status: 0
EOF

