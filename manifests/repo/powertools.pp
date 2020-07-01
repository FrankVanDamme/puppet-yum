#
# This class installs the powertools repo
#
class yum::repo::powertools (){

  require yum

  yum::managed_yumrepo { 'CentOS-PowerTools':
    descr      => 'Powertools for CentOS',
    mirrorlist => 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=PowerTools&infra=$infra',
    enabled    => 1,
    gpgcheck   => 1,
    priority   => 90,
  }
}
