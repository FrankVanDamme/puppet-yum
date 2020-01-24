# = Class: yum::repo::logstash
#
# This class installs the logstash repo.
# You can choose which version should be installed with $version parameter, defaults to 2.3.
#
class yum::repo::logstash (
  $version = '2.3',
  $baseurl = undef
) {

  $_baseurl = $baseurl?{
    undef => 'http://packages.elasticsearch.org/logstash/${version}/centos',
    default => $baseurl
  }

  yum::managed_yumrepo { "logstash-${version}":
    descr         => "logstash repository for ${version} packages",
    baseurl       => $_baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elasticsearch',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-elasticsearch',
  }

}
