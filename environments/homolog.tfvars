environment = "homolog"
cidr_vpc    = "10.1.0.0/16"

# Menos nodes que producao, para economizar credito do Learner Lab.
node_desired_size = 1
node_min_size     = 1
node_max_size     = 2

tags = {
  "Name" = "tech-challenge-homolog"
}
