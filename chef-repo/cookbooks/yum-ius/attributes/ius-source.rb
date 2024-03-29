default['yum']['ius-source']['repositoryid'] = 'ius-source'
default['yum']['ius-source']['enabled'] = false
default['yum']['ius-source']['managed'] = false
default['yum']['ius-source']['failovermethod'] = 'priority'
default['yum']['ius-source']['gpgkey'] = 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY'
default['yum']['ius-source']['gpgcheck'] = true
case node['platform_version'].to_i
when 5
  default['yum']['ius-archive-debuginfo']['sslverify'] = false
end

case node['platform_version'].to_i
when 5
  default['yum']['ius-source']['description'] = 'IUS Community Packages for Enterprise Linux 5 - $basearch Source'
when 6
  default['yum']['ius-source']['description'] = 'IUS Community Packages for Enterprise Linux 6 - $basearch Source'
when 7
  default['yum']['ius-source']['description'] = 'IUS Community Packages for Enterprise Linux 7 - $basearch Source'
end

case node['platform']
when 'redhat'
  case node['platform_version'].to_i
  when 5
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el5-source&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el6-source&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el7-source&arch=$basearch&protocol=http'
  end
else
  case node['platform_version'].to_i
  when 5
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos5-source&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos6-source&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius-source']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos7-source&arch=$basearch&protocol=http'
  end
end
