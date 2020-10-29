# variables.tf
variable "region" {
     default = "us-east-1"
}
variable "availabilityZone" {
     default = "us-east-1a"
}
variable "availabilityZone1" {
     default = "us-east-1b"
}
variable "availabilityZone2" {
     default = "us-east-1c"
}
variable "availabilityZone3" {
     default = "us-east-1d"
}
variable "instanceTenancy" {
    default = "default"
}
variable "dnsSupport" {
    default = true
}
variable "dnsHostNames" {
    default = true
}
variable "vpcCIDRblock" {
    default = "10.9.0.0/16"
}
variable "subnetCIDRblock" {
    default = "10.9.1.0/24"
}
variable "subnetCIDRblock1" {
    default = "10.9.2.0/24"
}
variable "subnetCIDRblock2" {
    default = "10.9.3.0/24"
}
variable "subnetCIDRblock3" {
    default = "10.9.4.0/24"
}
variable "destinationCIDRblock" {
    default = "0.0.0.0/0"
}
variable "ingressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "egressCIDRblock" {
    type = list
    default = [ "0.0.0.0/0" ]
}
variable "mapPublicIP" {
    default = true
}
# end of variables.tf
