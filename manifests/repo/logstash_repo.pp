#
# Defined type for easily managing a logstash repository for a specific version
#
define yum::repo::logstash_repo (
	Enum['5','6','7'] $version = $name,
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	if ($mirror_url) {
		$baseurl = $mirror_url
	} else {
		$baseurl = "https://artifacts.elastic.co/packages/${version}.x/yum"
	}

	yum::managed_yumrepo { "logstash-${version}.x":
		descr         => "Elastic repository for ${version}.x packages",
		baseurl       => $baseurl,
		enabled       => 1,
		gpgcheck      => 1,
		gpgkey        => 'https://artifacts.elastic.co/GPG-KEY-elasticsearch'
	}
}
