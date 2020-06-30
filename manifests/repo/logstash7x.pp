# = Class: yum::repo::logstash7x
#
# This class installs the logstash7x repo
#
class yum::repo::logstash7x (
	Optional[Stdlib::HTTPUrl] $mirror_url = undef
) {
	yum::repo::logstash_repo { '7':
		mirror_url => $mirror_url
	}
}
