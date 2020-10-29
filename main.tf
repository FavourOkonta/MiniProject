provider "aws" {
  profile = "default"
  region     = var.region
}
# create the VPC
resource "aws_vpc" "My_VPC" {
  cidr_block           = var.vpcCIDRblock
  instance_tenancy     = var.instanceTenancy 
  enable_dns_support   = var.dnsSupport 
  enable_dns_hostnames = var.dnsHostNames
tags = {
    Name = "Grafana&Prometheus VPC"
}
} # end resource
# create the Subnet

resource "aws_subnet" "Webservers" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock
  map_public_ip_on_launch = var.mapPublicIP 
  availability_zone       = var.availabilityZone
  tags = {
   Name = "WebServers"
  }
}

# create the Subnet
resource "aws_subnet" "Grafana" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock1
  map_public_ip_on_launch = var.mapPublicIP
  availability_zone       = var.availabilityZone1
  tags = {
   Name = "Grafana"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "PrivateDB" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock2
  availability_zone       = var.availabilityZone2
  tags = {
   Name = "Private DB"
  }
} # end resource

# create the Subnet
resource "aws_subnet" "PrivateDB2" {
  vpc_id                  = aws_vpc.My_VPC.id
  cidr_block              = var.subnetCIDRblock3
  availability_zone       = var.availabilityZone3
  tags = {
   Name = "Private DB"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "Webservers" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "WebserversSG"
  description  = "WebserversSG"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 80
    to_port     = 80
    protocol    = "tcp"
  } 

   ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 9100
    to_port     = 9100
    protocol    = "tcp"
  } 
  
  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "Web Security Group"
   Description = "My VPC Security Group"
  }
} # end resource

# Create the Security Group2
resource "aws_security_group" "Grafana" {
  vpc_id       = aws_vpc.My_VPC.id
  name         = "Grafana Security Group"
  description  = "Grafana Security Group"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 9090
    to_port     = 9090
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 3000
    to_port     = 3000
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 9300
    to_port     = 9300
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 9115
    to_port     = 9115
    protocol    = "tcp"
  } 
  
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 9093
    to_port     = 9093
    protocol    = "tcp"
  } 

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "Grafana Security Group"
   Description = "Grafana Security Group"
  }
} # end resource

# Create the Security Group
resource "aws_security_group" "MariaDB" {
  name         = "MariaDBSG"
  description  = "MariaDBSG"
  
  # allow ingress of port 22
  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
  } 

  ingress {
    cidr_blocks = var.ingressCIDRblock  
    from_port   = 3306
    to_port     = 3306
    protocol    = "tcp"
  } 

  # allow egress of all ports
  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }
  tags = {
   Name = "MariaDB Security Group"
   Description = "MariaDB VPC Security Group"
  }
} # end resource

resource "aws_db_subnet_group" "mariadb-subnet" {
  name        = "mariadb-subnet"
  description = "RDS subnet group"
  subnet_ids  = [aws_subnet.PrivateDB.id,aws_subnet.PrivateDB2.id]
}


# Create the Internet Gateway
resource "aws_internet_gateway" "My_VPC_GW" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
        Name = "My VPC Internet Gateway"
  }
} # end resource


# Create the Route Table
resource "aws_route_table" "My_VPC_route_table" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
        Name = "My VPC Route Table"
  }
} # end resource

# Create the Route Table
resource "aws_route_table" "My_VPC_route_table1" {
  vpc_id = aws_vpc.My_VPC.id
  tags = {
        Name = "My VPC Route Table1"
  }
} # end resource

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access" {
  route_table_id         = aws_route_table.My_VPC_route_table.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
} # end resource

# Create the Internet Access
resource "aws_route" "My_VPC_internet_access1" {
  route_table_id         = aws_route_table.My_VPC_route_table1.id
  destination_cidr_block = var.destinationCIDRblock
  gateway_id             = aws_internet_gateway.My_VPC_GW.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association" {
  subnet_id      = aws_subnet.Webservers.id
  route_table_id = aws_route_table.My_VPC_route_table.id
} # end resource

# Associate the Route Table with the Subnet
resource "aws_route_table_association" "My_VPC_association1" {
  subnet_id      = aws_subnet.Grafana.id
  route_table_id = aws_route_table.My_VPC_route_table1.id
} # end resource

data "aws_ami" "Graf_Linux" {
  most_recent = true
  owners = ["697430341089"] # Canonical

  filter {
      name   = "name"
      values = ["Task 5"]
  }

  filter {
      name   = "virtualization-type"
      values = ["hvm"]
  }
}


# Create EC2 instance
resource "aws_instance" "Webserver1" {
  ami                    = data.aws_ami.Graf_Linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Webservers.id
  key_name               = "crossovertest"
  vpc_security_group_ids = [aws_security_group.Webservers.id]
  user_data              = file("script.sh")
  tags = {
    Name        = "WebServer1 Node"
    name        = "WebServer1 Node"
    provisioner = "Terraform"
  }
}

# Create EC2 instance
resource "aws_instance" "Webserver2" {
  ami                    = data.aws_ami.Graf_Linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Grafana.id
  key_name               = "crossovertest"
  vpc_security_group_ids = [aws_security_group.Webservers.id]
  user_data              = file("script.sh")
  tags = {
    Name        = "WebServer2 Node"
    name        = "WebServer2 Node"
    provisioner = "Terraform"
  }
}

# Create EC2 instance2
resource "aws_instance" "Grafana" {
  ami                    = data.aws_ami.Graf_Linux.id
  instance_type          = "t2.micro"
  subnet_id              = aws_subnet.Grafana.id
  key_name               = "crossovertest"
  vpc_security_group_ids = [aws_security_group.Grafana.id]
  user_data              = file("scripted.sh")
  tags = {
    Name        = "Grafana Node"
    name        = "Grafana Node"
    provisioner = "Terraform"
  }
}


resource "aws_db_instance" "mariadb" {
  allocated_storage       = 20 # 100 GB of storage, gives us more IOPS than a lower number//20GB for free tier
  engine                  = "mariadb"
  engine_version          = "10.4.8"
  instance_class          = "db.t2.micro" # use micro if you want to use the free tier
  identifier              = "mariadb"
  publicly_accessible     = false
  apply_immediately       = true
  port                    = 3306
  db_subnet_group_name    = aws_db_subnet_group.mariadb-subnet.name
  vpc_security_group_ids  = [aws_security_group.MariaDB.id]
  multi_az                = "true"
  name                    = "week5db"   # database name
  username                = "favour"    # username
  password                = "favour123" # password
  storage_type            = "gp2"
  backup_retention_period = 7 # how long you’re going to keep your backups
 # availability_zone       = aws_subnet.PrivateDB.availability_zone # prefered AZ
  final_snapshot_identifier = "mariadb-final-snapshot" # final snapshot when executing terraform destroy
  skip_final_snapshot     = false


  tags = {
    Name = "mariadb-instance"
  }
}

output "db_endpoint" {
  value       = aws_db_instance.mariadb.address
  description = "The endpoint of the database instance."
}

output "Webserver_1" {
  value       = aws_instance.Webserver1.public_ip
  description = "The IP address of the instance."
}

output "Webserver_2" {
  value       = aws_instance.Webserver2.public_ip
  description = "The IP address of the instance."
}

output "Grafana" {
  value       = aws_instance.Grafana.public_ip
  description = "The IP address of the instance."
}