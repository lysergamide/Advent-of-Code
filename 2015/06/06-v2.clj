(require '[clojure.string :refer (split-lines split)])
(set! *warn-on-reflection* true)
(set! *unchecked-math* :warn-on-boxed)


(defn to-inst [instr start stop]
  [({"turn on" :on
     "turn off" :off
     "toggle" :toggle
     } instr)
   (map #(Long. ^String %) (split start #","))
   (map #(Long. ^String %) (split stop #","))])

(defn parse-line [ln]
  (->> ln
       (re-find #"^(toggle|turn \w+) (\d+,\d+) .* (\d+,\d+)")
       rest
       (apply to-inst)))

(def ops {:on (fn [^long x] 1)
          :off (fn [x] 0)
          :toggle #(bit-xor 1 ^long %)})

(def ops2 {:on #(inc ^long %)
           :off #(max 0 (dec ^long %))
           :toggle #(+ 2 ^long %)})

(defn change-lights [grid [inst start end] part1]
  (let [func ((if part1 ops ops2) inst)
        is (range (first start) (inc (first end)))
        js (range (second start) (inc (second end)))]
    (persistent!
      (reduce #(assoc! %1 %2 (func (or (%1 %2) 0)))
              (transient grid)
              (for [i is j js] [i j])))))

(defn solve [instructions part1]
  (let [grid (reduce #(change-lights %1 %2 part1) {} instructions)]
    (reduce + (vals grid))))

(def instructions
  (->> "06.txt"
       slurp
       split-lines
       (map parse-line)))

(println "Day 06\n======")
(println (solve instructions true))
(println (solve instructions false))
