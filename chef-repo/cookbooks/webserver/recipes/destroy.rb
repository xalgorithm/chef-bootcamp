require 'chef/provisioning/aws_driver'
with_driver 'aws'

name = "XALG"

1.upto(3) do |n|
  instance = "#{name}-webserver-#{n}"
  machine instance do
    action :destroy
  end
end

load_balancer "#{name}-webserver-lb" do
  action :destroy
end

aws_security_group "#{name}-ssh" do
  action :destroy
end

aws_security_group "#{name}-http" do
  action :destroy
end
