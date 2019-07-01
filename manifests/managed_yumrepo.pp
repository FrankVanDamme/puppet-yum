# = Define yum::managed_yumrepo
#
define yum::managed_yumrepo (
	Enum['present','absnet'] $ensure = 'present',
  Variant[Enum['absent'],String[1]] $descr = 'absent',
  Variant[Enum['absent'],Yum::Url] $baseurl = 'absent',
  Variant[Enum['absent'],Yum::Url] $mirrorlist = 'absent',
  Variant[Enum['absent'],Yum::Url] $metalink = 'absent',
  Yum::Boolean $enabled = 0,
	String $file_name = $name,
  Yum::Boolean $gpgcheck = 0,
  Variant[Enum['absent'],Yum::Url,Array[Yum::Url]] $gpgkey = 'absent',
  Optional[Stdlib::Filesource] $gpgkey_source = undef,
  Optional[String[1]] $gpgkey_name = undef,
  Enum['absent','roundrobin','priority'] $failovermethod = 'absent',
  Integer $priority = 99,
  Variant[Enum['absent'],Yum::Boolean] $protect = 'absent',
  Variant[Enum['absent'],String[1]] $exclude = 'absent',
  Enum['yes','no'] $autokeyimport = 'no',
  Variant[Enum['absent'],String[1]] $includepkgs = 'absent',
  Variant[Enum['absent','never'],Pattern[/^[0-9]+[dhm]?$/]] $metadata_expire = 'absent',
  Variant[Enum['absent'],String[1]] $include = 'absent',
  Variant[Enum['absent'],Yum::Boolean] $repo_gpgcheck = 'absent',
  Variant[Enum['absent'],Pattern[$re::path]] $sslcacert = 'absent',
  Variant[Enum['absent'],Pattern[$re::path]] $sslclientcert = 'absent',
  Variant[Enum['absent'],Pattern[$re::path]] $sslclientkey = 'absent',
  Yum::Boolean $sslverify = 'absent'
) {

  # ensure that everything is setup
  include ::yum::prerequisites

  if $protect != 'absent' {
    if ! defined(Yum::Plugin['protectbase']) {
      yum::plugin { 'protectbase': }
    }
  }

  if $mirrorlist != 'absent' and $metalink != 'absent' {
    fail('Should not supply both metalink and mirrorlist arguments')
  }

	$file_ensure = $ensure ? {
		'present' => 'file',
		default   => $ensure
	}

	$repo_target_file = "/etc/yum.repos.d/${file_name}.repo"

  if ! defined(File[$repo_target_file]) {
    file { $repo_target_file:
      ensure  => $file_ensure,
      replace => false,
      before  => Yumrepo[ $name ],
      mode    => '0644',
      owner   => 'root',
      group   => 0,
    }

    $gpgkey_real_name = $gpgkey_name ? {
      undef   => url_parse($gpgkey_source,'filename'),
      default => $gpgkey_name,
    }

    if ($gpgkey_source) {
      if ! defined(File["/etc/pki/rpm-gpg/${gpgkey_real_name}"]) {
        file { "/etc/pki/rpm-gpg/${gpgkey_real_name}":
          ensure  => $file_ensure,
          replace => false,
          before  => Yumrepo[ $name ],
          source  => $gpgkey_source,
          mode    => '0644',
          owner   => 'root',
          group   => 0,
        }
      }
    }
  }

	$use_gpgkey = $gpgkey ? {
		Array   => join($gpgkey, ' '),
		default => $gpgkey
	}

  if ! defined(Yumrepo[$name]) {
    yumrepo { $name:
			ensure          => $ensure,
      descr           => $descr,
      baseurl         => $baseurl,
      mirrorlist      => $mirrorlist,
      metalink        => $metalink,
      enabled         => $enabled,
      gpgcheck        => $gpgcheck,
      gpgkey          => $use_gpgkey,
      failovermethod  => $failovermethod,
      priority        => $priority,
      protect         => $protect,
      exclude         => $exclude,
      includepkgs     => $includepkgs,
      metadata_expire => $metadata_expire,
      include         => $include,
      repo_gpgcheck   => $repo_gpgcheck,
      sslcacert       => $sslcacert,
      sslclientcert   => $sslclientcert,
      sslclientkey    => $sslclientkey,
      sslverify       => $sslverify,
			target          => $repo_target_file
    }

    if $ensure == 'present' and $autokeyimport == 'yes' and $gpgkey != 'absent' {
      exec { "rpmkey_add_${use_gpgkey}":
        command     => "rpm --import ${use_gpgkey}",
        before      => Yumrepo[ $name ],
        refreshonly => true,
        path        => '/sbin:/bin:/usr/sbin:/usr/bin',
      }
    }
  }
}
