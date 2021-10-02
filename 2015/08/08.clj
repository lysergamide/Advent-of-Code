(require
  '[clojure.string :as string :refer (split-lines split)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(defn map-sum [xs tfn]
  (->> xs (map tfn) (reduce +)))

(defn count-parsed [line]
  (-> line
      (string/replace #"(\\\\|\\\"|\\x.{2})" " ")
      count
      (- 2)))

(defn count-escaped [line]
  (->> line
       (re-seq #"(\\|\")")
       count
       (+ 2 (count line))))

(def lines (-> "08.txt" slurp split-lines))
(def total (map-sum lines count))

(def silver
  (let [parsed (map-sum lines count-parsed)]
    (- total parsed)))

(def gold
  (let [escaped (map-sum lines count-escaped)]
    (- escaped total)))

(println "Day 08\n======")
(println (str "✮: " silver))
(println (str "★: " gold))
