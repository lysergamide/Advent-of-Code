(require
  '[clojure.string :refer (split-lines split)]
  '[clojure.core.matrix :as mat])

;; matrix library shit
(mat/set-current-implementation :vectorz)

(def cookies
  (let [lines (-> "15.txt" slurp split-lines)]
    (for [l lines
          :let [xs (re-seq #"-?\d+" l)]]
      (mapv #(Integer/parseInt %) xs))))

(def depth-limit (count cookies))

(def score-matrix
  (-> (map (partial take 4) cookies)
      mat/array
      mat/transpose))

(def calories
  (-> (map last cookies) mat/array)); mat/transpose))

(defn silver [perm]
  (->> (mat/mmul score-matrix perm)
       (mat/emap #(if (neg? %) 0 %))
       (mat/ereduce *)))

(defn gold [perm]
  (if (mat/equals 500 (mat/mmul calories perm))
    (silver perm)
    0))

(defn brute-force
  ([scorefn] (brute-force scorefn [] 100 1))
  ([scorefn perm remainder depth]
   (if (= depth depth-limit)
     (scorefn (mat/array (conj perm remainder)))
     (apply max
            (for [i (range (inc remainder))]
              (brute-force scorefn
                           (conj perm i)
                           (- remainder i)
                           (inc depth)))))))
(println "Day 15\n======")
(println (str "✮: " (format "%.0f" (brute-force silver))))
(println (str "★: " (format "%.0f" (brute-force gold))))
