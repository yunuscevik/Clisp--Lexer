(deffun sumup (x)
	(if (equal x 0)
		-1001
		(+ x (sumup (- x 1)))
	)
)
	
(sumup 8)