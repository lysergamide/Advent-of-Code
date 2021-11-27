(require '[clojure.string :as str]
         '[clojure.math.combinatorics :refer (combinations)])

(def input
  (->> "21.txt"
       slurp
       str/trim
       str/split-lines
       (mapv #(Integer/parseInt (re-find #"\d+" %)))))

(def boss
  {:health (first input)
   :damage (second input)
   :armor (last input)})

(defrecord item [cost damage armor])

(def weapons
  [(->item  8 4 0)   ;; :Dagger      
   (->item 10 5 0)   ;; :Shortsword  
   (->item 25 6 0)   ;; :Warhammer   
   (->item 40 7 0)   ;; :Longsword   
   (->item 74 8 0)]) ;; :Greataxe    

(def armors
  [(->item 0 0 0)     ;; dummy
   (->item 13 0 1)    ;; :Leather     
   (->item 31 0 2)    ;; :Chainmail   
   (->item 53 0 3)    ;; :Splintmail  
   (->item 75 0 4)    ;; :Bandedmail  
   (->item 102 0 5)]) ;; :Platemail   

(def rings
  [(->item 0 0 0)    ;; dummy
   (->item 0 0 0)    ;; dummy
   (->item 25 1 0)   ;; :Damage+1   
   (->item 50 2 0)   ;; :Damage+2   
   (->item 100 3 0)  ;; :Damage+3   
   (->item 20 0 1)   ;; :Defense+1  
   (->item 40 0 2)   ;; :Defense+2  
   (->item 80 0 3)]) ;; :Defense+3  

(defn make-set [items]
  (apply ->item (for [prop [:cost :damage :armor]]
                  (reduce + (map prop items)))))

(def set-combs
  (sort-by :cost
           (for [w weapons a armors [r1 r2] (combinations rings 2)]
             (make-set [w a r1 r2]))))

(defn wins? [player]
  (let [boss-damage (max 1 (- (:damage boss) (:armor player)))
        player-damage (max 1 (- (:damage player) (:armor boss)))
        kill-time (/ (:health boss) player-damage)
        death-time (/ 100 boss-damage)]
    (< kill-time death-time)))

(def silver
  (->> set-combs (filter wins?) first :cost))

(def gold
  (->> set-combs reverse (filter (complement wins?)) first :cost))

(println
 "Day 21\n======\n"
 (str "✮: " silver) "\n"
 (str "★: " gold))