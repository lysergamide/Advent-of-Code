(require '[clojure.string :refer (split trim)])

(def I (map {"(" 1 ")" -1}
            (split (trim (slurp "./input/01.txt"))
                   #"")))
(def path (vec (reductions + I)))
(println (peek path))
(println (+ 1 (.indexOf path -1)))