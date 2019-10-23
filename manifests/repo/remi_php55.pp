# = Class: yum::repo::remi_php55
#
# This class installs the remi-php55 repo
#
class yum::repo::remi_php55 (
	Optional[String] $mirror_url = undef
) {
	yum::repos::remi_php_repo { '5.5':
		mirror_url => $mirror_url
	}
}
