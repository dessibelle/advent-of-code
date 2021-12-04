(ns user (:require [clojure.string :as s]))

(defn base2string-to-int [base2string]
  (int (BigInteger. base2string 2)))

(defn powers-of-two [n]
  (map #(int (Math/pow 2 %)) (range 0 n)))

(defn test-values [values bit]
  (map (fn [v] (let [test-value (bit-or v bit)]
                 (= test-value v))) values))

(defn filter-bits [values bits-per-reading filter-fn]
  (let [num-values (count values)]
    (->> (powers-of-two bits-per-reading)
         (map (fn [bit]
                (->> bit
                     (test-values values)
                     (filter filter-fn)
                     (count)
                     (#(/ % num-values))
                     (#(Math/round (double %)))
                     (#(* bit %)))))
         (apply +))))

(defn calculate-gamma [values bits-per-reading]
  (filter-bits values bits-per-reading true?))

(defn calculate-epsilon [values bits-per-reading]
  (filter-bits values bits-per-reading false?))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn solve [filename]
  (let [input-data (readfile filename)
        bits-per-reading (count (first input-data))
        input-as-ints (map base2string-to-int input-data)
        gamma (calculate-gamma input-as-ints bits-per-reading)
        epsilon (calculate-epsilon input-as-ints bits-per-reading)]
    (* gamma epsilon)))

(solve "./input.txt")

(solve "./test.txt")