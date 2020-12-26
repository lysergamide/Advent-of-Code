(use '[clojure.string :only (split trim)])

(def I (map {"(" 1")" -1}
            (split
              (trim(slurp "./input/01.txt"))
              #"")))

(println (reduce + I))

(println(first (first (filter (fn [x] (neg? (second x)))
                              (map list(iterate inc 1)
                                   (reductions + I))))))
