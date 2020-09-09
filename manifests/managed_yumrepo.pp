# = Define yum::managed_yumrepo
#
# == Parameters
#
# [*sslcacert*]
#   passed to yumrepo; the validation pattern validates Unix paths excluding 
#   the root directory "/"

define yum::managed_yumrepo (
	Enum['present','absent'] $ensure = 'present',
	Variant[Enum['absent'],String[1]] $descr = 'absent',
	Variant[Enum['absent'],Yum::Url] $baseurl = 'absent',
	Variant[Enum['absent'],Yum::Url] $mirrorlist = 'absent',
	Variant[Enum['absent'],Yum::Url] $metalink = 'absent',
	Yum::Boolean $enabled = 0,
	String $file_name = $name,
	Yum::Boolean $gpgcheck = 0,
	Variant[Enum['absent'],Yum::Url,Array[Yum::Url]] $gpgkey = 'absent',
	Optional[Variant[Stdlib::Filesource,Array[Stdlib::Filesource]]] $gpgkey_source = undef,
	Optional[String[1]] $gpgkey_name = undef,
	Yum::Boolean $s3_enabled = 0,
	Enum['absent','roundrobin','priority'] $failovermethod = 'absent',
	Integer $priority = 99,
	Variant[Enum['absent'],Yum::Boolean] $protect = 'absent',
	Variant[Enum['absent'],String[1]] $exclude = 'absent',
	Enum['yes','no'] $autokeyimport = 'no',
	Variant[Enum['absent'],String[1]] $includepkgs = 'absent',
	Variant[Enum['absent','never'],Pattern[/^[0-9]+[dhm]$/],Integer[0]] $metadata_expire = 'absent',
	Variant[Enum['absent'],String[1]] $include = 'absent',
	Variant[Enum['absent'],Yum::Boolean] $repo_gpgcheck = 'absent',
	Variant[Enum['absent'],Pattern[/^\/([\w\.%-]+)(\/[\w\.%-]+)*\z/]] $sslcacert = 'absent',
	Variant[Enum['absent'],Pattern[/^\/([\w\.%-]+)(\/[\w\.%-]+)*\z/]] $sslclientcert = 'absent',
	Variant[Enum['absent'],Pattern[/^\/([\w\.%-]+)(\/[\w\.%-]+)*\z/]] $sslclientkey = 'absent',
	Variant[Enum['absent'],Yum::Boolean] $sslverify = 'absent'
) {

	# ensure that everything is setup
	include ::yum::prerequisites

	if ($protect != 'absent') {
		if ! defined(Yum::Plugin['protectbase']) {
			yum::plugin { 'protectbase': }
		}
	}

	if ($mirrorlist != 'absent' and $metalink != 'absent') {
		fail('Should not supply both metalink and mirrorlist arguments')
	}

	$file_ensure = $ensure ? {
		'present' => 'file',
		default   => $ensure
	}

	# Turns out the yumrepo target support is not yet implemented! Need to use independant files
	# until it is implemented (bug open since 2014, so fat chance of that anytime soon...)
	#$repo_target_file = "/etc/yum.repos.d/${file_name}.repo"
	$repo_target_file = "/etc/yum.repos.d/${name}.repo"

	if (! defined(File[$repo_target_file])) {
		file { $repo_target_file:
			ensure  => $file_ensure,
			replace => false,
			before  => Yumrepo[ $name ],
			mode    => '0644',
			owner   => 'root',
			group   => 0,
		}

		if ($gpgkey_source) {
			if ($gpgkey_source =~ Array) {
				$gpgkey_source.each |Stdlib::Filesource $g_k_s| {
					if ($gpgkey_name) {
						fail("Error managing yum repo '${name}' - can not specify a gpgkey_name parameter when more than one GPG file is managed")
					}
					$gpgkey_real_name = url_parse($g_k_s,'filename')

					if ! defined(File["/etc/pki/rpm-gpg/${gpgkey_real_name}"]) {
						file { "/etc/pki/rpm-gpg/${gpgkey_real_name}":
							ensure  => $file_ensure,
							replace => false,
							before  => Yumrepo[ $name ],
							source  => $g_k_s,
							mode    => '0644',
							owner   => 'root',
							group   => 0,
						}
					}
				}
			} else {
				$gpgkey_real_name = $gpgkey_name ? {
					undef   => url_parse($gpgkey_source,'filename'),
					default => $gpgkey_name,
				}

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
	}

	$use_gpgkey = $gpgkey ? {
		Array   => join($gpgkey, ' '),
		default => $gpgkey
	}

        # RHEL 8 has incorporated the yum priorities plugin's functionality into DNF
	if ($yum::priorities_plugin or $::lsbdistcodename == 'Ootpa') {
		$use_priority = $priority
		$use_failover = $failovermethod
	} else {
		if ($failovermethod == 'priority') {
			warning("It' useless setting the 'failovermethod' to 'priority' when the yum priorities plugin is disable. Setting to 'absent' for repo: ${name}")
			$use_failover = 'absent'
		} else {
			$use_failover = $failovermethod
		}
		$use_priority = undef
	}

	if ($repo_gpgcheck =~ Yum::Boolean::True) {
		package { 'pygpgme':
			ensure => 'installed'
		}
	}

	if (! defined(Yumrepo[$name])) {
		yumrepo { $name:
			ensure          => $ensure,
			descr           => $descr,
			baseurl         => $baseurl,
			mirrorlist      => $mirrorlist,
			metalink        => $metalink,
			enabled         => $enabled,
			gpgcheck        => $gpgcheck,
			gpgkey          => $use_gpgkey,
			failovermethod  => $use_failover,
			priority        => $use_priority,
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

		if ($ensure == 'present' and $autokeyimport == 'yes' and $gpgkey != 'absent') {
			if (! defined(Exec["rpmkey_add_${use_gpgkey}"])) {
				exec { "rpmkey_add_${use_gpgkey}":
					command     => "rpm --import ${use_gpgkey}",
					before      => Yumrepo[ $name ],
					refreshonly => true,
					path        => '/sbin:/bin:/usr/sbin:/usr/bin',
				}
			}
		}
	}
}
