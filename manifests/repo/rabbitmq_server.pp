# = Class: yum::repo::rabbitmq_server
#
# This class installs the RabbitMQ Server repo
#
class yum::repo::rabbitmq_server {
	$gpg_key_filename = 'RPM-GPG-KEY-rabbitmq'
	$gpg_key_file     = "/etc/pki/rpm-gpg/${gpg_key_filename}"
	exec { 'remove_old_gpg_key':
		command => "rm -f ${gpg_key_file}",
		onlyif  => "test \"$(sha1sum < ${gpg_key_file})\" = \"8f6e2a1aacca3cbc5a900fce1119ae4310f0c8c1  -\"",
		before  => Yum::Managed_yumrepo[ 'rabbitmq_rabbitmq-server', 'rabbitmq_rabbitmq-server-source' ]
	}
	yum::managed_yumrepo { 'rabbitmq_rabbitmq-server':
		descr           => 'rabbitmq_rabbitmq-server',
		baseurl         => 'https://packagecloud.io/rabbitmq/rabbitmq-server/el/$releasever/$basearch',
		enabled         => 1,
		failovermethod  => 'priority',
		priority        => 1,
		gpgcheck        => 0,
		repo_gpgcheck   => 1,
		gpgkey          => "file://${gpg_key_file}",
		gpgkey_source   => "puppet:///modules/yum/rpm-gpg/${gpg_key_filename}",
		metadata_expire => 300,
		sslverify       => 1,
		sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt'
	}
	yum::managed_yumrepo { 'rabbitmq_rabbitmq-server-source':
		descr           => 'rabbitmq_rabbitmq-server-source',
		baseurl         => 'https://packagecloud.io/rabbitmq/rabbitmq-server/el/$releasever/SRPMS',
		enabled         => 1,
		failovermethod  => 'priority',
		priority        => 1,
		gpgcheck        => 0,
		repo_gpgcheck   => 1,
		gpgkey          => "file://${gpg_key_file}",
		gpgkey_source   => "puppet:///modules/yum/rpm-gpg/${gpg_key_filename}",
		metadata_expire => 300,
		sslverify       => 1,
		sslcacert       => '/etc/pki/tls/certs/ca-bundle.crt'
	}
}
