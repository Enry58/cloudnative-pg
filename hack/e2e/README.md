# E2E testing

The E2E tests create a `kind` instance and run the tests inside it.
The tests can be run executing

``` bash
make e2e-test
```

from the project root directory if the host is allowed to run privileged
docker containers and to pull required images.

The following environment variables can be exported to change the behaviour
of the tests:

* `BUILD_IMAGE`: if `false` skip image building and just use existing `IMG`
* `CONTROLLER_IMG`: The image name to pull if `BUILD_IMAGE=false`
* `PRESERVE_CLUSTER`: do not remove the `kind` cluster after the end of the
  tests (default: `false`);
* `KIND_VERSION`: use a specific version of `kind` (default: use the latest);
* `KUBECTL_VERSION`: use a specific version of `kubectl` (default: use the
  latest);
* `K8S_VERSION`: the version of Kubernetes we are testing
* `DEBUG`: display the `bash` commands executed (default: `false`).