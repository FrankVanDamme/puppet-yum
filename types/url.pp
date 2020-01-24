# For either filesystem or web based URLs that are used/accepted by YUM
type Yum::Url = Variant[
	Yum::Url::Web,
	Yum::Url::File
]
