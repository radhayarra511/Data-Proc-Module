resource "google_dataproc_cluster" "cluster" {
  provider = google-beta
  name                          = var.dataproc_cluster_name
  region                        = var.region_name
  project                       = var.project_id
  graceful_decommission_timeout = var.graceful_decommission_timeout
  labels                        = var.labels

  dynamic "cluster_config" {
    for_each = var.cluster_config
    content {
      staging_bucket = lookup(cluster_config.value, "staging_bucket", null)
      temp_bucket    = lookup(cluster_config.value, "temp_bucket", null)

      dynamic "gce_cluster_config" {
        for_each = lookup(cluster_config.value, "gce_cluster_config", null) == null ? [] : [cluster_config.value.gce_cluster_config]
        content {
          zone                   = lookup(gce_cluster_config.value, "zone", null)
          network                = lookup(gce_cluster_config.value, "network", null)
          subnetwork             = lookup(gce_cluster_config.value, "subnetwork", null)
          service_account        = lookup(gce_cluster_config.value, "service_account", null)
          service_account_scopes = lookup(gce_cluster_config.value, "service_account_scopes", null)
          tags                   = lookup(gce_cluster_config.value, "tags", null)
          internal_ip_only       = lookup(gce_cluster_config.value, "internal_ip_only", null)
          metadata               = lookup(gce_cluster_config.value, "metadata", null)

          dynamic "shielded_instance_config" {
            for_each = lookup(gce_cluster_config.value, "shielded_instance_config", null) == null ? [] : [gce_cluster_config.value.shielded_instance_config]
            content {
              enable_secure_boot          = lookup(shielded_instance_config.value, "enable_secure_boot", null)
              enable_vtpm                 = lookup(shielded_instance_config.value, "enable_vtpm", null)
              enable_integrity_monitoring = lookup(shielded_instance_config.value, "enable_integrity_monitoring", null)
            }
          }
        }
      }

      dynamic "master_config" {
        for_each = lookup(cluster_config.value, "master_config", null) == null ? [] : [cluster_config.value.master_config]
        content {
          num_instances    = lookup(master_config.value, "num_instances", null)
          machine_type     = lookup(master_config.value, "machine_type", null)
          min_cpu_platform = lookup(master_config.value, "min_cpu_platform", null)
          image_uri        = lookup(master_config.value, "image_uri", null)

          dynamic "disk_config" {
            for_each = lookup(master_config.value, "disk_config", null) == null ? [] : [master_config.value.disk_config]
            content {
              boot_disk_type    = lookup(disk_config.value, "boot_disk_type", null)
              boot_disk_size_gb = lookup(disk_config.value, "boot_disk_size_gb", null)
              num_local_ssds    = lookup(disk_config.value, "num_local_ssds", null)
            }
          }
          dynamic "accelerators" {
            for_each = lookup(master_config.value, "accelerators", null) == null ? [] : [master_config.value.accelerators]
            content {
              accelerator_type  = lookup(accelerators.value, "accelerator_type", null)
              accelerator_count = lookup(accelerators.value, "accelerator_count", null)
            }
          }
        }
      }

      dynamic "worker_config" {
        for_each = lookup(cluster_config.value, "worker_config", null) == null ? [] : [cluster_config.value.worker_config]
        content {
          num_instances    = lookup(worker_config.value, "num_instances", null)
          machine_type     = lookup(worker_config.value, "machine_type", null)
          min_cpu_platform = lookup(worker_config.value, "min_cpu_platform", null)
          image_uri        = lookup(worker_config.value, "image_uri", null)

          dynamic "disk_config" {
            for_each = lookup(worker_config.value, "disk_config", null) == null ? [] : [worker_config.value.disk_config]
            content {
              boot_disk_type    = lookup(disk_config.value, "boot_disk_type", null)
              boot_disk_size_gb = lookup(disk_config.value, "boot_disk_size_gb", null)
              num_local_ssds    = lookup(disk_config.value, "num_local_ssds", null)
            }
          }
          dynamic "accelerators" {
            for_each = lookup(worker_config.value, "accelerators", null) == null ? [] : [worker_config.value.accelerators]
            content {
              accelerator_type  = lookup(accelerators.value, "accelerator_type", null)
              accelerator_count = lookup(accelerators.value, "accelerator_count", null)
            }
          }
        }
      }

      dynamic "preemptible_worker_config" {
        for_each = lookup(cluster_config.value, "preemptible_worker_config", null) == null ? [] : [cluster_config.value.preemptible_worker_config]
        content {
          num_instances = lookup(preemptible_worker_config.value, "num_instances", null)

          dynamic "disk_config" {
            for_each = lookup(preemptible_worker_config.value, "disk_config", null) == null ? [] : [preemptible_worker_config.value.disk_config]
            content {
              boot_disk_type    = lookup(disk_config.value, "boot_disk_type", null)
              boot_disk_size_gb = lookup(disk_config.value, "boot_disk_size_gb", null)
              num_local_ssds    = lookup(disk_config.value, "num_local_ssds", null)
            }
          }
        }
      }
      dynamic "software_config" {
        for_each = lookup(cluster_config.value, "software_config", null) == null ? [] : [cluster_config.value.software_config]
        content {
          image_version       = lookup(software_config.value, "image_version", null)
          override_properties = lookup(software_config.value, "override_properties", null)
          optional_components = lookup(software_config.value, "optional_components", null)
        }
      }
      dynamic "security_config" {
        for_each = lookup(cluster_config.value, "security_config", null) == null ? [] : [cluster_config.value.security_config]
        content {
          dynamic "kerberos_config" {
            for_each = lookup(security_config.value, "kerberos_config", null) == null ? [] : [security_config.value.kerberos_config]
            content {
              cross_realm_trust_admin_server        = lookup(kerberos_config.value, "cross_realm_trust_admin_server", null)
              cross_realm_trust_kdc                 = lookup(kerberos_config.value, "cross_realm_trust_kdc", null)
              cross_realm_trust_realm               = lookup(kerberos_config.value, "cross_realm_trust_realm", null)
              cross_realm_trust_shared_password_uri = lookup(kerberos_config.value, "cross_realm_trust_shared_password_uri", null)
              enable_kerberos                       = lookup(kerberos_config.value, "enable_kerberos", null)
              kdc_db_key_uri                        = lookup(kerberos_config.value, "kdc_db_key_uri", null)
              key_password_uri                      = lookup(kerberos_config.value, "key_password_uri", null)
              keystore_uri                          = lookup(kerberos_config.value, "keystore_uri", null)
              keystore_password_uri                 = lookup(kerberos_config.value, "keystore_password_uri", null)
              kms_key_uri                           = lookup(kerberos_config.value, "kms_key_uri", null)
              realm                                 = lookup(kerberos_config.value, "realm", null)
              root_principal_password_uri           = lookup(kerberos_config.value, "root_principal_password_uri", null)
              tgt_lifetime_hours                    = lookup(kerberos_config.value, "tgt_lifetime_hours", null)
              truststore_password_uri               = lookup(kerberos_config.value, "truststore_password_uri", null)
              truststore_uri                        = lookup(kerberos_config.value, "truststore_uri", null)
            }
          }
        }
      }
      dynamic "autoscaling_config" {
        for_each = lookup(cluster_config.value, "autoscaling_config", null) == null ? [] : [cluster_config.value.autoscaling_config]
        content {
          policy_uri = lookup(autoscaling_config.value, "policy_uri", null)
        }
      }
      dynamic "initialization_action" {
        for_each = lookup(cluster_config.value, "initialization_action", null) == null ? [] : [cluster_config.value.initialization_action]
        content {
          script      = lookup(initialization_action.value, "script", null)
          timeout_sec = lookup(initialization_action.value, "timeout_sec", null)
        }
      }
      dynamic "encryption_config" {
        for_each = lookup(cluster_config.value, "encryption_config", null) == null ? [] : [cluster_config.value.encryption_config]
        content {
          kms_key_name = lookup(encryption_config.value, "kms_key_name", null)
        }
      }
      dynamic "lifecycle_config" {
        for_each = lookup(cluster_config.value, "lifecycle_config", null) == null ? [] : [cluster_config.value.lifecycle_config]
        content {
          idle_delete_ttl  = lookup(lifecycle_config.value, "idle_delete_ttl", null)
          auto_delete_time = lookup(lifecycle_config.value, "auto_delete_time", null)
          
        }
      }
      dynamic "endpoint_config" {
        for_each = lookup(cluster_config.value, "endpoint_config", null) == null ? [] : [cluster_config.value.endpoint_config]
        content {
          enable_http_port_access = lookup(endpoint_config.value, "enable_http_port_access", true)
        }
      }
    }
  }
}


