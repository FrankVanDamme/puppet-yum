# = Class: yum::repo::atomic
#
# This class installs the atomic repo
#
class yum::repo::atomic (
	Enum['present','absent'] $ensure = 'present',
	Optional[Stdlib::Httpurl] $mirror_url = undef
) {
	$os = downcase($facts['os']['name'])

	if ($mirror_url) {
		$use_baseurl    = "${mirror_url}/${os}/\$releasever/\$basearch"
		$use_mirrorlist = undef
	} else {
		$use_baseurl    = undef
		$use_mirrorlist = "http://updates.atomicorp.com/channels/mirrorlist/atomic/${os}-\$releasever-\$basearch"
	}

	yum::managed_yumrepo { 'atomic':
		ensure        => $ensure,
		descr         => 'CentOS / Red Hat Enterprise Linux $releasever - atomic',
		baseurl       => $use_baseurl,
		mirrorlist    => $use_mirrorlist,
		enabled       => 1,
		gpgcheck      => 1,
		gpgkey        => [ 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY.atomicorp', 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY.art' ],
		gpgkey_source => [ 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY.atomicorp', 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY.art' ],
		priority      => 1,
		exclude       => 'nmap-ncat',
	}
}
