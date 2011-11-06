#
# Cookbook Name:: maven
# Recipe:: maven3-src
#
# Copyright 2011, Bryan W. Berry (<bryan.berry@gmail.com>)
#
# Licensed under the Apache License, Version 2.0 (the "License");
# you may not use this file except in compliance with the License.
# You may obtain a copy of the License at
#
#     http://www.apache.org/licenses/LICENSE-2.0
#
# Unless required by applicable law or agreed to in writing, software
# distributed under the License is distributed on an "AS IS" BASIS,
# WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.
# See the License for the specific language governing permissions and
# limitations under the License.
#

include_recipe "java"

remote_file "maven3_src" do
  path "/tmp"
  source node['maven']['m3_download_url']
  checksum "4fb4a392d879ebcd19dc5a05f9d779aed7f1e3356c8c9e6200b15f8b6e1f85e0"
end

bash "install_maven3" do
  tarball = node['maven']['m3_download_url'].split('/')[-1]
  folder_name = tarball.partition('.tar.gz')[0]
  cwd "/tmp"
  user "root"
  code <<-EOH
    tar xvzf #{tarball}
    cp -r #{folder_name}/* #{node['maven']['m2_home']}
    rm -rf #{tarball} #{folder_name}
  EOH
end

template "/etc/mavenrc" do
  source "mavenrc.erb"
end

link "#{node['maven']['m2_home']}/bin/mvn" do
  to "/usr/bin/mvn"
end
