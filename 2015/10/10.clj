(require
  '[clojure.string :refer (split-lines split trim)])

(defn look-and-say [xs]
  (loop [lst xs ret []]
    (if (empty? lst)
      ret
      (let [head (first lst)
            [group tail] (split-with (partial = head) lst)]
        (recur tail (conj ret (count group) head))))))

(defn loop-and-say [xs n]
  (loop [i n ret xs]
    (if (zero? i)
      ret
      (recur (dec i) (look-and-say ret)))))

(def I (->> "10.txt" slurp trim seq (map #(Character/digit % 10))))

(def silver-seq (loop-and-say I 40))
(def silver (count silver-seq))
(def gold (count (loop-and-say silver-seq 10)))

(println "Day 10\n======")
(println (str "✮: " silver))
(println (str "★: " gold))
