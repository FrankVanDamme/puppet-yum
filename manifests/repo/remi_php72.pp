# = Class: yum::repo::remi_php72
#
# This class installs the remi-php72 repo
#
class yum::repo::remi_php72 (
	Optional[String] $mirror_url = undef
) {
	yum::repos::remi_php_repo { '7.2':
		mirror_url => $mirror_url
	}
}
