# = Class: yum::repo::puppet5
#
# This class installs the puppet5 repo
#
class yum::repo::puppet5 (
  $host_server = 'yum.puppetlabs.com',
  $baseurl     = '',
  $priority    = 99,
) {
	$version = 5
  $osver = $::operatingsystem ? {
    'XenServer' => [ '5' ],
    default     => split($::operatingsystemrelease, '[.]')
  }
  $release = $::operatingsystem ? {
    /(?i:Centos|RedHat|Scientific|CloudLinux|XenServer|OracleLinux)/ => $osver[0],
    default                                              => '6',
  }

  $real_baseurl = $baseurl ? {
	''      => "http://${host_server}/puppet${version}/el/${release}/\$basearch",
    default => $baseurl,
  }

  yum::managed_yumrepo { "puppet${version}":
    descr          => "Puppet ${version} Repository el ${release} - \$basearch",
    baseurl        => $real_baseurl,
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-puppet${version}-release",
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-puppet',
    gpgkey_name    => "RPM-GPG-KEY-puppet${version}-release",
    priority       => $priority,
  }
  -> file { "/etc/pki/rpm-gpg/RPM-GPG-KEY-puppet${version}":
    ensure => 'absent'
  }
}
