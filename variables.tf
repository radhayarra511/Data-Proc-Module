variable "dataproc_cluster_name" {
    type = string
    description = "(Required) The name of the cluster, unique within the project and zone."
}

variable "region_name" {
    type = string
    description = " (Required) The region in which the cluster and associated nodes will be created in. Defaults to global."
}

variable "project_id" {
    type = string
    description = "(Required) The ID of the project in which the cluster will exist."
}

variable "graceful_decommission_timeout" {
    type = string
    description = "(Optional) Allows graceful decomissioning when you change the number of worker nodes directly through a terraform apply. Does not affect auto scaling decomissioning from an autoscaling policy. Graceful decommissioning allows removing nodes from the cluster without interrupting jobs in progress. Timeout specifies how long to wait for jobs in progress to finish before forcefully removing nodes (and potentially interrupting jobs). Default timeout is 0 (for forceful decommission), and the maximum allowed timeout is 1 day. (see JSON representation of Duration). Only supported on Dataproc image versions 1.2 and higher. For more context see the docs"
    default = "0"
}

variable "labels" {
    type = map(string)
    description = " (Optional, Computed) The list of labels (key/value pairs) to be applied to instances in the cluster. GCP generates some itself including goog-dataproc-cluster-name which is the name of the cluster."
    default = {}
}

variable "cluster_config" {
    type = list(any)
    description = "(Optional) Allows you to configure various aspects of the cluster."
}


variable "location" {
  description = "(optional) - The  location where the autoscaling policy should reside.\nThe default value is 'global'."
  type        = string
  default     = null
    default = {}
}

variable "policy_id" {
  description = "(required) - The policy id. The id must contain only letters (a-z, A-Z), numbers (0-9), underscores (_),\nand hyphens (-). Cannot begin or end with underscore or hyphen. Must consist of between\n3 and 50 characters."
  type        = string
   default = {}
}

variable "basic_algorithm" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      cooldown_period = string
      yarn_config = list(object(
        {
          graceful_decommission_timeout  = string
          scale_down_factor              = number
          scale_down_min_worker_fraction = number
          scale_up_factor                = number
          scale_up_min_worker_fraction   = number
        }
      ))
    }
  ))
  default = []
}

variable "secondary_worker_config" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      max_instances = number
      min_instances = number
      weight        = number
    }
  ))
  default = []
}

variable "timeouts" {
  description = "nested block: NestingSingle, min items: 0, max items: 0"
  type = set(object(
    {
      create = string
      delete = string
      update = string
    }
  ))
  default = []
}

variable "worker_config" {
  description = "nested block: NestingList, min items: 0, max items: 1"
  type = set(object(
    {
      max_instances = number
      min_instances = number
      weight        = number
    }
  ))
  default = []
}





