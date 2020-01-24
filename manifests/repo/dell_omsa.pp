# = Class: yum::repo::dell_omsa
#
# This class installs the DELL OpenManage repo
#
class yum::repo::dell_omsa (
	Enum['present','absent'] $ensure = 'present'
) {
  yum::managed_yumrepo { 
		default:
			ensure         => $ensure,
			enabled        => 1,
			gpgcheck       => 1,
			failovermethod => 'priority',
			gpgkey         => [ 'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-dell',
													'http://linux.dell.com/repo/hardware/latest/RPM-GPG-KEY-libsmbios' ];
		'dell-omsa-indep':
			descr      => 'Dell OMSA repository - Hardware independent',
			mirrorlist => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&dellsysidpluginver=$dellsysidpluginver';
		'dell-omsa-specific':
			descr      => 'Dell OMSA repository - Hardware specific',
			mirrorlist => 'http://linux.dell.com/repo/hardware/latest/mirrors.cgi?osname=el$releasever&basearch=$basearch&native=1&sys_ven_id=$sys_ven_id&sys_dev_id=$sys_dev_id&dellsysidpluginver=$dellsysidpluginver';
  }
}
