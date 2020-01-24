# = Class: yum::repo::erlang
#
# This class installs the erlang repository from Erlang Solutions
#
class yum::repo::erlang (
	Enum['present','absent'] $ensure = 'present',
	Optional[Stdlib::Httpurl] $mirror_url = undef,
	Optional[String] $exclude = undef
) {
	if ($mirror_url) {
		$use_baseurl = $mirror_url
	} else {
		$use_baseurl = 'http://packages.erlang-solutions.com/rpm/centos/$releasever/$basearch'
	}
	yum::managed_yumrepo { 'erlang':
		ensure         => $ensure,
		descr          => 'Erlang solutions official repository for RHEL and Cent OS - $basearch',
		baseurl        => $use_baseurl,
		enabled        => 1,
		failovermethod => 'priority',
		priority       => 1,
		gpgcheck       => 1,
		gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-erlang',
		gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-erlang',
		exclude        => $exclude
	}
}
