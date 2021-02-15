Create an Azure VM with enhanced networking

# add ssh key to variables.tf

# apply terraform
$ terraform init/plan/apply

# ssh into VM
ssh admin@<publicIP>

# validate enhanced networking
node$  lspci
0000:00:00.0 Host bridge: Intel Corporation 440BX/ZX/DX - 82443BX/ZX/DX Host bridge (AGP disabled) (rev 03)
0000:00:07.0 ISA bridge: Intel Corporation 82371AB/EB/MB PIIX4 ISA (rev 01)
0000:00:07.1 IDE interface: Intel Corporation 82371AB/EB/MB PIIX4 IDE (rev 01)
0000:00:07.3 Bridge: Intel Corporation 82371AB/EB/MB PIIX4 ACPI (rev 02)
0000:00:08.0 VGA compatible controller: Microsoft Corporation Hyper-V virtual VGA
0001:00:02.0 Ethernet controller: Mellanox Technologies MT27710 Family [ConnectX-4 Lx Virtual Function] (rev 80)

node$ ethtool -S eth0 | grep vf_
     vf_rx_packets: 40295
     vf_rx_bytes: 151247557
     vf_tx_packets: 58777
     vf_tx_bytes: 11403776
     vf_tx_dropped: 0
     ---- more

# tear down
$ terraform destroy

### Notes
## network_profile.network_plugin = "azure" replaces default kubenet CNI driver with enhanced networking driver
