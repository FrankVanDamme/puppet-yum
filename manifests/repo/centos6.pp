# = Class: yum::repo::centos6
#
# Base Centos6 repos
#
# == Parameters:
#
# [*mirror_url*]
#   A clean URL to a mirror of `rsync://msync.centos.org::CentOS`.
#   The paramater is interpolated with the known directory structure to
#   create a the final baseurl parameter for each yumrepo so it must be
#   "clean", i.e., without a query string like `?key1=valA&key2=valB`.
#   Additionally, it may not contain a trailing slash.
#   Example: `http://mirror.example.com/pub/rpm/centos`
#   Default: `undef`
#
class yum::repo::centos6 (
  $mirror_url = undef,
) {

  if $mirror_url {
	include yum::disable_fastest
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w\.~-]*)*$',
      "\$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash. Recieved '${mirror_url}'"
    )
    $baseurl_base = "${mirror_url}/\$releasever/os/\$basearch/"
    $baseurl_updates = "${mirror_url}/\$releasever/updates/\$basearch/"
    $baseurl_extras = "${mirror_url}/\$releasever/extras/\$basearch/"
    $baseurl_centosplus = "${mirror_url}/\$releasever/centosplus/\$basearch/"
	$baseurl_contrib = "${mirror_url}/\$releasever/contrib/\$basearch/"
    $mirrorlist_base = undef
    $mirrorlist_updates = undef
    $mirrorlist_extras = undef
    $mirrorlist_centosplus = undef
	$mirrorlist_contrib = undef
  } else {
    $baseurl_base = undef
    $baseurl_updates = undef
    $baseurl_extras = undef
    $baseurl_centosplus = undef
	$baseurl_contrib = undef
    $mirrorlist_base = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=os&infra=$infra'
    $mirrorlist_updates = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=updates&infra=$infra'
    $mirrorlist_extras = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra'
    $mirrorlist_centosplus = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra'
	$mirrorlist_contrib = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=contrib&infra=$infra'
  }

  yum::managed_yumrepo { 'base':
    descr          => 'CentOS-$releasever - Base',
    baseurl        => $baseurl_base,
    mirrorlist     => $mirrorlist_base,
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'updates':
    descr          => 'CentOS-$releasever - Updates',
    baseurl        => $baseurl_updates,
    mirrorlist     => $mirrorlist_updates,
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'extras':
    descr          => 'CentOS-$releasever - Extras',
    baseurl        => $baseurl_extras,
    mirrorlist     => $mirrorlist_extras,
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 2,
  }

  yum::managed_yumrepo { 'centosplus':
    descr          => 'CentOS-$releasever - Centosplus',
    baseurl        => $baseurl_centosplus,
    mirrorlist     => $mirrorlist_centosplus,
    failovermethod => 'priority',
    enabled        => 1,
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 3,
  }

  yum::managed_yumrepo { 'contrib':
    descr          => 'CentOS-$releasever - Contrib',
    baseurl        => $baseurl_contrib,
    mirrorlist     => $mirrorlist_contrib,
    failovermethod => 'priority',
    gpgcheck       => 1,
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-6',
    priority       => 10,
  }

}
