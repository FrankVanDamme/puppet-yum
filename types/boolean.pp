type Yum::Boolean = Variant[
	Pattern[/\A(true|false|no|yes)\z/],
	Integer[0,1]
]
