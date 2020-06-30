# = Class: yum::repo::docker
#
# This class installs the official Docker CE repo
#
class yum::repo::docker_ce (
  $baseurl = undef
) {
  $gpg_key_url = 'https://download.docker.com/linux/centos/gpg'
  case $::operatingsystem {
    'RedHat', 'CentOS', 'Scientific': {
      $os_release = 'centos'
    }
    default: {
      $os_release = $::operatingsystem
    }
  }

  if $baseurl {
    validate_re(
      $baseurl,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w~-]*)*$',
      '$baseurl must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash.'
    )
    $baseurl_ensured = $baseurl
  } else {
    $baseurl_ensured = "https://download.docker.com/linux/${os_release}/7"
  }

  yum::managed_yumrepo { 'docker-ce':
	descr         => 'Docker CE Stable - $basearch',
    baseurl       => "${baseurl_ensured}/\$basearch/stable",
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => $gpg_key_url,
    autokeyimport => 'yes'
  }

#  yum::managed_yumrepo { 'docker-ce-stable-debuginfo':
#	descr         => 'Docker CE Stable - Debuginfo $basearch',
#    baseurl       => "${baseurl_ensured}/\$basearch/stable",
#    enabled       => 0,
#    gpgcheck      => 1,
#    gpgkey        => $gpg_key_url,
#    autokeyimport => 'yes'
#  }
#
#  yum::managed_yumrepo { 'docker-ce-stable-source':
#	descr         => "Docker CE Stable - Sources",
#    baseurl       => "${baseurl_ensured}/\$basearch/stable",
#    enabled       => 0,
#    gpgcheck      => 1,
#    gpgkey        => $gpg_key_url,
#    autokeyimport => 'yes'
#  }
}
