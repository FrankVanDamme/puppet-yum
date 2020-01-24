# = Class: yum::repo::dell_system_update
#
# This class installs the DELL System Update repo
#
class yum::repo::dell_system_update (
	Enum['present','absent'] $ensure = 'present'
) {
	yum::managed_yumrepo {
		default:
			autokeyimport  => 'yes',
			ensure         => $ensure,
			enabled        => 1,
			file_name      => 'dell-system-update',
			gpgcheck       => 1,
			gpgkey         => [
				'https://linux.dell.com/repo/pgp_pubkeys/0x756ba70b1019ced6.asc',
				'https://linux.dell.com/repo/pgp_pubkeys/0x1285491434D8786F.asc',
				'https://linux.dell.com/repo/pgp_pubkeys/0xca77951d23b66a9d.asc'
			];
		'dell-system-update_independent':
			exclude => 'dell-system-update*.i386',
			baseurl => 'https://linux.dell.com/repo/hardware/dsu/os_independent/';
		'dell-system-update_dependent':
			mirrorlist => 'https://linux.dell.com/repo/hardware/dsu/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1';
  }

}
