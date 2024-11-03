##############################
### Xen Orchestra Provider ###
##############################

data "xenorchestra_pool" "pool" {
  name_label = ""
}
data "xenorchestra_template" "vm_template_worker" {
  name_label = "storage"
  pool_id    = ""
}
data "xenorchestra_template" "vm_template_cp" {
  name_label = "standard"
  pool_id    = ""
}
data "xenorchestra_template" "vm_template_large" {
  name_label = "large"
  pool_id    = ""
}
data "xenorchestra_network" "net" {
  name_label = ""
  pool_id    = ""
}
data "xenorchestra_sr" "local_storage" {
  name_label = "Local storage"
  pool_id    = ""
}

#########################################################################################
# First disk is the first disk in each template and needs to be specified for all VMs.
# Additional disks don't need to be specified, unless they are not in the template.
# vm_template_cp: os disk only
# vm_template_worker: os disk + 3x 100GB storage disks
# vm_template_large: os disk 
#########################################################################################

#############################
### START K3S ENVIRONMENT ###
#############################

# K3S CONTROLPLANE 1
resource "xenorchestra_vm" "vm01" {
  cpus          = 4
  memory_max    = 17179869184
  name_label    = "vm01"
  template      = data.xenorchestra_template.vm_template_worker.id
  affinity_host = ""
  network {
    network_id = data.xenorchestra_network.net.id
  }
  disk {
    sr_id      = ""
    name_label = "os"
    size       = 37580963840
  }
}

# K3S WORKER 1
resource "xenorchestra_vm" "vm02" {
  cpus          = 4
  memory_max    = 17179869184
  name_label    = "vm02"
  template      = data.xenorchestra_template.vm_template_worker.id
  affinity_host = ""
  network {
    network_id = data.xenorchestra_network.net.id
  }
  disk {
    sr_id      = ""
    name_label = "os"
    size       = 37580963840
  }
}
