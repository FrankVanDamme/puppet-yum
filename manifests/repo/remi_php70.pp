# = Class: yum::repo::remi_php70
#
# This class installs the remi-php70 repo
#
class yum::repo::remi_php70 (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::remi_php_repo { '7.0':
		mirror_url => $mirror_url
	}
}
