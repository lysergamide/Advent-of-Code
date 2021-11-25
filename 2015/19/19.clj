(require
  '[clojure.string :as str :refer (split-lines split trim starts-with?)]
  '[clojure.set :refer (union)])

(def input (-> "19.txt" slurp trim (split #"\r?\n(\r?\n)+")))
(def target (last input))

(defn gather [pairs]
  (letfn [(clean [[x xs]]
            [x (sort-by count #(compare %2 %1) (map last xs))])]
    (->> pairs
         (group-by first)
         (map clean))))

(def grammar
  (->> (first input)
       split-lines
       (map #(split % #" => "))
       gather
       (into {})))

(defn silver [medicine]
  (loop [head "" tail medicine ret #{}]
    (if (empty? tail)
      (count ret)
      (let [next-head (str head (first tail))
            next-tail (subs tail 1)
            substrs (apply union
                           (for [[k v] grammar :when (starts-with? tail k)]
                             (let [re (re-pattern (str \^ k))
                                   swap (fn [x] (str head (str/replace tail re x)))]
                               (into #{} (map swap v)))))]
        (recur next-head next-tail (union ret substrs))))))

(println (silver target))
;; (println (greedy-search "e"))
