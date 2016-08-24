# = Class: yum::repo::elasticbeats
#
# This class installs the elastic beats repo.
#
class yum::repo::elasticbeats (
  $baseurl = 'https://packages.elastic.co/beats/yum/el/$basearch'
) {
  
  yum::managed_yumrepo { 'elasticbeats':
    descr         => 'Elastic Beats Repository',
    baseurl       => $baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-elasticsearch',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-elasticsearch',
  }

}
