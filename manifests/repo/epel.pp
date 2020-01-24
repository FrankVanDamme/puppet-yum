# = Class: yum::repo::epel
#
# This class installs the epel repo
#
# == Parameters:
#
# [*mirror_url*]
#   A clean URL to a mirror of `http://dl.fedoraproject.org/pub/epel/`.
#   The paramater is interpolated with the known directory structure to
#   create a the final baseurl parameter for each yumrepo so it must be
#   "clean", i.e., without a query string like `?key1=valA&key2=valB`.
#   Additionally, it may not contain a trailing slash.
#   Example: `http://mirror.example.com/pub/rpm/epel`
#   Default: `undef`
#
class yum::repo::epel (
  $mirror_url = undef
) {

  $osver = $::operatingsystem ? {
    'Amazon'    => [ '6' ],
    'XenServer' => [ '5' ],
    default     => split($::operatingsystemrelease, '[.]')
  }

  if $mirror_url {
	include yum::disable_fastest
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w\.~-]*)*$',
      "\$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash. Recieved '${mirror_url}'"
    )
    $baseurl_epel = "${mirror_url}/${osver[0]}/\$basearch/"
    $baseurl_epel_debuginfo = "${mirror_url}/${osver[0]}/\$basearch/debug"
    $baseurl_epel_source = "${mirror_url}/${osver[0]}/SRPMS/"
    $baseurl_epel_testing = "${mirror_url}/testing/${osver[0]}/\$basearch/"
    $baseurl_epel_testing_debuginfo = "${mirror_url}/testing/${osver[0]}/\$basearch/debug"
    $baseurl_epel_testing_source = "${mirror_url}/testing/${osver[0]}/SRPMS/"
	$metalink_epel = undef
	$metalink_epel_debuginfo = undef
	$metalink_epel_source = undef
	$metalink_epel_testing = undef
	$metalink_epel_testing_debuginfo = undef
	$metalink_epel_testing_source = undef
  } else {
    $baseurl_epel = undef
    $baseurl_epel_debuginfo = undef
    $baseurl_epel_source = undef
    $baseurl_epel_testing = undef
    $baseurl_epel_testing_debuginfo = undef
    $baseurl_epel_testing_source = undef
	$metalink_epel = "http://mirrors.fedoraproject.org/metalink?repo=epel-${osver[0]}&arch=\$basearch"
	$metalink_epel_debuginfo = "http://mirrors.fedoraproject.org/metalink?repo=epel-debug-${osver[0]}&arch=\$basearch"
	$metalink_epel_source = "http://mirrors.fedoraproject.org/metalink?repo=epel-source-${osver[0]}&arch=\$basearch"
	$metalink_epel_testing = "http://mirrors.fedoraproject.org/metalink?repo=testing-epel${osver[0]}&arch=\$basearch"
	$metalink_epel_testing_debuginfo = "http://mirrors.fedoraproject.org/metalink?repo=testing-debug-epel${osver[0]}&arch=\$basearch"
	$metalink_epel_testing_source = "http://mirrors.fedoraproject.org/metalink?repo=testing-source-epel${osver[0]}&arch=\$basearch"
  }

  yum::managed_yumrepo { 'epel':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - \$basearch",
    baseurl        => $baseurl_epel,
    metalink       => $metalink_epel,
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'epel-debuginfo':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - \$basearch - Debug",
    baseurl        => $baseurl_epel_debuginfo,
    metalink       => $metalink_epel_debuginfo,
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'epel-source':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - \$basearch - Source",
    baseurl        => $baseurl_epel_source,
    metalink       => $metalink_epel_source,
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'epel-testing':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - Testing - \$basearch",
    baseurl        => $baseurl_epel_testing,
    metalink       => $metalink_epel_testing,
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 17,
  }

  yum::managed_yumrepo { 'epel-testing-debuginfo':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - Testing - \$basearch - Debug",
    baseurl        => $baseurl_epel_testing_debuginfo,
    metalink       => $metalink_epel_testing_debuginfo,
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 17,
  }

  yum::managed_yumrepo { 'epel-testing-source':
    descr          => "Extra Packages for Enterprise Linux ${osver[0]} - Testing - \$basearch - Source",
    baseurl        => $baseurl_epel_testing_source,
    metalink       => $metalink_epel_testing_source,
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-EPEL-${osver[0]}",
    priority       => 17,
  }

}

