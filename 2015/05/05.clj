(require '[clojure.string :refer (includes? split-lines)])

(def lines (split-lines (slurp "input/05.txt")))

(defn nice [str]
  (let [vowels #{\a \e \i \o \u}
        bad ["ab" "cd" "pq" "xy"]]
    (and (not-any?  #(includes? str %) bad)
         (< 2 (count (filter #(contains? vowels %) str)))
         (boolean (re-find #"(.)\1" str)))))

(defn nice2 [str]
  (every? #(boolean (re-find % str))
          [#"(..).*\1"  #"(.).\1"]))

(println "Day 05\n======")
(run! println (map #(count (filter % lines)) [nice nice2]))
