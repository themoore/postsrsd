#
# Attributes:: postsrsd
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

default['postsrsd']['buildroot'] = "#{Chef::Config[:file_cache_path]}/postsrsd"
default['postsrsd']['repository'] = 'git://github.com/roehling/postsrsd'
default['postsrsd']['packages'] = %w(cmake)

default['postfix']['main']['sender_canonical_maps'] = 'tcp:127.0.0.1:10001'
default['postfix']['main']['sender_canonical_classes'] = 'envelope_sender'
default['postfix']['main']['recipient_canonical_maps'] = 'tcp:127.0.0.1:10002'
default['postfix']['main']['recipient_canonical_classes'] = 'envelope_recipient'

# Get random secret from openssl cookbook
# include Opscode::OpenSSL::Password
# node.set_unless['postsrsd']['secret'] = secure_password(25)
