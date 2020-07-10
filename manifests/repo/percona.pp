# = Class: yum::repo::percona
#
# This class installs the Percona RPM Repository
#
class yum::repo::percona (
	Optional[String] $mirror_url = undef,
	Enum[0,1] $enabled = 1,
) {
	$key_names = [ 'PERCONA-PACKAGING-KEY', 'RPM-GPG-KEY-percona' ]
	if ($mirror_url) {
		$use_url = $mirror_url
		$use_gpgsrc = prefix($key_names, 'puppet:///modules/yum/rpm-gpg/')
		$use_gpgkey = prefix($key_names, 'file:///etc/pki/rpm-gpg/')
	} else {
		$base_url = 'http://repo.percona.com/yum/release'
		if ($facts['os']['name'] == 'CentOS' and versioncmp($facts['os']['release']['major'], '7') <= 0) {
			$use_base_url = "${base_url}/${downcase($facts['os']['name'])}"
		} else {
			$use_base_url = $base_url
		}

		if (versioncmp($facts['os']['release']['major'], '8') >= 0) {
			$use_url = "${use_base_url}/\$releasever/RPMS/\$basearch/"
		} else {
			$use_url = "${use_base_url}/\$releasever/os/\$basearch/"
		}
		$use_gpgsrc = undef
		$use_gpgkey = [ 'https://repo.percona.com/yum/PERCONA-PACKAGING-KEY', 'https://www.percona.com/downloads/RPM-GPG-KEY-percona' ]
	}

	yum::managed_yumrepo { 'percona':
		descr          => 'Percona RPM Repository (http://www.percona.com/percona-lab.html)',
		baseurl        => $use_url,
		enabled        => $enabled,
		gpgcheck       => 1,
		failovermethod => 'priority',
		gpgkey_source  => $use_gpgsrc,
		gpgkey         => $use_gpgkey,
		priority       => 1,
	}
}
