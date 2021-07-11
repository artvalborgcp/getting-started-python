resource "google_service_account" "isa" {
  project      = var.project_id
  account_id   = var.account_id
  display_name = "ServiceAccount for compute_instance"
}


resource "google_project_iam_member" "isa_roles" {
  depends_on = [google_service_account.isa]
  for_each   = var.roles_for_gcp
  role       = each.value
  member     = "serviceAccount:${google_service_account.isa.email}"

}
