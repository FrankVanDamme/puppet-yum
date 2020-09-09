# = Class yum::prerequisites
#
class yum::prerequisites {

  require yum

  # RHEL 8 has incorporated the yum priorities plugin's functionality into DNF
  if ( $yum::bool_priorities_plugin == true and $::lsbdistcodename != 'Ootpa' ){
    yum::plugin { 'priorities': }
  }
#  yum::plugin { 'security': }

  if $yum::bool_install_all_keys == true {
    file { 'rpm_gpg':
      path    => '/etc/pki/rpm-gpg/',
      source  => "puppet:///modules/yum/${::operatingsystem}.${yum::osver[0]}/rpm-gpg/",
      recurse => true,
      ignore  => '.svn',
      mode    => '0644',
      owner   => root,
      group   => 0,
    }
  }
}
