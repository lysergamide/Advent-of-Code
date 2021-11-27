(require '[clojure.string :refer (trim)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(def input
  (->> "20.txt" slurp trim Integer/parseInt))

(defn silver [x]
  (let [size (quot x 10)
        nums (int-array (repeat size 0))]

    (doseq [i (range 1 size)
            j (range i size i)]
      ;; this ^int hint took me an obscene amount to figure out jfc
      (aset nums j ^int (+ (aget nums j) (* 10 i))))

    (first (first
            (filter (fn [[_ v]] (< x v))
                    (map-indexed vector nums))))))

(defn gold [x]
  (let [size (quot x 10)
        nums (int-array (repeat size 0))]

    (doseq [i (range 1 size)
            j (range i (min (inc (* i 50)) size) i)]
      (aset nums j ^int (+ (aget nums j) (* 11 i))))

    (first (first
            (filter (fn [[_ v]] (< x v))
                    (map-indexed vector nums))))))

(println "Day 20\n======")
(println (str "✮: " (silver input)))
(println (str "★: " (gold input)))