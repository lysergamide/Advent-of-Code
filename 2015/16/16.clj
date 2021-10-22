(require
  '[clojure.string :refer (split-lines)])

(defrecord Aunt
  [number
   children
   cats
   samoyeds
   pomeranians
   akitas
   vizslas
   goldfish
   trees
   cars
   perfumes])

(def real-sue
  (Aunt. nil 3 7 2 3 0 0 5 3 2 1))

(def item-keys (keys real-sue))
(def item-names (mapv name item-keys))

(defn parse [line]
  (apply ->Aunt
         (for [i item-names]
           (let [re (if (= "number" i)
                      #"Sue (\d+)"
                      (re-pattern (str i ": (\\d+)")))
                 [_ match] (re-find re line)]
             (if (nil? match)
               match
               (Integer. match))))))

(def aunts
  (->> "16.txt"
       slurp
       split-lines
       (map parse)))

(defn silver-filter [item]
  (partial filter
           (fn [a]
             (or (nil? (item a))
                 (= (item real-sue) (item a))))))

(defn gold-filter [item]
  (partial filter
           (fn [a]
             (let [pair [(item a) (item real-sue)]]
               (cond (nil? (item a)) true
                     (#{:cats :trees} item) (apply > pair)
                     (#{:pomeranians :goldfish} item) (apply < pair)
                     :else (apply = pair))))))

(defn comp-filters [f]
  (->> (rest item-keys)
       (map f)
       (apply comp)))

(def silver
  (->> aunts
       ((comp-filters silver-filter))
       first
       :number))

(def gold
  (->> aunts
       ((comp-filters gold-filter))
       first
       :number))


(println "Day 16\n======")
(println (str "✮: " silver))
(println (str "★: " gold))

