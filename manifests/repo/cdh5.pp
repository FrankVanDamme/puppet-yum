#
# class yum::repo::cdh5 - Sets-up the Cloudera 5 Repo
#
# @param version A specific version to lock to, or 5 (default) which is a link to the latest release at the time (default baseurl only)
# @param baseurl An overriding URL to use (must be a full Yum repository URL for the cdh5 packages)
# @param baseurl_extras An overriding URL to use (must be a full Yum repository URL for the gplextra5 packages)
class yum::repo::cdh5 (
	Pattern[/\A5(\.\d\d?){0,2}\z/] $version = 5,
	Optional[Stdlib::HTTPurl] $baseurl = undef,
	Optional[Stdlib::HTTPurl] $baseurl_extras = undef
) {
	unless (($baseurl and $baseurl) or $facts['os']['hardware'] == 'x86_64') {
		fail('Only x86_84 packages are hosted in the cloudera repository')
	}
	if ($baseurl) {
		$use_baseurl = $baseurl
	} else {
		$use_baseurl = "https://archive.cloudera.com/cdh5/redhat/${facts['os']['release']['major']}/x86_64/cdh/${version}/"
	}
	if ($baseurl_extras) {
		$use_baseurl_extras = $baseurl_extras
	} else {
		$use_baseurl_extras = "https://archive.cloudera.com/gplextras5/redhat/${facts['os']['release']['major']}/x86_64/gplextras/${version}/"
	}

	yum::managed_yumrepo { 'cloudera-cdh5':
		descr          => "Cloudera's Distribution for Hadoop, Version 5",
		baseurl        => $use_baseurl,
		enabled        => 1,
		gpgcheck       => 1,
		gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cloudera',
		gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-cloudera',
		priority       => 20,
		failovermethod => 'priority',
	}

	yum::managed_yumrepo { 'cloudera-gplextras5':
		descr          => "Cloudera's GPLExtras, Version 5",
		baseurl        => $use_baseurl_extras,
		enabled        => 1,
		gpgcheck       => 1,
		gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-cloudera',
		gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-cloudera',
		priority       => 20,
		failovermethod => 'priority',
	}
}
