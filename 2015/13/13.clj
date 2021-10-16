(require
  '[clojure.string :refer (split-lines split trim)]
  '[clojure.set :refer (union)]
  '[clojure.math.combinatorics :refer (permutations)])

(def lines (-> "13.txt" slurp trim split-lines))

(defn parse-line [line]
  (let [reg #"^(\w+).*(gain|lose) (\d+).* (\w+)\.$"
        [p1 gain n p2] (rest (re-matches reg line))]
    [[p1 p2] (* ({"gain" 1 "lose" -1} gain) (Integer. n))]))

(def score
  (apply hash-map (mapcat parse-line lines)))

(def guests
  (->> score
       keys
       (map (into set))
       (reduce union)
       (vec)))

(def layouts (permutations guests))

(def party-score
  (loop [sc (transient score) [x & xs] guests]
    (if (nil? x)
      (persistent! sc)
      (do
        (assoc! sc [x "me"] 0)
        (assoc! sc ["me" x] 0)
        (recur sc xs)))))

(def party (conj guests "me"))

(def party-layouts (permutations party))

(defn score-layout [layout, score]
  (let [table (concat [(last layout)] layout)]
    (loop [ret 0 [a b :as all] table]
      (if (nil? b)
        ret
        (recur (+ ret (score [a b]) (score [b a]))
               (rest all))))))

(def silver
  (apply max (map #(score-layout % score) layouts)))
(def gold
  (apply max (map #(score-layout % party-score) party-layouts)))

(println "Day 13\n======")
(println (str "✮: " silver))
(println (str "★: " gold))

