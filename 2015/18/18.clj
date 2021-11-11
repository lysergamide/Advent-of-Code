(require
  '[clojure.string :refer (split-lines split trim)]
  '[clojure.set :refer (union)])

(def size 100)
(def corners (into #{} (for [i [0 99] j [0 99]] (list i j))))
(def input (->> "18.txt" slurp split-lines))

(def starting-map
  (into #{} (for [[i row] (map-indexed vector input)
                  [j c] (map-indexed vector row)
                  :when (= c \#)]
              (list i j))))

(def neighbor-coords
  (for [i (range 8)]
    (let [theta (* (/ Math/PI 4) i)]
      (map #(Math/round %)
           [(Math/sin theta) (Math/cos theta)]))))

(defn add-vec [u v]
  (map (comp (partial reduce +) vector) u v))

(defn inside [u]
  (every? (fn [x] (and (>= x 0) (< x size))) u))

(defn neighbors [u]
  (->> neighbor-coords
       (map (partial add-vec u))
       (filter inside)))

(defn get-count [alive]
  (->> alive
       (mapcat neighbors)
       frequencies
       (into {})))

(defn next-world [world]
  (let [counts (get-count world)]
    (into #{} (for [[k v] counts
                    :when (or (= 3 v) (and (= 2 v) (world k)))]
                k))))

(defn next-stuck [world]
  (union corners (next-world world)))

(defn hundreth [func init]
  (count (nth (iterate func init) 100)))

(def silver (hundreth next-world starting-map))
(def gold (hundreth next-stuck (union corners starting-map)))

(println "Day 18\n======")
(println (str "✮: " silver))
(println (str "★: " gold))
