
resource "google_compute_network" "mygcpnet" {
  project                 = var.project_id
  name                    = var.network_name
  auto_create_subnetworks = var.auto_create_subnetworks
}

resource "google_compute_subnetwork" "mygcpsubnet" {
  name          = "mygcpsubnet"
  network       = google_compute_network.mygcpnet.id
  ip_cidr_range = var.ip_cidr_range
  region        = var.region
  depends_on    = [google_compute_network.mygcpnet]

}



resource "google_compute_firewall" "mygcpnet-allow-http-ssh-rdp-icmp" {
  name    = "mygcpnet-allow-http-ssh-rdp-icmp"
  network = google_compute_network.mygcpnet.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "8080"]
  }
  allow {
    protocol = "icmp"
  }
}


resource "google_compute_router" "mygcprouter" {
  name    = "mygcprouter"
  region  = google_compute_subnetwork.mygcpsubnet.region
  network = google_compute_network.mygcpnet.id

  bgp {
    asn = 64514
  }
}

resource "google_compute_router_nat" "mygcpnat" {
  name                               = "mygcpnat"
  router                             = google_compute_router.mygcprouter.name
  region                             = google_compute_router.mygcprouter.region
  nat_ip_allocate_option             = "AUTO_ONLY"
  source_subnetwork_ip_ranges_to_nat = "ALL_SUBNETWORKS_ALL_IP_RANGES"
}


resource "google_project_default_service_accounts" "my_project" {
  project = var.project_id
  action  = var.action
}

resource "google_service_account" "isa" {
  project      = var.project_id
  account_id   = "compute-instance"
  display_name = "ServiceAccount for compute_instance"
}


resource "google_project_iam_member" "isa-role-storageobjectCreator" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/storage.objectCreator"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-storageobjectViewer" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/storage.objectViewer"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-datastoreuser" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/datastore.user"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-pubsub" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/pubsub.editor"
  project = var.project_id
}
resource "google_project_iam_member" "isa-role-sourcereader" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/source.reader"
  project = var.project_id
}
