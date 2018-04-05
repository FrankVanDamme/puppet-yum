# = Class: yum::repo::ovirt42
#
# This class installs the Software Collections Repository (RH part)
#
class yum::repo::ovirt42 (
  $baseurl = ''
) {

  $osver = split($::operatingsystemrelease, '[.]')
  $release = $::operatingsystem ? {
    /(?i:Centos|RedHat|Scientific)/ => $osver[0],
    default                         => '6',
  }

  $real_baseurl = $baseurl ? {
    ''      => "http://resources.ovirt.org/pub/ovirt-4.2/rpm/el\$releasever/",
    default => $baseurl,
  }

  yum::managed_yumrepo { 'ovirt42':
    descr          => 'Latest oVirt 4.2 Release',
    baseurl        => $real_baseurl,
    enabled        => 1,
    gpgcheck       => 1,
    priority       => 20,
    failovermethod => 'priority',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-ovirt-4.2',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-ovirt4.2',
  }

}
