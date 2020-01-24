# = Class: yum::repo::pg_2ndq_bdr94
#
# This class installs the postgresql 9.4 repo from 2ndquadrant that includes the
# bi-directional replication patches.
#
class yum::repo::pg_2ndq_bdr94 {
  yum::managed_yumrepo { 'postgresql-bdr94-2ndquadrant':
    descr         => 'PostgreSQL 9.4 with BDR for RHEL $releasever - $basearch',
    baseurl       => 'http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/yum/redhat-$releasever-$basearch',
    enabled       => 1,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94'
  }
  yum::managed_yumrepo { 'postgresql-bdr94-2ndquadrant-source':
    descr          => 'PostgreSQL 9.4 with BDR for RHEL $releasever - source',
    baseurl        => 'http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/yum/redhat-$releasever',
    enabled        => 0,
    gpgcheck       => 1,
	failovermethod => 'priority',
    gpgkey         => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94',
    gpgkey_source  => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94'
  }
  yum::managed_yumrepo { 'postgresql-bdr94-2ndquadrant-testing':
    descr         => 'PostgreSQL 9.4 with BDR testing for RHEL $releasever - $basearch',
    baseurl       => 'http://packages.2ndquadrant.com/postgresql-bdr94-2ndquadrant/yum-testing/redhat-$releasever-$basearch',
    enabled       => 0,
    gpgcheck      => 1,
    gpgkey        => 'file:///etc/pki/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94',
    gpgkey_source => 'puppet:///modules/yum/rpm-gpg/RPM-GPG-KEY-2NDQ-BDR-94'
  }
}
