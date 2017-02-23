# Datadrivers' Terraform demo with Docker
#

# Configure the Docker provider

# Remote docker API
provider "docker" {
    host = "tcp://127.0.0.1:1234/"
}

# Create a container
resource "docker_container" "foo-nginx" {
    image = "${docker_image.nginx.latest}"
    name = "foo-nginx-${count.index+1}"
    hostname = "foonginx${count.index+1}"
    must_run = "true" # everytime starts the container
    count = 1 # count of containers
    ports {
      # listen port for HTTP
      internal = "80"
      external = "8080"
    }
}
# docker nginx webserver image
resource "docker_image" "nginx" {
    name = "nginx:1.11-alpine"
}

