#
# Cookbook Name:: motd
# Recipe:: default
#
# Copyright (c) 2015 The Authors, All Rights Reserved.
template "/etc/motd" do
source "motd.erb"
    action :create
    mode "0644"
    owner "root"
    group "root"
end
