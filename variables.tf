variable "namespace" {
  description = "Kubernetes namespace for your team"
  type        = string
}

variable "team_name" {
  description = "Human-readable team name"
  type        = string
}

variable "environment" {
  description = "Deployment environment"
  type        = string
  default     = "production"
}

variable "api_replicas" {
  description = "Number of API replicas"
  type        = number
  default     = 1
}

variable "api_image" {
  description = "API backend container image"
  type        = string
}

variable "frontend_image" {
  description = "Frontend container image"
  type        = string
}
variable "redis_image" {
  description = "Redis container image"
  type        = string
  default     = "redis:7-alpine"
}
