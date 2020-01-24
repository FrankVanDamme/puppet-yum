# = Class: yum::repo::datastax
#
# This class installs the datastax community repo for Apache Cassandra
#
class yum::repo::datastax {
  yum::managed_yumrepo { 'datastax':
    descr          => 'DataStax Repo for Apache Cassandra',
    baseurl        => 'http://rpm.datastax.com/community',
    enabled        => 1,
    gpgcheck       => 0,
  }
}
