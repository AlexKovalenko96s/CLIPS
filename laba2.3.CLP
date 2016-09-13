(deftemplate student
(slot name)
(slot age)
(slot year)
(slot spec)
(slot aver_mark))

(deffacts students
(student (name Petrov) (age  17) (year  2)  (spec "hard") (aver_mark 3))
(student (name NePetrov) (age  18) (year  3)  (spec "soft") (aver_mark 4))
(student (name Ivanov) (age  19) (year  4)  (spec "ai") (aver_mark 5))
(student (name NeIvatov) (age  20) (year  5)  (spec "hard") (aver_mark 3.5))
(student (name TojeIvanov) (age  21) (year  2)  (spec "soft") (aver_mark 4.5))
(student (name PochtiIvaniv) (age 22) (year 3) (spec "ai") (aver_mark 5))
(student (name NeDoKoncaIvanov) (age 17) (year 4) (spec "hard") (aver_mark 3))
(student (name Sidorov) (age 18) (year 5) (spec "soft") (aver_mark 4))
(student (name EtozeSidorov) (age 19) (year 2) (spec "ai") (aver_mark 5))
(student (name NeSidorov) (age 20) (year 3) (spec "hard") (aver_mark 3.5))
(student (name Sidorivich) (age 21) (year 4) (spec "soft") (aver_mark 4.5))
(student (name Sidorenko) (age 22) (year 5) (spec "ai") (aver_mark 5))
(student (name Sidorushechka) (age 17) (year 2) (spec "hard") (aver_mark 3))
(student (name Sidr) (age 18) (year 3) (spec "soft") (aver_mark 4))
(student (name Pivo) (age 19) (year 4) (spec "ai") (aver_mark 5))
(student (name Kolsch) (age 20) (year 5) (spec "hard") (aver_mark 3.5))
(student (name Sbiten) (age 21) (year 2) (spec "soft") (aver_mark 4.5))
(student (name Medovuha) (age 22) (year 3) (spec "ai") (aver_mark 5))
)


(defrule R23
(student (name ?name) (age ?age&:(numberp ?age)) (year  ?year&:(numberp ?year)) (spec ?spec) (aver_mark ?aver_mark&:(floatp ?aver_mark)))
(test (and(= ?year 2)(>= ?aver_mark 4.5)))
=>
(printout t crlf "student " ?name "  srednii bal = " ?aver_mark  crlf ))