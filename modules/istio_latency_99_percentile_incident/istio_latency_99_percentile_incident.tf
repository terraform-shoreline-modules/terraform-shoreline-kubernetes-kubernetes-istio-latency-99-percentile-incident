resource "shoreline_notebook" "istio_latency_99_percentile_incident" {
  name       = "istio_latency_99_percentile_incident"
  data       = file("${path.module}/data/istio_latency_99_percentile_incident.json")
  depends_on = [shoreline_action.invoke_istio_resource_check,shoreline_action.invoke_scale_deployment]
}

resource "shoreline_file" "istio_resource_check" {
  name             = "istio_resource_check"
  input_file       = "${path.module}/data/istio_resource_check.sh"
  md5              = filemd5("${path.module}/data/istio_resource_check.sh")
  description      = "Resource constraints: The Istio service may be experiencing resource constraints. For example, if there are not enough resources allocated to the service, it could result in increased latency."
  destination_path = "/agent/scripts/istio_resource_check.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_file" "scale_deployment" {
  name             = "scale_deployment"
  input_file       = "${path.module}/data/scale_deployment.sh"
  md5              = filemd5("${path.module}/data/scale_deployment.sh")
  description      = "Scale up or down resources as necessary to ensure optimal system performance."
  destination_path = "/agent/scripts/scale_deployment.sh"
  resource_query   = "host"
  enabled          = true
}

resource "shoreline_action" "invoke_istio_resource_check" {
  name        = "invoke_istio_resource_check"
  description = "Resource constraints: The Istio service may be experiencing resource constraints. For example, if there are not enough resources allocated to the service, it could result in increased latency."
  command     = "`chmod +x /agent/scripts/istio_resource_check.sh && /agent/scripts/istio_resource_check.sh`"
  params      = ["DEPLOYMENT_NAME","NAMESPACE"]
  file_deps   = ["istio_resource_check"]
  enabled     = true
  depends_on  = [shoreline_file.istio_resource_check]
}

resource "shoreline_action" "invoke_scale_deployment" {
  name        = "invoke_scale_deployment"
  description = "Scale up or down resources as necessary to ensure optimal system performance."
  command     = "`chmod +x /agent/scripts/scale_deployment.sh && /agent/scripts/scale_deployment.sh`"
  params      = ["DEPLOYMENT_NAME","DESIRED_REPLICAS"]
  file_deps   = ["scale_deployment"]
  enabled     = true
  depends_on  = [shoreline_file.scale_deployment]
}

