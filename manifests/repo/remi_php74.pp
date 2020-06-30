# = Class: yum::repo::remi_php74
#
# This class installs the remi-php74 repo
#
class yum::repo::remi_php74 (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::remi_php_repo { '7.4':
		mirror_url => $mirror_url
	}
}
