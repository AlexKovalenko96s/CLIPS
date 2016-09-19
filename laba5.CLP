(defmodule MAIN 
  (export deftemplate status)
  (export defglobal initial-missionaries)
  (export defglobal initial-cannibals))

(deftemplate MAIN::status 
   (slot shore-1-miss (type INTEGER) (range 0 ?VARIABLE))
   (slot shore-1-cann (type INTEGER) (range 0 ?VARIABLE))
   (slot shore-2-miss (type INTEGER) (range 0 ?VARIABLE))
   (slot shore-2-cann (type INTEGER) (range 0 ?VARIABLE))
   (slot boat-location (type SYMBOL) (allowed-values shore-1 shore-2))
   (slot search-depth (type INTEGER) (range 1 ?VARIABLE)) 
   (slot parent (type FACT-ADDRESS SYMBOL) (allowed-symbols no-parent)) 
   (slot last-move (type STRING)))

(defglobal MAIN ?*initial-missionaries* = 3
   ?*initial-cannibals* = 3)

(deffacts MAIN::initial-positions
	(status (shore-1-miss ?*initial-missionaries*)
	(shore-1-cann ?*initial-cannibals*)
	(shore-2-miss 0)
	(shore-2-cann 0)
	(boat-location shore-1)
	(search-depth 1)
	(parent no-parent)
	(last-move "No move.")))

(deffacts MAIN::boat-information 
   (boat-can-hold 2))

(deffunction MAIN::move-string (?miss ?cann ?shore)
  (switch ?miss
    (case 0 then								
       (if (eq ?cann 1) 		
          then (format nil "Move 1 cannibal to %s.%n" ?shore) 	
          else (format nil "Move %d cannibals to %s.%n" ?cann ?shore))) 	
    (case 1 then								
       (switch ?cann		
         (case 0 then			
            (format nil "Move 1 missionary to %s.%n" ?shore))	
         (case 1 then
            (format nil "Move 1 missionary and 1 cannibal to %s.%n" ?shore))
         (default then
            (format nil "Move 1 missionary and %d cannibals to %s.%n" 	
                              ?cann ?shore))))
    (default									
      (switch ?cann
         (case 0 then
            (format nil "Move %d missionaries to %s.%n" ?miss ?shore))	
         (case 1 then
            (format nil "Move %d missionaries and 1 cannibal to %s.%n" 
                               ?miss ?shore))
         (default then								
            (format nil "Move %d missionary and %d cannibals to %s.%n" 
                               ?miss ?cann ?shore)))))) 


(defrule MAIN::shore-1-move 
  ?node <- (status (search-depth ?num) 
                   (boat-location shore-1)
                   (shore-1-miss ?s1m)
                   (shore-1-cann ?s1c)
                   (shore-2-miss ?s2m)
                   (shore-2-cann ?s2c))
  (boat-can-hold ?limit)
  =>
  (bind ?max-miss (min ?s1m ?limit))
  (loop-for-count (?miss 0 ?max-miss)
    (bind ?min-cann (max 0 (- 1 ?miss)))
    (bind ?max-cann (min ?s1c (- ?limit ?miss)))
    (loop-for-count (?cann ?min-cann ?max-cann)
      (duplicate ?node (search-depth =(+ 1 ?num))
                       (parent ?node)
                       (shore-1-miss (- ?s1m ?miss))
                       (shore-1-cann (- ?s1c ?cann))
                       (shore-2-miss (+ ?s2m ?miss))
                       (shore-2-cann (+ ?s2c ?cann))
                       (boat-location shore-2)
                       (last-move (move-string ?miss ?cann shore-2))))))

(defrule MAIN::shore-2-move 
  ?node <- (status (search-depth ?num) 
                   (boat-location shore-2)
                   (shore-1-miss ?s1m)
                   (shore-1-cann ?s1c)
                   (shore-2-miss ?s2m)
                   (shore-2-cann ?s2c))
  (boat-can-hold ?limit)
  =>
  (bind ?max-miss (min ?s2m ?limit))
  (loop-for-count (?miss 0 ?max-miss)
    (bind ?min-cann (max 0 (- 1 ?miss)))
    (bind ?max-cann (min ?s2c (- ?limit ?miss)))
    (loop-for-count (?cann ?min-cann ?max-cann)
      (duplicate ?node (search-depth =(+ 1 ?num))
                       (parent ?node)
                       (shore-1-miss (+ ?s1m ?miss))
                       (shore-1-cann (+ ?s1c ?cann))
                       (shore-2-miss (- ?s2m ?miss))
                       (shore-2-cann (- ?s2c ?cann))
                       (boat-location shore-1)
                       (last-move (move-string ?miss ?cann shore-1))))))







(defmodule CONSTRAINTS 
  (import MAIN deftemplate status))

(defrule CONSTRAINTS::cann-eat-miss 
  (declare (auto-focus TRUE))
  ?node <- (status (shore-1-miss ?s1m)
                   (shore-1-cann ?s1c)
                   (shore-2-miss ?s2m)
                   (shore-2-cann ?s2c))
  (test (or (and (> ?s2c ?s2m) (<> ?s2m 0))
            (and (> ?s1c ?s1m) (<> ?s1m 0))))
  =>
  (retract ?node))

(defrule CONSTRAINTS::circular-path 
  (declare (auto-focus TRUE))
  (status (search-depth ?sd1)
          (boat-location ?bl) 
          (shore-1-miss ?s1m)
          (shore-1-cann ?s1c)
          (shore-2-miss ?s2m)
          (shore-2-cann ?s2c))
  ?node <- (status (search-depth ?sd2&:(< ?sd1 ?sd2))
                   (boat-location ?bl) 
                   (shore-1-miss ?s1m)
                   (shore-1-cann ?s1c)
                   (shore-2-miss ?s2m)
                   (shore-2-cann ?s2c))
  =>
  (retract ?node))












(defmodule SOLUTION 
  (import MAIN deftemplate status)
  (import MAIN defglobal initial-missionaries initial-cannibals))
       
(deftemplate SOLUTION::moves 
   (slot id (type FACT-ADDRESS SYMBOL) (allowed-symbols no-parent)) 
   (multislot moves-list  
      (type STRING)))

(defrule SOLUTION::goal-test 
  (declare (auto-focus TRUE))
  ?node <- (status (parent ?parent)
                   (shore-2-miss ?m&:(= ?m ?*initial-missionaries*))
                   (shore-2-cann ?c&:(= ?c ?*initial-cannibals*))
                   (last-move ?move))
  =>
  (retract ?node)
  (assert (moves (id ?parent) (moves-list ?move))))

(defrule SOLUTION::build-solution
  ?node <- (status (parent ?parent)
                   (last-move ?move))
  ?mv <- (moves (id ?node) (moves-list $?rest))
  =>
  (modify ?mv (id ?parent) (moves-list ?move ?rest)))

(defrule SOLUTION::print-solution 
  ?mv <- (moves (id no-parent) (moves-list "No move." $?m))
  =>
  (retract ?mv)
  (printout t t  "Solution found: " t t)
  (progn$ (?move ?m) (printout t ?move)))