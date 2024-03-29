default['yum']['ius']['repositoryid'] = 'ius'
default['yum']['ius']['enabled'] = true
default['yum']['ius']['managed'] = true
default['yum']['ius']['failovermethod'] = 'priority'
default['yum']['ius']['gpgkey'] = 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY'
default['yum']['ius']['gpgcheck'] = true
case node['platform_version'].to_i
when 5
  default['yum']['ius-archive-debuginfo']['sslverify'] = false
end

case node['platform_version'].to_i
when 5
  default['yum']['ius']['description'] = 'IUS Community Packages for Enterprise Linux 5 - $basearch'
when 6
  default['yum']['ius']['description'] = 'IUS Community Packages for Enterprise Linux 6 - $basearch'
when 7
  default['yum']['ius']['description'] = 'IUS Community Packages for Enterprise Linux 7 - $basearch'
end

case node['platform']
when 'redhat'
  case node['platform_version'].to_i
  when 5
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el5&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el6&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el7&arch=$basearch&protocol=http'
  end
else
  case node['platform_version'].to_i
  when 5
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos5&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos6&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos7&arch=$basearch&protocol=http'
  end
end
