class yum::disable_fastest {
	ini_setting { 'disable_fastestmirror_yum_plugin':
		ensure  => 'present',
		path    => '/etc/yum/pluginconf.d/fastestmirror.conf',
		section => 'main',
		setting => 'enabled',
		value   => '0',
		notify  => Exec[ 'yum_clean_all_caches' ]
	}

	exec { 'yum_clean_all_caches':
		command     => 'yum clean all',
		refreshonly => true
	}
}
