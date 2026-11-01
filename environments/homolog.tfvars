environment = "homolog"
cidr_vpc    = "10.1.0.0/16"

# Menos nodes que producao (max 2 vs 3), para economizar credito do Learner Lab.
# 2 nodes desejados: com 1 so t3.medium, app (2 pods) + New Relic (nri-bundle)
# + kube-system deixavam o node em ~95% de CPU reservada e o rollout travava
# sem espaco para o pod extra.
node_desired_size = 2
node_min_size     = 1
node_max_size     = 2

tags = {
  "Name" = "tech-challenge-homolog"
}
