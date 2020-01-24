# For the filesystem based URLs that are used/accepted by YUM
type Yum::Url::File = Pattern[/^file:\/\/\/([^\/\0]+\/*)*$/]
