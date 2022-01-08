# Create a static IP
resource "google_compute_address" "static" {
    name = "ipv4-address"
}


# Create firewall rules so we can access the VM
resource "google_compute_firewall" "default" {
    name = "media-server-firewall"
    network = "default"
    #network_tier = "STANDARD"
    allow {
        protocol = "icmp"
    }
    # Allowed ports - http/https and plex atm
    allow {
        protocol = "tcp"
        ports = ["80", "443", "32400"]
    }
    allow {
        protocol = "udp"
        ports = ["32400"]
    }
    # Allow access from anywhere
    source_ranges = ["0.0.0.0/0"]
    target_tags = ["media-server"]
}

# Create VM
resource "google_compute_instance" "mediaserver" {
    name = "mediaserver"
    machine_type = "e2-standard-4"
    zone= "europe-west2-c"

    # Open required ports
    tags = ["media-server"]

    # Boot disk
    boot_disk {
        initialize_params {
            image = "media-station"
        }
    }
    # Attach static IP - commented out when developing as not essential
    network_interface {
        network = "default"
        access_config {
            nat_ip = google_compute_address.static.address
        }
    }
    # Make preemptible
    scheduling {
        preemptible = true
        automatic_restart = false
    }
}