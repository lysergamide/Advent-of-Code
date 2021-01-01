(require '[clojure.string :refer (split-lines split)])

(defn to-inst [op start stop]
  [op
   (mapv #(Integer. %) (split start #","))
   (mapv #(Integer. %) (split stop #","))])

(defn parse [line]
  (->> line
       (re-find #"^(toggle|turn \w+) (\d+,\d+) .* (\d+,\d+)")
       rest
       (apply to-inst)))

(def ops {"turn on" (fn [_] 1)
          "turn off" (fn [_] 0)
          "toggle" (fn [^long x] (bit-xor 1 x))})

(def ops2 {"turn on" (fn [^long x] (inc x))
           "turn off" (fn [^long x] (dec x))
           "toggle" (fn [^long x] (+ 2 x))})

; (defn transform! [grid [op-str start end] part2]
;   (let [op (if part2 (ops op-str) (ops2 op-str))]
;     (doseq [i (range (first start) (first end))
;             j (range (second start) (second end))]
;       (assoc grid [i j] (op ([i j] grid 0))))))
(defn transform! [grid [op-str start end] part2]
  (assoc grid [1 2] 1))

(defn solve [instructions part2]
  (let [grid {}]
    (doseq [inst instructions]
      (transform! grid inst part2))
    (reduce + (vals grid))))

(def instructions
  (->> "input/06.txt"
       slurp
       split-lines
       (mapv parse)))

(println (solve instructions false))