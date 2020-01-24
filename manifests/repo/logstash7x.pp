# = Class: yum::repo::logstash7x
#
# This class installs the logstash7x repo
#
class yum::repo::logstash7x (
  $baseurl = 'https://artifacts.elastic.co/packages/7.x/yum',
) {

  yum::managed_yumrepo { 'logstash-7.x':
    descr         => 'Elastic repository for 7.x packages',
    baseurl       => $baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  }

}
