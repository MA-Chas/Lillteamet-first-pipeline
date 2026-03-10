# -----------------------------
# Namespace
# -----------------------------
resource "kubernetes_namespace" "lillteamet" {
  metadata {
    name = var.namespace
  }
}

# -----------------------------
# State migration (moved blocks)
# -----------------------------
moved {
  from = kubernetes_deployment.redis
  to   = module.redis.kubernetes_deployment.app
}

moved {
  from = kubernetes_service.redis
  to   = module.redis.kubernetes_service.app
}

moved {
  from = kubernetes_deployment.api
  to   = module.api.kubernetes_deployment.app
}

# -----------------------------
# Redis module
# -----------------------------
module "redis" {
  source    = "./modules/k8s-app"
  name      = "redis"
  namespace = var.namespace
  image     = var.redis_image
  port      = 6379

  cpu_request    = "100m"
  memory_request = "128Mi"
  cpu_limit      = "200m"
  memory_limit   = "256Mi"

  labels = {
    team        = var.team_name
    environment = var.environment
  }

  depends_on = [kubernetes_namespace.lillteamet]
}

# -----------------------------
# API module
# -----------------------------
module "api" {
  source    = "./modules/k8s-app"
  name      = "api"
  namespace = var.namespace
  image     = var.api_image
  port      = 3000
  replicas  = var.api_replicas

  env_vars = {
    REDIS_HOST = "redis-service"
    REDIS_PORT = "6379"
    NODE_ENV   = var.environment
  }

  labels = {
    environment = var.environment
  }

  depends_on = [kubernetes_namespace.lillteamet]
}

# -----------------------------
# Frontend module
# -----------------------------
module "frontend" {
  source    = "./modules/k8s-app"
  name      = "frontend"
  namespace = var.namespace
  image     = var.frontend_image
  port      = 80
  replicas  = 1

  labels = {
    environment = var.environment
  }

  depends_on = [kubernetes_namespace.lillteamet]
}
