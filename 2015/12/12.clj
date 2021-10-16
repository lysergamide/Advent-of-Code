(require
  '[clojure.data.json :as json])

(def input (->> "12.txt" slurp ))
(def input-json (json/read-str input))

(defn is-red? [h]
  (let [con (partial some (partial = "red"))]
    (or (con (vals h)) (con (keys h)))))

(defn sum [xs]
  (cond (int? xs) xs
        (string? xs) 0
        (map? xs) (if (is-red? xs)
                    0
                    (+ (sum (keys xs)) (sum (vals xs))))
        :else (reduce + (map sum xs))))

(def silver
  (->> input
       (re-seq #"-?\d+")
       (map #(Integer/parseInt %))
       (reduce +)))

(def gold (sum input-json))

(println "Day 12\n======")
(println (str "✮: " silver))
(println (str "★: " gold))

