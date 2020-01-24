#
# OpenResty Repo for CentOS/REHL 6/7
#
class yum::repo::openresty {
	$repo_os = $facts['os']['name'] ? {
		'RedHat' => 'rhel',
		default  => downcase($facts['os']['name'])
	}
	yum::managed_yumrepo { 'openresty':
		descr          => "Official OpenResty Open Source Repository for ${facts['os']['name']}",
		baseurl        => "https://openresty.org/package/${repo_os}/\$releasever/\$basearch",
		enabled        => 1,
		gpgcheck       => 1,
		gpgkey         => 'https://openresty.org/package/pubkey.gpg'
	}
}
