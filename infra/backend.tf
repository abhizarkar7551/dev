terraform {
  backend "gcs" {
    bucket  = "state-prod-7551"
    prefix  = "prod"
  }
}
