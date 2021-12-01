(require '[clojure.string :as str])

(def nums (->> "input"
               slurp
               str/trim
               str/split-lines
               (map #(Integer/parseInt %))))

(defn window [n nums]
  (loop [xs nums ret '()]
    (if (empty? xs)
      (reverse ret)
      (recur (rest xs) (cons (take n xs) ret)))))

(defn silver [nums]
  (->> (map vector nums (drop 1 nums))
       (filter (partial apply <))
       count))

(def gold
  (->> nums
       (window 3)
       (map #(reduce + %))
       silver))

(println (silver nums) gold)