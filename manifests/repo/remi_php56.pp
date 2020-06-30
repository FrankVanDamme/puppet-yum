# = Class: yum::repo::remi_php56
#
# This class installs the remi-php56 repo
#
class yum::repo::remi_php56 (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::remi_php_repo { '5.6':
		mirror_url => $mirror_url
	}
}
