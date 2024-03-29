default['yum']['ius-archive-debuginfo']['repositoryid'] = 'ius-archive-debuginfo'
default['yum']['ius-archive-debuginfo']['enabled'] = false
default['yum']['ius-archive-debuginfo']['managed'] = false
default['yum']['ius-archive-debuginfo']['failovermethod'] = 'priority'
default['yum']['ius-archive-debuginfo']['gpgkey'] = 'https://dl.iuscommunity.org/pub/ius/IUS-COMMUNITY-GPG-KEY'
default['yum']['ius-archive-debuginfo']['gpgcheck'] = true
case node['platform_version'].to_i
when 5
  default['yum']['ius-archive-debuginfo']['sslverify'] = false
end

case node['platform_version'].to_i
when 5
  default['yum']['ius-archive-debuginfo']['description'] = 'IUS Community Packages for Enterprise Linux 5 - $basearch Archive Debug'
when 6
  default['yum']['ius-archive-debuginfo']['description'] = 'IUS Community Packages for Enterprise Linux 6 - $basearch Archive Debug'
when 7
  default['yum']['ius-archive-debuginfo']['description'] = 'IUS Community Packages for Enterprise Linux 7 - $basearch Archive Debug'
end

case node['platform']
when 'redhat'
  case node['platform_version'].to_i
  when 5
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el5-archive-debuginfo&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el6-archive-debuginfo&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-el7-archive-debuginfo&arch=$basearch&protocol=http'
  end
else
  case node['platform_version'].to_i
  when 5
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos5-archive-debuginfo&arch=$basearch&protocol=http'
  when 6
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos6-archive-debuginfo&arch=$basearch&protocol=http'
  when 7
    default['yum']['ius-archive-debuginfo']['mirrorlist'] = 'https://mirrors.iuscommunity.org/mirrorlist/?repo=ius-centos7-archive-debuginfo&arch=$basearch&protocol=http'
  end
end
