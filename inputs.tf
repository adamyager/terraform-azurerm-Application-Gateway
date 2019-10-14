variable "name" {
  description = "App Gateway Name"
}

variable "location" {
  description = "Azure Location (e.g. North Central US)"
}

variable "resource_group_name" {
  description = "Resource Group Name"
}

variable "backend_http_settings_name" {
  description = "Backend HTTP Name"
}

variable "backend_settings_affinity" {
  description = "Backend Settings Cookie Based Affinity"
  default     = "Enabled"
}

variable "backend_settings_port" {
  description = "Backend Settings Port"
  default     = 80
}

variable "backend_settings_protocol" {
  description = "Backend Settings Protocol"
  default     = "Http"
}

variable "backend_settings_request_timeout" {
  description = "Backend Settings Request Timeout"
  default     = 300
}

variable "backend_http_settings_probe_name" {
  description = "Backend Settings Probe Name"
}

variable "backend_pool_name" {
  description = "Backend Pool Name"
}

variable "frontend_name" {
  description = "Frontend Name"
}

variable "frontend_gw_ip" {
  description = "Frontend Gateway IP"
}

variable "frontend_ip_allocation" {
  description = "Frontend IP Allocation"
  default     = "static"
}

variable "frontend_port_name" {
  description = "Frontend Port Name"
}

variable "frontend_port" {
  description = "Frontend Port"
  default     = 80
}

variable "frontend_subnet_id" {
  description = "Subnet ID for the frontend configuration"
}

variable "gw_subnet_id" {
  description = "Subnet ID for the gateway configuration"
}

variable "http_listener_name" {
  description = "HTTP Listener Name"
}

variable "http_listener_protocol" {
  description = "HTTP Listener Protocol"
  default     = "Http"
}

variable "http_listener_host_name" {
  description = "HTTP Listener Hostname"
}

variable "sku_size" {
  description = "AGW SKU Size (e.g Standard_Small)"
}

variable "sku_tier" {
  description = "AGW SKU Tier"
  default     = "Standard"
}

variable "sku_capacity" {
  description = "AGW SKU Capacity"
  default     = 2
}
