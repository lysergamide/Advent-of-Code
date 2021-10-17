(require
  '[clojure.string :refer (split-lines split)])

(def timer 2503)
(def lines (-> "14.txt" slurp split-lines))

(defn to-i
  [^String x] (Integer/parseInt x))
(definterface Ireindeer (dist [t]))
(deftype Reindeer [rname speed duration rest-time]
  Ireindeer
  (dist [this t]
    (if (>= 0 t)
      0
      (let [period (+ duration rest-time)
            cycles (* (quot t period) duration)
            extra (min (rem t period) duration)
            run-time (+ cycles extra)]
        (* speed run-time)))))

(defn to-deer [line]
  (let [[n s d r] (rest (re-matches #"^(\w+).* (\d+).* (\d+).* (\d+).*" line))]
    (->Reindeer n (to-i s) (to-i d) (to-i r))))

(def deer
  (map to-deer lines))
(def leader
  (memoize
    (fn [t]
      (apply max (map #(.dist % t) deer)))))

(defn score-run [d]
  (letfn [(score [d t] (if (= (leader t) (.dist d t)) 1 0))]
    (reduce + (for [t (range 1 (inc timer))]
                (score d t)))))

(def silver
  (apply max (map #(.dist % timer) deer)))
(def gold
  (apply max (map score-run deer)))

(println "Day 14\n======")
(println (str "✮: " silver))
(println (str "★: " gold))
