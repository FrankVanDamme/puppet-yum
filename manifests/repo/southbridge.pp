# = Class: yum::repo::southbridge
#
# This class installs the Southbridge repo
#
class yum::repo::southbridge (
  $baseurl = 'http://rpms.southbridge.ru/rhel7/stable/x86_64/'
) {

  require yum

  yum::managed_yumrepo { 'southbridge':
    descr    => 'Southbridge RPMS for CentOS 7',
    baseurl  => $baseurl,
    enabled  => 1,
    gpgcheck => 0,
    priority => 10,
  }
}
