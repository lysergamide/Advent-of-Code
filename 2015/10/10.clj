(require
  '[clojure.string :refer (split-lines split trim)])

(defn part [numbers]
  (loop [xs numbers ret '()]
    (if (empty? xs)
      (reverse ret)
      (let [head (first xs)
            group (take-while #(= head %) xs)
            leftover (drop-while #(= head %) xs)]
        (recur leftover (cons group ret))))))

(defn look-and-say [xs]
  (->> xs
       part
       (map #(list (count %) (first %)))
       flatten))

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
