#!/bin/bash
yum install -y docker
service docker start && chkconfig docker on
docker run -d --name hello-world -p 80:80 ${docker_image}
