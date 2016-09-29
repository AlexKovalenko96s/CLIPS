(deftemplate block 
	(slot size (type INTEGER))
	(slot place (type SYMBOL))
	(slot color (type SYMBOL)))

(deftemplate on 
	(slot upper (type SYMBOL))
	(slot lower (type SYMBOL))
	(slot place (type SYMBOL)))

(deftemplate goal 
	(slot current-task (type SYMBOL)))

(deffacts the-facts
	(block (color blue) (size 10) (place heap))
	(block (color green) (size 8) (place heap))
	(block (color red) (size 18) (place heap))
	(block (color yellow) (size 15) (place heap)))




(defrule begin
	(initial-fact) 
=>
(assert (goal (current-task find))))

(defrule onHand
	?step <- (goal (current-task find))
	?selectBlock <- (block (size ?size1) (place heap))
	(not (block (color ?color2) (size ?size2&:(> ?size2 ?size1)) (place heap)))
=>
	(modify ?selectBlock (place hand))
	(modify ?step (current-task build))
	(printout t "Mu vubrali samui bilshoi iz kyhi" crlf))

(defrule firstBlock
	?step <- (goal (current-task build))
	?selectBlock <- (block (place hand))
	(not (block (place tower)))
=>
	(modify ?selectBlock (place tower))
	(modify ?step (current-task find))
	(printout t "Ystanovili osnovanie bashni" crlf))

(defrule nextBlock
	?step <- (goal (current-task build))
	?selectBlock <- (block (color ?color0) (place hand))
	(block (color ?color1) (place tower))
	(not (on (upper ?color2) (lower ?color1) (place tower)))
=>
	(modify ?selectBlock (place tower))
	(assert (on (upper ?color0) (lower ?color1) (place tower)))
	(modify ?step (current-task find))
	(printout t "Ystanovili sledyushiy block" crlf))

(defrule finish
	?step <- (goal (current-task find))
	(not (block (place heap)))
=>
	(retract ?step)
	(printout t "Bashnya gotova" crlf))