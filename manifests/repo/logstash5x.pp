# = Class: yum::repo::logstash5x
#
# This class installs the logstash5x repo
#
class yum::repo::logstash5x (
  $baseurl = 'https://artifacts.elastic.co/packages/5.x/yum',
) {

  yum::managed_yumrepo { 'logstash-5.x':
    descr         => 'Elastic repository for 5.x packages',
    baseurl       => $baseurl,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
  }

}
