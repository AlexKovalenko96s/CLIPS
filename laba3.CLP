(deffacts startup "opasnayadevochkat"(a)(b)(c)(d)(e))

(defrule R1
(declare (salience 5000))
(a)(b)
=>
(assert (m)))

(defrule R2
(declare (salience 6000))
(a)(c)
=>
(assert (n)))

(defrule R3
(declare (salience 5000))
(b)(c)(d)
=>
(assert (p)))

(defrule R4
(declare (salience 6000))
(a)(d)(c)
=>
(assert (r)))

(defrule R5
(declare (salience 6000))
(m)(n)
=>
(assert (s)))

(defrule R6
(declare (salience 5000))
(n)(p)(r)
=>
(assert (t)))