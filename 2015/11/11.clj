(require
  '[clojure.string :refer (split-lines split trim join)])

(set! *unchecked-math* true)

(defn to-num [c] (- (int c) (int \a)))
(defn to-char [n] (char (+ n (int \a))))
(defn to-s [xs] (->> xs (map to-char) join))

(def alpha 26)
(def I (->> "11.txt" slurp trim (mapv to-num)))
(def bad (into #{} (map to-num [\i \o \l])))

(defn increasing-straight? [pass]
  (loop [n 0 [x & xs] pass]
    (cond (= n 2) true
          (empty? xs) false
          :else (recur (if (= 1 (- (first xs) x)) (inc n) 0)
                       xs))))
(defn pairs? [pass]
  (loop [n 0 [x & xs] pass]
    (cond (= 2 n) true
          (empty? xs) false
          (= x (first xs)) (recur (inc n) (drop 1 xs))
          :else (recur n xs))))

(defn good-pass? [pass]
  (and (pairs? pass)
       (increasing-straight? pass)))

(defn next-pass [pass]
  (loop [ret pass remain 1 idx (dec (count pass))]
    (if (or (zero? remain) (neg? idx))
      ret
      (let [letter (rem (inc (get ret idx)) alpha)
            remainder (if (zero? letter) 1 0)
            next-pass (assoc ret idx (if (bad letter) (inc letter) letter))]
        (recur next-pass remainder (dec idx))))))

(defn find-good [pass]
  (if (good-pass? pass)
    pass
    (recur (next-pass pass))))

(def silver (find-good I))
(def gold (find-good (next-pass silver)))

(println "Day 11\n======")
(println (str "✮: " (to-s silver)))
(println (str "★: " (to-s gold)))
