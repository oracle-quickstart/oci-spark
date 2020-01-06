data "oci_core_vcn" "vcn_info" {
  vcn_id = "${var.useExistingVcn ? var.myVcn : module.network.vcn-id}" 
}

data "oci_core_subnet" "private_subnet" {
  subnet_id = "${var.useExistingVcn ? var.privateSubnet : module.network.private-id}"
}

data "oci_core_subnet" "public_subnet" {
  subnet_id = "${var.useExistingVcn ? var.publicSubnet : module.network.public-id}" 
}

data "null_data_source" "values" {
  inputs = {
    spark_default = "spark-master.${data.oci_core_subnet.public_subnet.dns_label}.${data.oci_core_vcn.vcn_info.vcn_domain_name}"
  }
}

module "master" {
        source  = "./modules/master"
	region = "${var.region}"
	compartment_ocid = "${var.compartment_ocid}"
        subnet_id =  "${var.useExistingVcn ? var.publicSubnet : module.network.public-id}"
	availability_domain = "${var.availability_domain}"
        image_ocid = "${var.InstanceImageOCID[var.region]}"
        ssh_private_key = "${var.ssh_private_key}"
        ssh_public_key = "${var.ssh_public_key}"
        master_instance_shape = "${var.master_instance_shape}"
        user_data = "${base64encode(file("scripts/boot.sh"))}"
	spark_master = "${data.null_data_source.values.outputs["spark_default"]}"
	build_mode = "${var.build_mode}"
	hadoop_version = "${var.hadoop_version}"
	use_hive = "${var.use_hive}"
}

module "worker" {
        source  = "./modules/worker"
        instances = "${var.worker_node_count}"
	region = "${var.region}"
	compartment_ocid = "${var.compartment_ocid}"
        subnet_id =  "${var.useExistingVcn ? var.privateSubnet : module.network.private-id}"
	availability_domain = "${var.availability_domain}"
	image_ocid = "${var.InstanceImageOCID[var.region]}"
        ssh_private_key = "${var.ssh_private_key}"
        ssh_public_key = "${var.ssh_public_key}"
        worker_instance_shape = "${var.worker_instance_shape}"
	block_volumes_per_worker = "${var.block_volumes_per_worker}"
	data_blocksize_in_gbs = "${var.data_blocksize_in_gbs}"
        user_data = "${base64encode(file("scripts/boot.sh"))}"
	spark_master = "${data.null_data_source.values.outputs["spark_default"]}"
	block_volume_count = "${var.block_volumes_per_worker}"
        build_mode = "${var.build_mode}"
        hadoop_version = "${var.hadoop_version}"
        use_hive = "${var.use_hive}"
}
