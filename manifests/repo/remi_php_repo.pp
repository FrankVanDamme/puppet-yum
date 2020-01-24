#
# Defined type for easily managing a remi repository for a specific PHP version
#
define yum::repo::remi_php_repo (
	Pattern[/\A[57]\.\d\z/] $version = $name,
	Optional[String] $mirror_url = undef
) {
	$releasever = $::operatingsystem ? {
		/(?i:Amazon)/ => '6',
		default       => '$releasever',  # Yum var
	}

	$os = $::operatingsystem ? {
		/(?i:Fedora)/ => 'fedora',
		default       => 'enterprise',
	}

	$osname = $::operatingsystem ? {
		/(?i:Fedora)/ => 'Fedora',
		default       => 'Enterprise Linux',
	}

	$version_short = regsubst($version, '\.', '')

	if ($mirror_url) {
		$use_baseurl    = $mirror_url
		$use_mirrorlist = 'absent'
	} else {
		$mirror_list_base_url = "http://rpms.remirepo.net/${os}/${releasever}/php${version_short}"
		$use_baseurl          = 'absent'
		$use_mirrorlist       = $facts['os']['release']['major'] ? {
			'8'     => "${mirror_list_base_url}/\$basearch/mirror",
			default => "${mirror_list_base_url}/mirror"
		}
	}

	$el8_key = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2018'
	$el7_key = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi'
	if ($osname == 'Fedora') {
		if (versioncmp($facts['os']['release']['major'], '28') >= 0) {
			$use_gpg_url = $el8_key
		} elsif (versioncmp($facts['os']['release']['major'], '26') == 0 or versioncmp($facts['os']['release']['major'], '27') == 0) {
			$use_gpg_url = 'http://rpms.remirepo.net/RPM-GPG-KEY-remi2017'
		} else {
			$use_gpg_url = $el7_key
		}
	} else {
		$use_gpg_url = $facts['os']['release']['major'] ? {
			'8'     => $el8_key,
			default => $el7_key
		}
	}

	yum::managed_yumrepo { "remi-php${version_short}":
		descr      => "Remi's PHP ${version} RPM repository for ${osname} \$releasever - \$basearch",
		baseurl    => $use_baseurl,
		mirrorlist => $use_mirrorlist,
		enabled    => 1,
		gpgcheck   => 1,
		gpgkey     => $use_gpg_url,
		priority   => 1,
	}
}
