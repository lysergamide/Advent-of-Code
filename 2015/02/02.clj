(require '[clojure.string :refer (split split-lines)])

(defn combs [all n]
  (let [[x & xs] all
        size (count all)]
    (cond (< size n) []
          (= n 1) (map vector all)
          :else (concat (map #(concat [x] %) (combs xs (dec n)))
                        (combs xs n)))))

(def boxes
  (map (fn [line] (map #(Integer. %) (split line #"x")))
       (-> "input/02.txt" slurp split-lines)))

(def surfaces (map #(combs % 2) boxes))

(defn paper-used [surfs]
  (let [areas (map #(reduce * %) surfs)]
    (+ (* 2 (reduce + areas))
       (apply min areas))))

(defn ribbon-needed [box]
  (let [perim (->> box sort (take 2) (reduce +))]
    (+ (* 2 perim)
       (reduce * box))))

(def silver (reduce + (map paper-used surfaces)))
(def gold (reduce + (map ribbon-needed boxes)))

(println "Day 02\n======")
(run! println [silver gold])
