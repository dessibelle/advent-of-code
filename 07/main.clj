(ns user (:require [clojure.string :as s]))

(defn parse-numbers [numbers-string]
  (-> numbers-string
      (s/split #",")
      ((partial map #(Integer. %)))))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn order-by-frequency [crabs]
  (let [crabs-by-frequency (sort-by val > (frequencies crabs))]
    crabs-by-frequency))

(defn abs [v]
  (if (neg? v) (* -1 v) v))

(defn evaluate-movement-to-idx [candidate-idx crab]
  (let [pos (:pos crab)
        num (:num crab)
        delta (abs (- pos candidate-idx))
        score (* delta num)]
    score))

(defn evaluate-common-idx [candidate-idx crabs]
  (reduce (fn [sum crab] (+ sum (evaluate-movement-to-idx candidate-idx crab))) 0 crabs))

;; NOTE: this ignores any indices not already occipied by crabs, but did produce the correct answer anywey :)
(defn evaluate-crabs-by-occupied-index [crabs-by-frequency]
   (let [crabs (map (fn [[k v]] {:num v :pos k}) crabs-by-frequency)]
     (map (fn [crab]
            (assoc crab :score (evaluate-common-idx (:pos crab) crabs)))
          crabs)))

(defn solve [filename part]
  (let [input-data (readfile filename)
        crabs (parse-numbers (first input-data))
        crabs-by-frequency (order-by-frequency crabs)
        crabs-with-score (evaluate-crabs-by-occupied-index crabs-by-frequency)
        result (:score (first (sort-by :score < crabs-with-score)))
        ]
    result))

;; (solve "./test" 1)
;; (solve "./test" 2)

(solve "./input" 1)
;; (solve "./input" 2)
