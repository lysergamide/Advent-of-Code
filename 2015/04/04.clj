(require '[clojure.string :refer (trim starts-with? join)])
(import java.security.MessageDigest)

;; md5 digest from github gist
(defn md5 [^String str]
  (->> str
       .getBytes
       (.digest (MessageDigest/getInstance "MD5"))
       (BigInteger. 1)
       (format "%032x")))

(def input (trim (slurp "04.txt")))

(defn solve [n]
  (let [zeroes (join (repeat n "0"))]
    (first
     (filter #(starts-with? (md5 (str input %)) zeroes)
             (range)))))

(println "Day 04\n======")
(run! println (map solve [5, 6]))
