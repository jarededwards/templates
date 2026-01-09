variable "cluster_name" {
  description = "the name of the cluster"
  type        = string
}

variable "cluster_region" {
  description = "the region of the cluster"
  type        = string
}

variable "node_count" {
  description = "The node count for the node group"
  default     = "2"
  type        = string
}

variable "node_type" {
  description = "The node type of node group"
  default     = "t3.medium"
  type        = string
}

variable "ami_type" {
  description = "the ami type for node group"
  default = "AL2_x86_64"
  type = string
}

# ===== SYSTEM VARIABLES (passed from Helm values, not shown in UI) =====

variable "project_cluster_name" {
  description = "Management cluster name"
  type        = string
}

variable "project_aws_account_id" {
  description = "AWS Account ID for management cluster"
  type        = string
}

variable "dex_provider_name" {
  description = "DEX OIDC provider name"
  type        = string
  default     = ""
}

variable "dex_domain_name" {
  description = "DEX OIDC issuer domain name"
  type        = string
  default     = ""
}
