#!/bin/bash
    cd /home/ec2-user/webapp
    echo DBHOST="${DBHOST}" >> .env
    echo DBUSER="${DBUSER}" >> .env
    echo DBPASS="${DBPASS}" >> .env
    echo DATABASE="${DATABASE}" >> .env
    echo PORT=${PORT} >> .env
    echo DBPORT=${DBPORT} >> .env
    echo BUCKETNAME=${BUCKETNAME} >> .env

    sudo chown -R root:ec2-user /var/log
    sudo chmod -R 770 -R /var/log

    sudo systemctl daemon-reload
    sudo systemctl start webapp.service
    sudo systemctl enable webapp.service  
    sudo systemctl start amazon-cloudwatch-agent.service
    sudo systemctl enable amazon-cloudwatch-agent.service


    sudo ../../../opt/aws/amazon-cloudwatch-agent/bin/amazon-cloudwatch-agent-ctl \
      -a fetch-config \
      -m ec2 \
      -c file:packer/cloudwatch-config.json \
      -s 