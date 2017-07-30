# = Class: yum::repo::rpmfusion
#
# This class installs the rpmfusion repo
#
# == Parameters:
#
# [*mirror_url*]
#   A clean URL to a mirror of `https://download1.rpmfusion.org`.
#   The paramater is interpolated with the known directory structure to
#   create a the final baseurl parameter for each yumrepo so it must be
#   "clean", i.e., without a query string like `?key1=valA&key2=valB`.
#   Additionally, it may not contain a trailing slash.
#   Example: `http://mirror.host.ag/rpmfusion`
#   Default: `undef`
#
class yum::repo::rpmfusion (
  $mirror_url = undef
) {

  if $mirror_url {
    validate_re(
      $mirror_url,
      '^(?:https?|ftp):\/\/[\da-zA-Z-][\da-zA-Z\.-]*\.[a-zA-Z]{2,6}\.?(?:\:[0-9]{1,5})?(?:\/[\w~-]*)*$',
      '$mirror must be a Clean URL with no query-string, a fully-qualified hostname and no trailing slash.'
    )
  }

  $osver = $::operatingsystem ? {
    'Amazon'    => [ '6' ],
    'XenServer' => [ '5' ],
    default     => split($::operatingsystemrelease, '[.]')
  }

  $baseurl_rpmfusion_free_updates = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/updates/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_free_updates_debuginfo = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/debuginfo/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_free_updates_source = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/updatees/${osver[0]}/\$basearch/debug/",
  }

  $baseurl_rpmfusion_free_updates_testing = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/updates/testing/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_free_updates_testing_debuginfo = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/updates/testing/${osver[0]}/\$basearch/debug/",
  }

  $baseurl_rpmfusion_free_updates_testing_source = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/free/el/updates/testing/${osver[0]}/SRPMS/",
  }

  $baseurl_rpmfusion_nonfree_updates = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/updates/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_nonfree_updates_debuginfo = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/debuginfo/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_nonfree_updates_source = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/updatees/${osver[0]}/\$basearch/debug/",
  }

  $baseurl_rpmfusion_nonfree_updates_testing = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/updates/testing/${osver[0]}/\$basearch/",
  }

  $baseurl_rpmfusion_nonfree_updates_testing_debuginfo = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/updates/testing/${osver[0]}/\$basearch/debug/",
  }

  $baseurl_rpmfusion_nonfree_updates_testing_source = $mirror_url ? {
    undef   => undef,
    default => "${mirror_url}/nonfree/el/updates/testing/${osver[0]}/SRPMS/",
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Updates",
    baseurl        => $baseurl_rpmfusion_free_updates,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-${osver[0]}&arch=\$basearch",
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates-debuginfo':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Updates Debug",
    baseurl        => $baseurl_rpmfusion_free_updates_debuginfo,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-debug-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates-source':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Updates Source",
    baseurl        => $baseurl_rpmfusion_free_updates_source,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-source-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates-testing':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Test Updates",
    baseurl        => $baseurl_rpmfusion_free_updates,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-testing-${osver[0]}&arch=$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates-testing-debuginfo':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Test Updates Debug",
    baseurl        => $baseurl_rpmfusion_free_updates_testing_debuginfo,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-testing-debug-${osver[0]}&arch=$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-free-updates-testing-source':
    descr          => "RPM Fusion for EL ${osver[0]} - Free - Test Updates Source",
    baseurl        => $baseurl_rpmfusion_free_updates_testing_source,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=free-el-updates-released-source-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-free-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Updates",
    baseurl        => $baseurl_rpmfusion_nonfree_updates,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-${osver[0]}&arch=\$basearch",
    enabled        => 1,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates-debuginfo':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Updates Debug",
    baseurl        => $baseurl_rpmfusion_nonfree_updates_debuginfo,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-debug-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates-source':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Updates Source",
    baseurl        => $baseurl_rpmfusion_nonfree_updates_source,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-source-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates-testing':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Test Updates",
    baseurl        => $baseurl_rpmfusion_nonfree_updates,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-testing-${osver[0]}&arch=$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates-testing-debuginfo':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Test Updates Debug",
    baseurl        => $baseurl_rpmfusion_nonfree_updates_testing_debuginfo,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-testing-debug-${osver[0]}&arch=$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

  yum::managed_yumrepo { 'rpmfusion-nonfree-updates-testing-source':
    descr          => "RPM Fusion for EL ${osver[0]} - Nonfree - Test Updates Source",
    baseurl        => $baseurl_rpmfusion_nonfree_updates_testing_source,
    mirrorlist     => "http://mirrors.rpmfusion.org/mirrorlist?repo=nonfree-el-updates-released-source-${osver[0]}&arch=\$basearch",
    enabled        => 0,
    gpgcheck       => 1,
    failovermethod => 'priority',
    gpgkey         => "file:///etc/pki/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    gpgkey_source  => "puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-rpmfusion-nonfree-el-${osver[0]}",
    priority       => 16,
  }

}