#------------------Dataproc-Autoscaling-Code--------------------------------------#

resource "google_dataproc_autoscaling_policy" "asp" {
  provider    = google-beta
  location    = var.location
  policy_id   = var.policy_id
  project     = var.project_id

  dynamic "basic_algorithm" {
    for_each = var.basic_algorithm
    content {
      
      cooldown_period = basic_algorithm.value["cooldown_period"]

      dynamic "yarn_config" {
        for_each = basic_algorithm.value.yarn_config
        content {
         
          graceful_decommission_timeout = yarn_config.value["graceful_decommission_timeout"]
         
          scale_down_factor = yarn_config.value["scale_down_factor"]
         
          scale_down_min_worker_fraction = yarn_config.value["scale_down_min_worker_fraction"]
          
          scale_up_factor = yarn_config.value["scale_up_factor"]
          
          scale_up_min_worker_fraction = yarn_config.value["scale_up_min_worker_fraction"]
        }
      }

    }
  }

  dynamic "secondary_worker_config" {
    for_each = var.secondary_worker_config
    content {
      
      max_instances = secondary_worker_config.value["max_instances"]
      min_instances = secondary_worker_config.value["min_instances"]
      weight = secondary_worker_config.value["weight"]
    }
  }

  dynamic "timeouts" {
    for_each = var.timeouts
    content {
     
      create = timeouts.value["create"]
      delete = timeouts.value["delete"]
      update = timeouts.value["update"]
    }
  }

  dynamic "worker_config" {
    for_each = var.auto_scaling_worker_config
    content {
     
      max_instances = worker_config.value["max_instances"]
      min_instances = worker_config.value["min_instances"]
      weight = worker_config.value["weight"]
    }
  }

}






























































































