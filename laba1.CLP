(deffacts startup "opasnayadevochkat"(days min)(works no)(temp yes)(rain no))

(defrule FREETIME1(days no)(works no)
=>
(assert (ft "no")))

(defrule FREETIME2(days no)(works min)
=>
(assert (ft "no")))

(defrule FREETIME3(days no)(works max)
=>
(assert (ft "no")))

(defrule FREETIME4(days min)(works no)
=>
(assert (ft "min")))

(defrule FREETIME5(days min)(works min)
=>
(assert (ft "no")))

(defrule FREETIME6(days min)(works max)
=>
(assert (ft "no")))

(defrule FREETIME7(days max)(works no)
=>
(assert (ft "max")))

(defrule FREETIME8(days max)(works min)
=>
(assert (ft "min")))

(defrule FREETIME9(days max)(works max)
=>
(assert (ft "no")))





(defrule WEATHER1(temp no)(rain no)
=>
(assert (w "yes")))

(defrule WEATHER2(temp no)(rain yes)
=>
(assert (w "no")))

(defrule WEATHER3(temp yes)(rain no)
=>
(assert (w "yes")))

(defrule WEATHER4(temp yes)(rain yes)
=>
(assert (w "no")))




(defrule ACT1(ft "no")(w "no")
=>
(printout t crlf "Sit at home" crlf)
(assert (action "no")))

(defrule ACT2(ft "no")(w "yes")
=>
(printout t crlf "Sit at home" crlf)
(assert (action "no")))

(defrule ACT3(ft "min")(w "no")
=>
(printout t crlf "Sit at home" crlf)
(assert (action "no")))

(defrule ACT4(ft "min")(w "yes")
=>
(printout t crlf "Not long" crlf)
(assert (action "no")))

(defrule ACT5(ft "max")(w "no")
=>
(printout t crlf "Not long" crlf)
(assert (action "no")))

(defrule ACT6(ft "max")(w "yes")
=>
(printout t crlf "Have a good time" crlf)
(assert (action "yes")))