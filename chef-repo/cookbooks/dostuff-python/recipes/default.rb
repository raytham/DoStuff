#
# Cookbook Name:: dostuff-python
# Recipe:: default
#
# Copyright 2015, YOUR_COMPANY_NAME
#
# All rights reserved - Do Not Redistribute
#

chef_gem 'chef-rewind'
require 'chef/rewind'

package 'python35u-pip' do
  action :upgrade
end

include_recipe 'yum-ius::default'
include_recipe 'python::default'

rewind 'package[python]' do
  package_name 'python35u'
end

rewind 'package[python-devel]' do
  package_name 'python35u-devel'
end

unwind "cookbook_file[#{Chef::Config[:file_cache_path]}/get-pip.py]"
unwind 'execute[install-pip]'
unwind 'python_pip[setuptools]'

directory '/var/lib/dostuff' do
  owner 'root'
  group 'root'
  mode 00755
  recursive true
  action :create
end

virtualenv = '/var/lib/dostuff/virtualenv'
python_virtualenv virtualenv do
  interpreter 'python3.5'
  action :create
end

# needed to compile bcrypt
package 'gcc' do
  action :upgrade
end

# needed to compile bcrypt
package 'libffi-devel' do
  action :upgrade
end

packages = [
  'Flask',
  'Flask-RESTful',
  'Flask-SQLAlchemy',
  'marshmallow',
  'bcrypt',
  'PyJWT'
]

packages.each do |package|
  python_pip package do
    virtualenv virtualenv
    action :upgrade
  end
end
