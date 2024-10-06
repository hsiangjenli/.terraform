terraform {
  required_providers {
    docker = {
      source  = "kreuzwerker/docker"
      version = "3.0.2"
    }
  }
}

provider "docker" {
  host = "unix:///var/run/docker.sock"
}

# == Build the Docker image ==

# -- Social Network Crawler --

resource "docker_image" "snc" {
  name = "hsiangjenli/snc:${local.current_date}"
  build {
    context    = local.path_social_network_crawler
    dockerfile = "Dockerfile.module"
    build_args = {
      MODULE_PATH = "."
    }
  }
  triggers = {
    dockerfile_hash   = filesha256("${local.path_social_network_crawler}/Dockerfile.module")
    requirements_hash = filesha256("${local.path_social_network_crawler}/requirements.txt")
  }
}

resource "docker_tag" "snc_latest" {
  source_image = docker_image.snc.image_id
  target_image = "hsiangjenli/snc:latest"
}