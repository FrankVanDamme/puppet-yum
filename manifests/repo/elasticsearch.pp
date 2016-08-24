# = Class: yum::repo::elasticsearch
#
# This class installs the elasticsearch repo.
# You can choose which version should be installed with $version parameter, defaults to 2.x. 
#
class yum::repo::elasticsearch (
  $version = '2.x',
  $baseurl = undef
) {
  
  $_baseurl = $baseurl?{
    undef => "http://packages.elastic.co/elasticsearch/${version}/centos",
    default => $baseurl
  }

  yum::managed_yumrepo { 'elasticsearch':
    descr         => "Elasticsearch repository for ${version} packages",
    baseurl       => $_baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elasticsearch',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-elasticsearch',
  }

}
