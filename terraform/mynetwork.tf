resource "google_compute_network" "mygcpnet" {
  name = "mygcpnet"
  #auto_create_subnetworks = "true"
}

resource "google_compute_subnetwork" "mygcpsubnet" {
  name          = "mygcpsubnet"
  network       = google_compute_network.mygcpnet.id
  ip_cidr_range = "10.0.0.0/24"
  region        = "us-central1"
}



resource "google_compute_firewall" "mygcpnet-allow-http-ssh-rdp-icmp" {
  name    = "mygcpnet-allow-http-ssh-rdp-icmp"
  network = google_compute_network.mygcpnet.self_link
  allow {
    protocol = "tcp"
    ports    = ["22", "80", "3389"]
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
resource "google_project_iam_member" "isa-role-sourcereader" {

  member  = "serviceAccount:${google_service_account.isa.email}"
  role    = "roles/source.reader"
  project = var.project_id
}
