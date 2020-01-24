# = Class: yum::repo::nginx
#
# This class installs the nginx repo
#
class yum::repo::nginx (
	Enum['stable','mainline'] $stream = 'stable'
) {
	if ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] == 'RedHat') {
		$use_os_path = 'rhel'
	} elsif ($facts['os']['family'] == 'RedHat' and $facts['os']['name'] == 'CentOS') {
		$use_os_path = 'centos'
	} else {
		fail("OS is currently not supported")
	}

	$baseurl = $stream ? {
		'stable' => "http://nginx.org/packages/${use_os_path}/\$releasever/\$basearch/",
		default  => "http://nginx.org/packages/${stream}/${use_os_path}/\$releasever/\$basearch/"
	}

  yum::managed_yumrepo { 'nginx':
    descr    => "nginx ${stream} repo",
    baseurl  => $baseurl,
    enabled  => 1,
    gpgcheck => 1,
		gpgkey   => 'https://nginx.org/keys/nginx_signing.key',
    priority => 1,
  }
}
