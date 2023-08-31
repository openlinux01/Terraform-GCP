# Copyright (c) HashiCorp, Inc.
# SPDX-License-Identifier: MPL-2.0

variable "gke_username" {
  default     = ""
  description = "gke username"
}

variable "gke_password" {
  default     = ""
  description = "gke password"
}

variable "gke_num_nodes" {
  default     = 2
  description = "number of gke nodes"
}

# GKE cluster
data "google_container_engine_versions" "gke_version" {
  location = "us-central1-f"
  version_prefix = "1.27."
}

resource "google_container_cluster" "primary" {
  name     = "${var.project_id}-gke"
  location = "us-central1-a"
    # node_locations = ["us-central1-a"]

  # We can't create a cluster with no node pool defined, but we want to only use
  # separately managed node pools. So we create the smallest possible default
  # node pool and immediately delete it.
  remove_default_node_pool = true
  initial_node_count       = 1

  network    = google_compute_network.vpc.name
  subnetwork = google_compute_subnetwork.subnet.name

    node_config {
        disk_type = "pd-standard"
    disk_size_gb = 50
    }
}

# Separately Managed Node Pool
resource "google_container_node_pool" "primary_nodes" {
  name       = google_container_cluster.primary.name
  location   = "us-central1-a"
  cluster    = google_container_cluster.primary.name
  
  version = data.google_container_engine_versions.gke_version.release_channel_latest_version["STABLE"]
  node_count = var.gke_num_nodes

  node_config {
         disk_type = "pd-standard"
    disk_size_gb = 50
    oauth_scopes = [
      "https://www.googleapis.com/auth/logging.write",
      "https://www.googleapis.com/auth/monitoring",
    ]

    labels = {
      env = var.project_id
    }
    

    # preemptible  = true
    machine_type = "e2-medium"
    tags         = ["gke-node", "${var.project_id}-gke"]
        # disk_size_gb = 20
    metadata = {
      disable-legacy-endpoints = "true"
    }
  }
}
