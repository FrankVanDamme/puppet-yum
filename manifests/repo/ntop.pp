# = Class: yum::repo::ntop
#
# This class installs the ntop RPM Repository
#
class yum::repo::ntop {
  yum::managed_yumrepo { 'ntop':
    descr          => 'ntop',
    baseurl        => 'http://packages.ntop.org/centos/$releasever/$basearch/',
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => 'http://packages.ntop.org/centos/RPM-GPG-KEY-deri',
    priority       => 1,
  }
  yum::managed_yumrepo { 'ntop-noarch':
    descr          => 'ntop-noarch',
    baseurl        => 'http://packages.ntop.org/centos/$releasever/noarch/',
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => 'http://packages.ntop.org/centos/RPM-GPG-KEY-deri',
    priority       => 1,
  }
}
