(require
 '[clojure.string :as str]
 '[clojure.set :refer (union)])

(def input (-> "19.txt" slurp str/trim (str/split #"\r?\n(\r?\n)+")))
(def medicine (str/trim (last input)))

(defn largest-order [xs]
  (sort-by count #(compare %2 %1) (map last xs)))

(defn gather [pairs]
  (letfn [(order [[x xs]] [x (largest-order xs)])]
    (->> pairs
         (group-by first)
         (map order))))

(def grammar
  (->> (first input)
       str/split-lines
       (map (comp #(str/split % #" => ") str/trim))
       gather
       (into {})))

(defn variants [head tail]
  (apply union
         (for [[k v] grammar :when (str/starts-with? tail k)]
           (let [re (re-pattern (str \^ k))
                 swap (fn [x] (str head (str/replace tail re x)))]
             (into #{} (map swap v))))))

(defn silver [medicine]
  (loop [head "" tail medicine ret #{}]
    (if (empty? tail)
      (count ret)
      (let [next-head (str head (first tail))
            next-tail (subs tail 1)
            substrs (variants head tail)]
        (recur next-head next-tail (union ret substrs))))))

(def transformations
  (->> grammar
       (mapcat (fn [[x xs]] (for [y xs] [y x])))
       (sort-by (comp count first) #(compare %2 %1))))

(defn possible-subs [current]
  (filter (fn [[x _]] (str/includes? current x)) transformations))

(declare greedy-search)
(defn gold [current i]
  (if (= current "e") i
      (let [subs (possible-subs current)]
        (if (empty? subs) nil
            (greedy-search current subs i)))))

(defn greedy-search [current subs i]
  (first
   (filter (complement nil?)
           (for [[sub replacement] subs]
             (gold (str/replace-first current (re-pattern sub) replacement)
                   (inc i))))))

(println "Day 19\n======")
(println (str "✮: " (silver medicine)))
(println (str "★: " (gold medicine 0)))