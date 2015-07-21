#
# Cookbook Name:: webserver
# Recipe:: provision
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
name = "XALG"

require "chef/provisioning/aws_driver"

with_driver "aws::us-east-1" do

  aws_security_group "#{name}-ssh" do
    inbound_rules '0.0.0.0/0' => 22
  end

  aws_security_group "#{name}-http" do
    inbound_rules '0.0.0.0/0' => 80
  end

  with_machine_options({
    :aws_tags => {"belongs_to" => name},
    :ssh_username => "root",
    :bootstrap_options => {
      :image_id => "ami-bf5021d6",
      :instance_type => "t1.micro",
      :key_name => "aws-popup-chef",
      :security_group_ids => ["#{name}-ssh","#{name}-http"]
    },
    :convergence_options => {
      :chef_version => "12.2.1",
    }
  })
  # track all the instances we need to make
  webservers = 1.upto(3).map { |n| "#{name}-webserver-#{n}" }

  machine_batch do
    webservers.each do |instance|
      machine instance do
        recipe "webserver"
        tag "my-webserver"
        converge true
      end
    end
  end
  
  load_balancer "#{name}-webserver-lb" do
    machines webservers
  end
end
