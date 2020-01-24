# For the web URLs that are used/accepted by YUM
type Yum::Url::Web = Pattern[/(?ix:^(http|https|ftp):\/\/\S+$)/]
