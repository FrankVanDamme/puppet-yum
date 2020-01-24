# = Class: yum::repo::pdgd95
#
# This class installs the postgresql 9.6 repo
#
class yum::repo::pgdg96 {
  yum::managed_yumrepo { 'pgdg96':
    descr         => 'PostgreSQL 9.6 $releasever - $basearch',
    baseurl       => 'http://yum.postgresql.org/9.6/redhat/rhel-$releasever-$basearch',
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-PGDG',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-PGDG',
    priority      => 20,
  }
}
