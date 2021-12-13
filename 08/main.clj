(ns user (:require [clojure.string :as s]))

(defn parse-notes [note]
  (let [parts (s/split note #"\s+\|\s+")
        signal (s/split (first parts) #"\s+")
        output (s/split (last parts) #"\s+")]
    parts
    {:signal signal :output output}))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn output-to-digit [output]
  (case (count output)
    2 1
    4 4
    3 7
    7 8
    0))

(defn solve [filename part]
  (let [input-data (readfile filename)
        notes (map parse-notes input-data)
        output (map :output notes)
        digits (map output-to-digit (apply concat output))
        known-digits (remove (partial = 0) digits)
        result (count known-digits)]
    result))

;; (solve "./test" 1)
;; (solve "./test" 2)

(solve "./input" 1)
;; (solve "./input" 2)
