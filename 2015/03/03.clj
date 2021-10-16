(require '[clojure.string :refer (trim)])
(require '[clojure.set :refer (union)])

(def dir {\^ [1, 0]
          \v [-1, 0]
          \> [0, 1]
          \< [0, -1]})
(def steps (->> "03.txt" slurp trim (map dir)))

(defn solve [lst] (set (reductions #(map + %1 %2) lst)))

(def silver (count (solve steps)))
(def gold (count (apply union (map #(solve (take-nth 2 %))
                                   [steps (rest steps)]))))

(println "Day 03\n======")
(run! println [silver gold])
