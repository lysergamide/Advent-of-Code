(require '[clojure.string :refer (split-lines split)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(def input-file "07.txt")

(def gate-fn
  {"NOT" bit-not
   "OR" bit-or
   "AND" bit-and
   "RSHIFT" bit-shift-right
   "LSHIFT" bit-shift-left})

(defn parse-line [line]
  (let [[left right] (split line #" -> ")
        args (split left #" ")
        expr (case (count args)
               1 (list nil args)
               2 (list (gate-fn (first args)) (drop 1 args))
               3 (list (gate-fn (second args)) (list (first args) (last args))))]
    [right expr]))

(def solve
  (memoize
    (fn [gate-map register]
      (let [[gate args] (gate-map register)]
        (cond
          (number? args) args
          (re-matches #"\d+" register) (Integer/parseInt register)
          (nil? gate) (solve gate-map (first args))
          :else (apply gate (map #(solve gate-map %) args)))))))

(def gate-map
  (->> (slurp input-file)
       split-lines
       (map parse-line)
       (reduce conj {})))

(def silver (solve gate-map "a"))
(def gold
  (-> gate-map
      (assoc "b" (list nil silver))
      (solve "a")))

(println "Day 07\n======")
(println silver)
(println gold)
