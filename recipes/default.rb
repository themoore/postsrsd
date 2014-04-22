#
# Cookbook Name:: postsrs
# Recipe:: default
#
# Copyright (C) 2014 Eric G. Wolfe
# 
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
# 
#    http://www.apache.org/licenses/LICENSE-2.0
# 
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

# Need git to checkout from github
include_recipe 'git'

# Install build packages
node['postsrsd']['packages'].each do |pkg|
  package pkg
end

# Checkout postsrsd from github
# Notify make block
git node['postsrsd']['buildroot'] do
  repository node['postsrs']['repository']
  action :checkout
  notifies :run, 'execute[make]', :immediately
end

# Run make when git notifies.
# Notify make install
execute 'make' do
  cwd node['postsrsd']['buildroot']
  command 'make'
  creates "#{node['postsrs']['buildroot']}/build/postsrs"
  notifies :run, 'execute[make-install]', :immediately
  action :nothing
end

# Run make install when make block notifies
execute 'make-install' do
  cwd node['postsrsd']['buildroot']
  command 'make install'
  creates '/usr/local/sbin/postsrsd'
  action :nothing
end

# Get random secret from openssl cookbook
node.set_unless['postsrsd']['secret'] = secure_password(25)

# Secret template
template '/etc/postsrsd.secret' do
  owner 'root'
  group 'root'
  mode 00600
end

# Start and enable postsrsd service
service 'postsrsd' do
  action [:enable, :start]
end

# Set up postfix
include_recipe 'postfix'
