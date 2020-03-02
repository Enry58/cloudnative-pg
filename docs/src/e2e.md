To ensure that Cloud Native PostgreSQL is able to act correctly while deploying
and managing PostgreSQL clusters, the operator is automatically tested after each
commit via a suite of **End-to-end (E2E) tests**.

Moreover, the following Kubernetes versions are tested for each commit,
ensuring failure and bugs detection at an early stage of the development
process:

* 1.17
* 1.16
* 1.15

For each tested version of Kubernetes, a Kubernetes cluster is created
using [kind](https://kind.sigs.k8s.io/), and the following suite of
E2E tests are performed on that cluster:

* Installation of the operator;
* Creation of a `Cluster`;
* Usage of a persistent volume for data storage;
* Scale-up of a `Cluster`;
* Scale-down of a `Cluster`;
* Failover;
* Switchover.