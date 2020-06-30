type Yum::Boolean::False = Variant[
	Pattern[/\A(false|no)\z/],
	Integer[1,1]
]
