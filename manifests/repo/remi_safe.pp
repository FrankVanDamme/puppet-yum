# = Class: yum::repo::remi_safe
#
# This class installs the remi safe repo
#
class yum::repo::remi_safe (
	Optional[String] $mirror_url = undef
) {
	$releasever = $::operatingsystem ? {
		/(?i:Amazon)/ => '6',
		default       => '$releasever',  # Yum var
	}

	if ($mirror_url) {
		$use_baseurl    = $mirror_url
		$use_mirrorlist = 'absent'
	} else {
		$use_baseurl    = 'absent'
		$use_mirrorlist = $facts['os']['release']['major'] ? {
			'8'     => "http://cdn.remirepo.net/enterprise/8/safe/\$basearch/mirror",
			default => "http://rpms.remirepo.net/enterprise/${releasever}/safe/mirror"
		}
	}

	$gpg_key = $facts['os']['release']['major'] ? {
		'8'     => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2018',
		default => 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
	}

	yum::managed_yumrepo { 'remi-safe':
		descr      => 'Safe Remi\'s RPM repository for Enterprise Linux $releasever - $basearch',
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => $gpg_key,
		priority   => 1
	}
}
