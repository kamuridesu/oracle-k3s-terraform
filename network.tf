resource "oci_core_remote_peering_connection" "k3s-rpc-connection" {
  compartment_id   = var.compartment_id
  drg_id           = oci_core_drg.k3s_drg.id
  peer_region_name = var.region
  peer_id          = oci_core_remote_peering_connection.lb_rpc.id
}

resource "oci_core_remote_peering_connection" "lb-rpc-connection" {
  compartment_id   = var.compartment_id
  drg_id           = oci_core_drg.lb_drg.id
  peer_region_name = var.region
  peer_id          = oci_core_remote_peering_connection.k3s_rpc.id
}