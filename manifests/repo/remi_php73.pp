# = Class: yum::repo::remi_php73
#
# This class installs the remi-php73 repo
#
class yum::repo::remi_php73 (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::remi_php_repo { '7.3':
		mirror_url => $mirror_url
	}
}
