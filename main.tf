resource "azurerm_application_gateway" "agw_private" {
  name                = "${var.name}"
  location            = "${var.location}"
  resource_group_name = "${var.resource_group_name}"

  sku {
    name     = "${var.sku_size}"
    tier     = "${var.sku_tier}"
    capacity = "${var.sku_capacity}"
  }

  gateway_ip_configuration {
    name      = "${var.name}"
    subnet_id = "${var.gw_subnet_id}"
  }

  frontend_ip_configuration {
    name                          = "${var.frontend_name}"
    private_ip_address            = "${var.frontend_gw_ip}"
    private_ip_address_allocation = "${var.frontend_ip_allocation}"
    subnet_id                     = "${var.frontend_subnet_id}"
  }

  frontend_port {
    name = "${var.frontend_port_name}"
    port = "${var.fe_port}"
  }

  # APP
  backend_address_pool {
    name = "${var.backend_pool_name}"
  }

  http_listener {
    name                           = "${var.http_listener_name}"
    frontend_ip_configuration_name = "${var.frontend_name}"
    frontend_port_name             = "${var.frontend_port_name}"
    protocol                       = "${var.http_listener_protocol}"
    host_name                      = "${var.http_listener_host_name}"
  }

  backend_http_settings {
    name                  = "${var.backend_http_settings_name}"
    cookie_based_affinity = "${var.backend_settings_affinity}"
    affinity_cookie_name  = "App-Specific-Cookie"
    port                  = "${var.backend_settings_port}"
    protocol              = "${var.backend_settings_protocol}"
    request_timeout       = "${var.backend_settings_request_timeout}"
    probe_name            = "${var.backend_settings_probe_name}"
  }

  request_routing_rule {
    name                       = "${local.identifier}APMAGW02-RQ-RT-APP"
    rule_type                  = "Basic"
    http_listener_name         = "${local.identifier}APMAGW02-HTTP-LSTN-APP"
    backend_address_pool_name  = "${local.identifier}APMAGW02-BE-AP-APP"
    backend_http_settings_name = "${local.identifier}APMAGW02-BE-HTST-APP"
  }

  # Redirect Configuration 
  #Redirect 80 to 443
  redirect_configuration {
    name                 = "${var.region}${var.environment}${var.application}${var.agw_02}-App-Specific-Name"
    redirect_type        = "Permanent"
    target_listener_name = "${var.region}${var.environment}${var.application}${var.agw_02}-HTTPS-LISTENER-NAME"
    include_path         = true                                                                                 # Mandatory Attribute
    include_query_string = true                                                                                 # Mandatory Attribute
  }

  request_routing_rule {
    name                        = "${var.region}${var.environment}${var.application}${var.agw_02}-RQ-RT-App-Specific-Name"
    rule_type                   = "Basic"
    http_listener_name          = "${var.region}${var.environment}${var.application}${var.agw_02}-HTTP-LISTER-NAME"
    redirect_configuration_name = "${var.region}${var.environment}${var.application}${var.agw_02}-App-Specific-Name"
  }

  probe {
    name                = "${local.identifier}APMAGW02-HP-APP"
    host                = "${local.environment["apm_app_host_name"]}"
    protocol            = "Http"
    path                = "/hello.html"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    minimum_servers     = 0
  }

  # LOG
  backend_address_pool {
    name = "${local.identifier}APMAGW02-BE-AP-LOG"
  }

  http_listener {
    name                           = "${local.identifier}APMAGW02-HTTP-LSTN-LOG"
    frontend_ip_configuration_name = "${local.identifier}APMAGW02-FE-IP"
    frontend_port_name             = "${local.identifier}APMAGW02-FE-PORT-HTTP"
    protocol                       = "Http"
    host_name                      = "${local.environment["apm_log_host_name"]}"
  }

  backend_http_settings {
    name                  = "${local.identifier}APMAGW02-BE-HTST-LOG"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 300
  }

  request_routing_rule {
    name                       = "${local.identifier}APMAGW02-RQ-RT-LOG"
    rule_type                  = "Basic"
    http_listener_name         = "${local.identifier}APMAGW02-HTTP-LSTN-LOG"
    backend_address_pool_name  = "${local.identifier}APMAGW02-BE-AP-LOG"
    backend_http_settings_name = "${local.identifier}APMAGW02-BE-HTST-LOG"
  }

  # SVC
  backend_address_pool {
    name = "${local.identifier}APMAGW02-BE-AP-SVC"
  }

  http_listener {
    name                           = "${local.identifier}APMAGW02-HTTP-LSTN-SVC"
    frontend_ip_configuration_name = "${local.identifier}APMAGW02-FE-IP"
    frontend_port_name             = "${local.identifier}APMAGW02-FE-PORT-HTTP"
    protocol                       = "Http"
    host_name                      = "${local.environment["apm_svc_host_name"]}"
  }

  backend_http_settings {
    name                  = "${local.identifier}APMAGW02-BE-HTST-SVC"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 300
  }

  request_routing_rule {
    name                       = "${local.identifier}APMAGW02-RQ-RT-SVC"
    rule_type                  = "Basic"
    http_listener_name         = "${local.identifier}APMAGW02-HTTP-LSTN-SVC"
    backend_address_pool_name  = "${local.identifier}APMAGW02-BE-AP-SVC"
    backend_http_settings_name = "${local.identifier}APMAGW02-BE-HTST-SVC"
  }

  # ENG
  backend_address_pool {
    name = "${local.identifier}APMAGW02-BE-AP-ENG"
  }

  http_listener {
    name                           = "${local.identifier}APMAGW02-HTTP-LSTN-ENG"
    frontend_ip_configuration_name = "${local.identifier}APMAGW02-FE-IP"
    frontend_port_name             = "${local.identifier}APMAGW02-FE-PORT-HTTP"
    protocol                       = "Http"
    host_name                      = "${local.environment["apm_eng_host_name"]}"
  }

  backend_http_settings {
    name                  = "${local.identifier}APMAGW02-BE-HTST-ENG"
    cookie_based_affinity = "Disabled"
    port                  = 80
    protocol              = "Http"
    request_timeout       = 300
    probe_name            = "${local.identifier}APMAGW02-HP-ENG"
  }

  request_routing_rule {
    name                       = "${local.identifier}APMAGW02-RQ-RT-ENG"
    rule_type                  = "Basic"
    http_listener_name         = "${local.identifier}APMAGW02-HTTP-LSTN-ENG"
    backend_address_pool_name  = "${local.identifier}APMAGW02-BE-AP-ENG"
    backend_http_settings_name = "${local.identifier}APMAGW02-BE-HTST-ENG"
  }

  probe {
    name                = "${local.identifier}APMAGW02-HP-ENG"
    host                = "${local.environment["apm_eng_host_name"]}"
    protocol            = "Http"
    path                = "/hello.html"
    interval            = 30
    timeout             = 30
    unhealthy_threshold = 3
    minimum_servers     = 0
  }
}
