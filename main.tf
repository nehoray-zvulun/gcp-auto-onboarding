
module "project-factory" {
  source  = "terraform-google-modules/project-factory/google"
  version = "~> 14.1"

  name              = "CloudFlow-Onbording"
  project_id        = "cloudflow-onbording"
  random_project_id = true
  org_id            = var.org_id
  billing_account   = var.billing_account
  folder_id         = "196160025729"
  project_sa_name   = "cloudflow"
  activate_apis = [
    "compute.googleapis.com",
    "iam.googleapis.com",
    "storage.googleapis.com",
    "cloudresourcemanager.googleapis.com"
  ]
}

resource "google_service_account_key" "cf-key" {
  service_account_id = "projects/${module.project-factory.project_id}/serviceAccounts/${module.project-factory.service_account_unique_id}"
}

resource "google_organization_iam_custom_role" "cf-role" {
  role_id     = "cfrole"
  title       = "CloudFlow Role"
  description = "Custom role to grant the neccessary permissions to CloudFlow"
  org_id      = var.org_id

  permissions = [
    "compute.firewallPolicies.list",
    "resourcemanager.folders.get",
    "resourcemanager.folders.list",
    "resourcemanager.organizations.get",
    "resourcemanager.projects.get",
    "resourcemanager.projects.list", # used to list all assigned projects to the Service Account
    # following permissions are required for generate token for RestAPI
    "iam.serviceAccounts.getAccessToken", # for demo used to simulate AWS's asume role
  ]
}

data "http" "example_post" {
  url    = "https://xh814ojgch.execute-api.us-east-1.amazonaws.com/dev/api/cloudflow/onboarding-test/gcp"
  method = "POST"
  # Optional request headers
  request_headers = {
    Accept = "application/json"
  }
  # Optional request body
  request_body = "{key:'${base64decode(google_service_account_key.cf-key.private_key)}}'}"

  lifecycle {
    postcondition {
      condition     = contains([200, 201, 204], self.status_code)
      error_message = "Onboarding process failed"
    }
  }
}
