(require '[clojure.string :refer (split-lines)])

(set! *warn-on-reflection* true)
(set! *unchecked-math* true)

(def lines
  (->> "input/07.txt"
       slurp
       split-lines))