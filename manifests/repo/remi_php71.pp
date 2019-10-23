# = Class: yum::repo::remi_php71
#
# This class installs the remi-php71 repo
#
class yum::repo::remi_php71 (
	Optional[String] $mirror_url = undef
) {
	yum::repos::remi_php_repo { '7.1':
		mirror_url => $mirror_url
	}
}
