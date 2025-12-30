# Nomad Server Configuration
datacenter = "dc1"
data_dir = "/opt/nomad/data"
bind_addr = "0.0.0.0"

server {
  enabled = true
  bootstrap_expect = 1  # Single server for dev, use 3+ for production
}

client {
  enabled = true
}

# Consul integration (optional)
consul {
  address = "127.0.0.1:8500"
}

# Vault integration (optional)
vault {
  enabled = false
  address = "http://127.0.0.1:8200"
}

