#
# Cookbook Name:: webserver
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
package "httpd"
service "httpd" do
        action [:enable, :start]
        end
template "/var/www/html/index.html" do
        source "index.html.erb"
        variables({
        :webservers => search(:node, "tags:my-webserver AND NOT name:#{node.name}")
})
end
service "iptables" do
        action [:disable, :stop]
end
