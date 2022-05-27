#!/bin/bash

cp -r /vagrant/haproxy/* /etc/haproxy/
systemctl restart haproxy
