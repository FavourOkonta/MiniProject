#! /bin/bash
sudo yum update -y
sudo yum install mysql -y
sudo amazon-linux-extras install docker -y
sudo service docker start
sudo systemctl enable docker
sudo usermod -aG docker ec2-user
sudo curl -L github.com/docker/compose/releases/download/1.27.4/docker-compose-$(uname -s)-$(uname -m) -o /usr/local/bin/docker-compose
sudo chmod +x /usr/local/bin/docker-compose
sudo cp /usr/local/bin/docker-compose /usr/bin/
sudo cp /usr/local/bin/docker-compose /home/ec2-user/
sudo mkdir /usr/config
sudo sudo amazon-linux-extras install ansible2 -y