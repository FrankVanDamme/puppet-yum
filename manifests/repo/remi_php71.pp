# = Class: yum::repo::remi_php71
#
# This class installs the remi-php71 repo
#
class yum::repo::remi_php71 (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::remi_php_repo { '7.1':
		mirror_url => $mirror_url
	}
}
