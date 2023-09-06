/** main.tf **/
moved {
  from = google_compute_network.vpc_network
  to = google_compute_network.vpc_network[0]
}

moved {
  from = google_compute_subnetwork.vpc_subnetwork
  to = google_compute_subnetwork.vpc_subnetwork[0]
}

moved {
  from = module.gke
  to = module.gke[0]
}

moved {
  from = kubernetes_namespace.bootstrap
  to = kubernetes_namespace.bootstrap[0]
}

moved {
  from = kubernetes_service_account.certmanager
  to = kubernetes_service_account.certmanager[0]
}

/** services.tf **/
moved {
  from = google_project_service.gcr
  to = google_project_service.gcr[0]
}

moved {
  from = google_project_service.container
  to = google_project_service.container[0]
}

moved {
  from = google_project_service.storage
  to = google_project_service.storage[0]
}

moved {
  from = google_project_service.dns
  to = google_project_service.dns[0]
}

moved {
  from = google_project_service.compute
  to = google_project_service.compute[0]
}
