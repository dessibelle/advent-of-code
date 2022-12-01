(ns user (:require [clojure.string :as s]))

(defn parse-numbers [numbers-string]
  (-> numbers-string
      (s/split #",")
      ((partial map #(Integer. %)))))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn group-by-frequency [crabs]
  (let [crabs-by-frequency (sort-by val > (frequencies crabs))]
    (into {} crabs-by-frequency)))

(defn abs [v]
  (if (neg? v) (* -1 v) v))

(defn evaluate-movement-to-idx [scoring-fn candidate-idx crab]
  (let [pos (:pos crab)
        num (:num crab)
        delta (abs (- pos candidate-idx))
        score (scoring-fn delta num)]
    score))

(defn evaluate-common-idx [candidate-idx crabs scoring-fn]
  (reduce (fn [sum crab] (+ sum (evaluate-movement-to-idx scoring-fn candidate-idx crab))) 0 crabs))

(defn evaluate-crabs-by-occupied-index [crabs-by-frequency crabs-range scoring-fn]
   (let [crabs (map (fn [[k v]] {:num v :pos k}) crabs-by-frequency)]
     (map (fn [pos]
            (let [num (get crabs pos 0)
                  crab {:num num :pos pos}
                  score (evaluate-common-idx pos crabs scoring-fn)]
              (assoc crab :score score)))
          crabs-range)))

(defn triangular-product [delta num]
  (let [computed-delta (reduce + 0 (range 1 (inc delta)))]
    (* computed-delta num)))

(defn solve [filename part]
  (let [input-data (readfile filename)
        crabs (parse-numbers (first input-data))
        crabs-range (->> crabs
                         (reduce (fn [res pos] (assoc res
                                                      :min (min pos (:min res))
                                                      :max (max pos (:max res))))
                                 {:min Integer/MAX_VALUE
                                  :max -1})
                         (#(range (:min %) (inc (:max %)))))
        crabs-by-frequency (group-by-frequency crabs)
        scoring-fn (if (= part 1) * triangular-product)
        crabs-with-score (evaluate-crabs-by-occupied-index crabs-by-frequency crabs-range scoring-fn)
        result (:score (first (sort-by :score < crabs-with-score)))]
    result))

;; (solve "./test" 1)
;; (solve "./test" 2)

(solve "./input" 1)
(solve "./input" 2)
