# = Class: yum::repo::tideways
#
# This class installs the tideways repo
#
class yum::repo::tideways {
	$repo_name = 'tideways'
	yum::managed_yumrepo { $repo_name:
		descr         => 'Tideways RPM repository for Redhat/Fedora/CentOS',
		baseurl       => 'https://s3-eu-west-1.amazonaws.com/tideways/rpm',
		enabled       => 1,
		gpgcheck      => 1,
		gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-tideways',
		gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-tideways',
		priority      => 1,
		notify        => Exec[ "yum_clean_${repo_name}_cache" ]
	}

	exec { "yum_clean_${repo_name}_cache":
		command     => "yum clean all --disablerepo='*' --enablerepo='${repo_name}'",
		refreshonly => true
	}
}
