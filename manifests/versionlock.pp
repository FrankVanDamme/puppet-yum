# = Define yum::versionlock
#
define yum::versionlock (
	Enum['present','absent'] $ensure = 'present',
	Optional[String] $package = undef
) {
	include ::yum::plugin::versionlock

	if ($package) {
		$use_package_name = $package
	} else {
		$use_package_name = $name
	}

	$locked_check = "yum -C versionlock list | grep -q ${use_package_name}"

	if ($ensure == 'present') {
		exec { "add-yum-lock-${name}":
			command => "yum -C versionlock add ${use_package_name}",
			unless  => $locked_check,
			require => Class['yum::plugin::versionlock'],
		}
	} else {
		exec { "remove-yum-lock-${name}":
			command => "yum -C versionlock delete ${use_package_name}",
			onlyif  => $locked_check,
			require => Class['yum::plugin::versionlock'],
		}
	}
}
