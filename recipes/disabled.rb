# Cookbook Name:: iptables
# Recipe:: disabled

package 'iptables'

service 'iptables' do
  action [:disable, :stop]
  supports :status => true, :start => true, :stop => true, :restart => true
end
