Demo: Terraform with Docker
====
Provide a nginx Docker container managed by Terraform

## General information

This demo setup provides a minimal Terraform setup to use it with Docker via remote API.
For Mac users we provide a simple shell script named `start_docker_socket.sh` to start a Docker container, which expose the Docker remote API.
It uses socat to expose the Docker daemon unix socket on a configured listen port.

The reason for the hack can be found on the offical Docker known-issues page (https://docs.docker.com/docker-for-mac/troubleshoot/#/known-issues).

## Requirements

To use the demo you need a running Docker daemon, connection to the used Docker registry and some disk space.
On the first usage the Docker daemon will catch all configured Docker image from the Docker registries (locally, remote running or from the internet).

Please use the offical documentation to install and configure your Docker setup.
[https://docs.docker.com](https://docs.docker.com/)

## Demo Usage

Note: Please check your environment to provide a running docker daemon and service!
Any Docker specific commands or deep dives are not listed or explained in this howto file.

As a Mac user please start the script `start_docker_socket.sh` as your first task. It is important to remember the configured and exposed listen port for the Terraform configuration.
The default configuration exposes the port on the localhost (loopback interface) with port 1234.

Start a shell (best: bash/zsh) and change into your demo folder named `docker` and modify the Terraform file `foo_nginx.tf` to support your environment.
After editing and checking the configuration you can check the Terraform configuration with the command `terraform plan`.
```
terraform plan

Refreshing Terraform state in-memory prior to plan...
The refreshed state will be used to calculate this plan, but
will not be persisted to local or remote state storage.


The Terraform execution plan has been generated and is shown below.
Resources are shown in alphabetical order for quick scanning. Green resources
will be created (or destroyed and then created if an existing resource
exists), yellow resources are being changed in-place, and red resources
will be destroyed. Cyan entries are data sources to be read.

Note: You didn't specify an "-out" parameter to save this plan, so when
"apply" is called, Terraform can't guarantee this is what will execute.

+ docker_container.foo-nginx
    bridge:                    "<computed>"
    gateway:                   "<computed>"
    hostname:                  "foonginx1"
    image:                     "${docker_image.nginx.latest}"
    ip_address:                "<computed>"
    ip_prefix_length:          "<computed>"
    log_driver:                "json-file"
    must_run:                  "true"
    name:                      "foo-nginx-1"
    ports.#:                   "1"
    ports.3862886908.external: "8080"
    ports.3862886908.internal: "80"
    ports.3862886908.ip:       ""
    ports.3862886908.protocol: "tcp"
    restart:                   "no"

+ docker_image.nginx
    latest: "<computed>"
    name:   "nginx:1.11-alpine"


Plan: 2 to add, 0 to change, 0 to destroy.
```

To apply the example type the command `terraform apply` in your shell and press ENTER.
```
terraform apply

docker_image.nginx: Refreshing state... (ID: sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8nginx:1.11-alpine)
docker_container.foo-nginx: Creating...
  bridge:                    "" => "<computed>"
  gateway:                   "" => "<computed>"
  hostname:                  "" => "foonginx1"
  image:                     "" => "sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8"
  ip_address:                "" => "<computed>"
  ip_prefix_length:          "" => "<computed>"
  log_driver:                "" => "json-file"
  must_run:                  "" => "true"
  name:                      "" => "foo-nginx-1"
  ports.#:                   "" => "1"
  ports.3862886908.external: "" => "8080"
  ports.3862886908.internal: "" => "80"
  ports.3862886908.ip:       "" => ""
  ports.3862886908.protocol: "" => "tcp"
  restart:                   "" => "no"
docker_container.foo-nginx: Creation complete

Apply complete! Resources: 1 added, 0 changed, 0 destroyed.

The state of your infrastructure has been saved to the path
below. This state is required to modify and destroy your
infrastructure, so keep it safe. To inspect the complete state
use the `terraform show` command.

State path: terraform.tfstate
```

Now, you can check with `terraform show` your example state and variables output.
```
terraform show

docker_container.foo-nginx:
  id = b6cd969b3b4f924c3676ce2d25258f3f79a5686e29e7dc247c8a079f294ed774
  bridge =
  gateway = 172.17.0.1
  hostname = foonginx1
  image = sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8
  ip_address = 172.17.0.3
  ip_prefix_length = 16
  log_driver = json-file
  must_run = true
  name = foo-nginx-1
  ports.# = 1
  ports.3862886908.external = 8080
  ports.3862886908.internal = 80
  ports.3862886908.ip =
  ports.3862886908.protocol = tcp
  restart = no
docker_image.nginx:
  id = sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8nginx:1.11-alpine
  latest = sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8
  name = nginx:1.11-alpine
```

Open your browser and test your running webserver in a Docker container.
Type the following address in your browser:
[http://localhost:8080](http://localhost:8080)
As a response you will see the default nginx webserver site in your browser.

That is it!

With `terraform destroy` and the confirm process you can destroy the example on your Docker service.
```
Do you really want to destroy?
  Terraform will delete all your managed infrastructure.
  There is no undo. Only 'yes' will be accepted to confirm.

  Enter a value: yes

docker_image.nginx: Refreshing state... (ID: sha256:f35b49deb2349424e52b3a71ccae12ec6690c1f464fa061aaf63f76900d515a8nginx:1.11-alpine)
docker_container.foo-nginx: Refreshing state... (ID: b6cd969b3b4f924c3676ce2d25258f3f79a5686e29e7dc247c8a079f294ed774)
docker_container.foo-nginx: Destroying...
docker_container.foo-nginx: Destruction complete
docker_image.nginx: Destroying...
docker_image.nginx: Destruction complete

Destroy complete! Resources: 2 destroyed.
```


### todo
- extend the mac helper script to provide start and stop as options

