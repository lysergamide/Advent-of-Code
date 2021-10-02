(require
  '[clojure.string :refer (split-lines split)]
  '[clojure.set :refer (union)]
  '[clojure.math.combinatorics :refer (permutations)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)


(def lines (-> "09.txt" slurp split-lines))

(defn parse-line [line]
  (let [[start stop dist] (rest (re-matches #"(\w+) to (\w+) = (\d+)" line))]
    [#{start stop} (Integer/parseInt dist)]))

(defn minmax [xs]
  (let [head (first xs)
        tail (rest xs)
        helper (fn [[amin amax] b] [(min amin b) (max amax b)])]
    (reduce helper [head head] tail)))

(def graph
  (->> lines
       (mapcat parse-line)
       vec
       (apply hash-map)))

(defn route-score [route]
  (->> (map vector route (drop 1 route))
       (map #(graph (into #{} %)))
       (reduce +)))

(def locations
  (->> graph
       keys
       (apply union)
       vec))

(def solution
  (->> locations
       permutations
       (map route-score)
       minmax))



(println "Day 09\n======")
(println (str "✮: " (first solution)))
(println (str "★: " (second solution)))
