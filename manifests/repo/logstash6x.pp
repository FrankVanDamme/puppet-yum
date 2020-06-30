# = Class: yum::repo::logstash6x
#
# This class installs the logstash6x repo
#
class yum::repo::logstash6x (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::logstash_repo { '6':
		mirror_url => $mirror_url
	}
}
