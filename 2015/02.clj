(require '[clojure.string :refer (split trim)])
(require '[clojure.math.combinatorics :refer (combinations)])

(def boxes
  (map (#(map int (split % "x")))
       (split (trim (slurp "input/02.txt")) "\n")))

(def surfs (map (#(combinations % 2) boxes)))

(def paper
  (reduce + (map (fn [surf]
               (let [areas (map #(reduce * %) surf)]
                 (+ (* 2 (reduce + areas))
                    (min areas))))
             surfs)))