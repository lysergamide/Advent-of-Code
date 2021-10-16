(require '[clojure.string :refer (split trim)])
(def I (map {"(" 1 ")" -1}
            (-> "./input/01.txt" slurp trim (split #""))))
(def path (vec (reductions + I)))

(println "Day 01\n======")
(println (peek path))
(println (+ 1 (.indexOf path -1)))
