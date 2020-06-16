# = Class: yum::repo::centos8
#
# Base Centos8 repos
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
class yum::repo::centos8 (
  $mirror_url = undef,
) {

  if $mirror_url {
	include yum::disable_fastest
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\/[\w\.~-]*)*$',
      "\$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash. Recieved '${mirror_url}'"
    )
    $baseurl_base = "${mirror_url}/\$releasever/os/\$basearch/"
    $baseurl_updates = "${mirror_url}/\$releasever/updates/\$basearch/"
    $baseurl_extras = "${mirror_url}/\$releasever/extras/\$basearch/"
    $baseurl_centosplus = "${mirror_url}/\$releasever/centosplus/\$basearch/"
    $mirrorlist_base = undef
    $mirrorlist_updates = undef
    $mirrorlist_extras = undef
    $mirrorlist_centosplus = undef
  } else {
    $baseurl_base = undef
    $baseurl_updates = undef
    $baseurl_extras = undef
    $baseurl_centosplus = undef
    $mirrorlist_base = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra'
    $mirrorlist_extras = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra'
    $mirrorlist_centosplus = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra'
  }

  yum::managed_yumrepo { 'base':
    descr         => 'CentOS-$releasever - Base',
    baseurl       => $baseurl_base,
    mirrorlist    => $mirrorlist_base,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-8',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-8',
    priority      => 2,
  }

  yum::managed_yumrepo { 'extras':
    descr      => 'CentOS-$releasever - Extras',
    baseurl    => $baseurl_extras,
    mirrorlist => $mirrorlist_extras,
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-8',
    priority   => 2,
  }

  yum::managed_yumrepo { 'centosplus':
    descr      => 'CentOS-$releasever - Centosplus',
    baseurl    => $baseurl_centosplus,
    mirrorlist => $mirrorlist_centosplus,
    enabled    => 1,
    gpgcheck   => 1,
    gpgkey     => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-CentOS-8',
    priority   => 3,
  }

}
