(require
  '[clojure.string :refer (split-lines)]
  '[clojure.math.combinatorics :refer (cartesian-product)])

;; hurray for stats

(def goal 150)
(def cartons(->> "17.txt" slurp split-lines (map #(Integer/parseInt %))))
(def carton-count (frequencies cartons))
(def carton-lists (mapv (fn [[_ v]] (range 0 (inc v))) carton-count))

(defn fact [x]
  (if (zero? x)
    1
    (reduce * (range 1 (inc x)))))

(defn choose [n k]
  (/ (fact n) (* (fact k) (fact (- n k)))))

(defn exact-liters? [comb]
  (->> (map vector comb (keys carton-count))
       (map (partial apply *))
       (reduce +)
       (= goal)))

;; brute force is fast enough
(def carton-combs
  (->> carton-lists
       (apply cartesian-product)
       (filter exact-liters?)))

(defn count-ways [comb]
  (->> (map vector (vals carton-count) comb)
       (map (partial apply choose))
       (reduce *)))

(def silver
  (->> carton-combs
       (map count-ways)
       (reduce +)))

(defn count-countainers [comb]
  (reduce + comb))

(def min-countainers
  (apply min (map count-countainers carton-combs)))

(def gold
  (->> carton-combs
       (filter #(= min-countainers (count-countainers %)))
       (map count-ways)
       (reduce +)))

(println "Day 17\n======")
(println (str "✮: " silver))
(println (str "★: " gold))
