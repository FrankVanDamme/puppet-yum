# = Class: yum::repo::logstash6x
#
# This class installs the logstash6x repo
#
class yum::repo::logstash6x (
  $baseurl = 'https://artifacts.elastic.co/packages/6.x/yum',
) {

  yum::managed_yumrepo { 'logstash-6.x':
    descr         => 'Elastic repository for 6.x packages',
    baseurl       => $baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  }

}
