(require '[clojure.string :refer (split-lines split)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(defn to-inst [op start stop]
  [op
   (mapv #(Long. ^String %) (split start #","))
   (mapv #(Long. ^String %) (split stop #","))])

(defn parse [line]
  (->> line
       (re-find #"^(toggle|turn \w+) (\d+,\d+) .* (\d+,\d+)")
       rest
       (apply to-inst)))

(def ops {"turn on" (fn [^Long _] 1)
          "turn off" (fn [^Long _] 0)
          "toggle" (fn [^Long x] (bit-xor 1 x))})

(def ops2 {"turn on" (fn [^Long x] (inc x))
           "turn off" (fn [^Long x] (dec x))
           "toggle" (fn [^Long x] (+ 2 x))})

(defn transform! [^ints grid [op-str start end] part2]
  (let [opfn (if part2 (ops2 op-str) (ops op-str))]
    (doseq [^Long i (range (first start) (inc (first end)))
            ^Long j (range (second start) (inc (second end)))]
      (aset-int grid (+ (* 1000 i) j)
                (opfn (aget ^ints grid (+ (* 1000 i) j)))))))

(defn solve [instructions part2]
  (let [grid (int-array (* 1000 1000))]
    (doseq [inst instructions]
      (transform! grid inst part2))
    (areduce grid i cnt 0 (+ cnt (aget grid i)))))

(def instructions
  (->> "06.txt"
       slurp
       split-lines
       (mapv parse)))

(println "Day 06\n======")
(println (solve instructions false))
(println (solve instructions true))
