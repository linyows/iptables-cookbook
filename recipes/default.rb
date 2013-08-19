# Cookbook Name:: iptables
# Recipe:: default

package 'iptables'

service 'iptables' do
  supports :restart => true, :status => false
  action :enable
end

iptable_rules_path = case node['platform_family']
                     when 'debian' then '/etc/iptables-rules'
                     when 'rhel' then '/etc/sysconfig/iptables'
                     end

template 'iptables_conf' do
  conf = node['iptables'][node.name] || node['iptables']['conf']

  if conf.is_a?(String)
    conf.gsub!(/^ {2,}/, '')
    conf.strip!
    conf = conf.split("\n")
  end

  source 'iptables_conf.erb'
  path iptable_rules_path
  mode 0644
  owner 'root'
  group 'root'
  variables 'conf' => conf
  notifies :restart, 'service[iptables]'
end

case node['platform_family']
when 'debian'
  file '/etc/network/if-up.d/iptables-rules' do
    owner 'root'
    group 'root'
    mode 0755
    content "#!/bin/bash\niptables-restore < #{iptable_rules_path}\n"
    action :create
  end
end
