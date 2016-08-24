# = Class: yum::repo::kibana41
#
# This class installs the kibana41 repo
# You can choose which version should be installed with $version parameter, defaults to 4.5.
#
class yum::repo::kibana (
  $version = '4.5',
  $baseurl = undef,
) {

  $_baseurl = $baseurl?{
    undef => "http://packages.elastic.co/kibana/${version}/centos",
    default => $baseurl
  }

  yum::managed_yumrepo { "kibana-${version}":
    descr         => "Elasticsearch repository for kibana ${version}",
    baseurl       => $_baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elasticsearch',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-elasticsearch',
  }

}
