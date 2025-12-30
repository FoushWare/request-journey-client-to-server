job "notes-app" {
  datacenters = ["dc1"]
  type = "service"

  group "backend" {
    count = 2

    network {
      port "http" {
        to = 5000
      }
    }

    service {
      name = "notes-app-backend"
      port = "http"
      
      check {
        type = "http"
        path = "/health"
        interval = "10s"
        timeout = "2s"
      }
    }

    task "backend" {
      driver = "docker"

      config {
        image = "notes-app-backend:latest"
        ports = ["http"]
      }

      env {
        DB_HOST = "postgresql"
        DB_PORT = "5432"
        PORT = "5000"
      }

      resources {
        cpu = 500
        memory = 512
      }
    }
  }

  group "frontend" {
    count = 2

    network {
      port "http" {
        to = 3000
      }
    }

    service {
      name = "notes-app-frontend"
      port = "http"
      
      check {
        type = "http"
        path = "/health"
        interval = "10s"
        timeout = "2s"
      }
    }

    task "frontend" {
      driver = "docker"

      config {
        image = "notes-app-frontend:latest"
        ports = ["http"]
      }

      env {
        API_URL = "http://notes-app-backend:5000"
        PORT = "3000"
      }

      resources {
        cpu = 200
        memory = 256
      }
    }
  }
}

