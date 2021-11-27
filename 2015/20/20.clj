(require '[clojure.string :refer (trim)])
(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(def input (->> "20.txt" slurp trim Integer/parseInt))

(defn silver [x]
  (let [size (quot x 10)
        nums (int-array (repeat size 0))]
    (loop [i 1 j 1]
      (cond
        (>= i size) (first (first (filter (fn [[_ v]] (< x v)) (map-indexed vector nums))))
        (>= j size) (recur (inc i) (inc i))
        :else (do (aset nums j (+ (aget nums j) (* 10 i)))
                  (recur i (+ j i)))))))


(println (silver input))