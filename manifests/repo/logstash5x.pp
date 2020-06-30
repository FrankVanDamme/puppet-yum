# = Class: yum::repo::logstash5x
#
# This class installs the logstash5x repo
#
class yum::repo::logstash5x (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::logstash_repo { '5':
		mirror_url => $mirror_url
	}
}
