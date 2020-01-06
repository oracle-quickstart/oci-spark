# oci-quickstart-template

The [Oracle Cloud Infrastructure (OCI) Quick Start](https://github.com/oracle-quickstart?q=oci-quickstart) is a collection of examples that allow Oracle Cloud Infrastructure users to get a quick start deploying advanced infrastructure on OCI.

The oci-quickstart-template repository contains the template that can be used for accelerating the construction of quickstarts that runs from local Terraform CLI and OCI Resource Manager.

Spark is a sample that deploys a Spark Cluster which you can configure various options for.

This repo is under active development.  Building open source software is a community effort.  We're excited to engage with the community building this.

## Oracle Resource Manager Deployment

This template uses Terraform v0.12 and Oracle Resource Manager to deploy Spark.  The template downloads Spark and compiles via Maven using options specified in the Resource Manager template.

In order to use the Resource Manager template, you will need to download and re-pack it so the contents are at top-level in the zip.

First, Download the [master.zip](https://github.com/oracle-quickstart/oci-spark/archive/master.zip)

Unzip and re-pack the zip:
	
	unzip oci-spark-master.zip
	cd oci-spark-master
	zip -r oci-spark-orm.zip *

Now you can use the resulting oci-spark-orm.zip in Resource Manager to build the Spark deployment stack. Follow the [Resource Manager instructions](https://docs.cloud.oracle.com/iaas/Content/ResourceManager/Tasks/usingconsole.htm) for how to build a stack.

## Compiled from Source

This deployment compiles from source, as such it does take some time after deployment before the Spark UI is available.  You can monitor progress on the Spark Master by watching the log file /var/log/spark-OCI-initialize.log:

	sudo tail -n 500 -f /var/log/spark-OCI-initialize.log

