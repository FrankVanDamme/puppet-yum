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
  $mirror_url_has_contentdir = false,
  $mirror_url_strip_contentdir = true
) {

  if $mirror_url {
	include yum::disable_fastest
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\/[\w\.~-]*)*$',
      "\$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash. Recieved '${mirror_url}'"
    )
    if ($mirror_url_has_contentdir) {
      if ($mirror_url_strip_contentdir) {
        $use_mirror_url = regsubst($mirror_url, /centos$/, '$contentdir')
      } else {
        $use_mirror_url = $mirror_url
      }
    } else {
      $use_mirror_url = "${mirror_url}/\$contentdir"
    }
    $baseurl_app = "${use_mirror_url}/\$releasever/AppStream/\$basearch/os/"
    $baseurl_base = "${use_mirror_url}/\$releasever/BaseOS/\$basearch/os/"
    $baseurl_extras = "${use_mirror_url}/\$releasever/extras/\$basearch/os/"
    $baseurl_centosplus = "${use_mirror_url}/\$releasever/centosplus/\$basearch/os/"
    $mirrorlist_app = undef
    $mirrorlist_base = undef
    $mirrorlist_extras = undef
    $mirrorlist_centosplus = undef
  } else {
    $baseurl_app = undef
    $baseurl_base = undef
    $baseurl_extras = undef
    $baseurl_centosplus = undef
    $mirrorlist_app = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=AppStream&infra=$infra'
    $mirrorlist_base = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=BaseOS&infra=$infra'
    $mirrorlist_extras = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=extras&infra=$infra'
    $mirrorlist_centosplus = 'http://mirrorlist.centos.org/?release=$releasever&arch=$basearch&repo=centosplus&infra=$infra'
  }

  yum::managed_yumrepo { 'AppStream':
    descr         => 'CentOS-$releasever - AppStream',
    baseurl       => $baseurl_app,
    mirrorlist    => $mirrorlist_app,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-8'
  }

  yum::managed_yumrepo { 'BaseOS':
    descr         => 'CentOS-$releasever - Base',
    baseurl       => $baseurl_base,
    mirrorlist    => $mirrorlist_base,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-8'
  }

  yum::managed_yumrepo { 'centosplus':
    descr         => 'CentOS-$releasever - Plus',
    baseurl       => $baseurl_centosplus,
    mirrorlist    => $mirrorlist_centosplus,
    enabled       => 0,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-8'
  }

  yum::managed_yumrepo { 'extras':
    descr         => 'CentOS-$releasever - Extras',
    baseurl       => $baseurl_extras,
    mirrorlist    => $mirrorlist_extras,
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-centosofficial',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-CentOS-8'
  }

  yum::managed_yumrepo { 'updates':
    ensure => 'absent'
  }

}
