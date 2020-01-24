# = Class: yum::repo::blackfire
#
# This class installs the blackfire repo
#
class yum::repo::blackfire {
  yum::managed_yumrepo { 'blackfire':
    descr         => 'Blackfire repository for CentOS/Redhat/Fedora Linux',
    baseurl       => 'http://packages.blackfire.io/fedora/$releasever/$basearch',
    enabled       => 1,
	repo_gpgcheck => 1,
    gpgcheck      => 0,
    gpgkey        => 'https://packagecloud.io/gpg.key',
    priority      => 1,
	sslverify     => 1,
	sslcacert     => '/etc/pki/tls/certs/ca-bundle.crt'
  }
}
