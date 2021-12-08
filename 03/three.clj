(ns user (:require [clojure.string :as s]))

(defn base2string-to-int [base2string]
  (int (BigInteger. base2string 2)))

(defn get-nth-bit [n base2string]
  (->> (s/split base2string #"")
       (#(nth % n))
       (str)
       (Integer.)
       (#(> % 0))))

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

(defn select-desired-partition [partitioned-items comparator]
  (let [default-key (comparator 1 0) ;; true for >, false for <
        initial-value (if (true? default-key) 0 Integer/MAX_VALUE)
        reducer (fn [coll k v]
                  (cond-> coll
                    (= (count v) (:num coll)) (assoc :key default-key)
                    (comparator (count v) (:num coll)) (assoc :num (count v) :key k)))
        partition-key (:key (reduce-kv reducer {:num initial-value :key nil} partitioned-items))]
    (get partitioned-items partition-key)))

(defn get-bit-critera-rating
  ([input comparator] (get-bit-critera-rating input comparator 0))
  ([input comparator idx]
   (let [bits-per-reading (count (first input))
         paritioned-input (group-by #(true? (get-nth-bit idx %)) input)
         desired-partition (select-desired-partition paritioned-input comparator)]
     (if (and (< idx bits-per-reading) (> (count desired-partition) 1))
       (get-bit-critera-rating desired-partition comparator (+ idx 1))
       (base2string-to-int (first desired-partition))))))

(defn get-oxygen-generator-rating [input]
  (get-bit-critera-rating input >))

(defn get-co2-scrubbing-rating [input]
  (get-bit-critera-rating input <))

(defn solve-part2 [filename]
  (let [input-data (readfile filename)
        oxygen-generator-rating (get-oxygen-generator-rating input-data)
        co2-scrubbing-rating (get-co2-scrubbing-rating input-data)
        ]
    (* oxygen-generator-rating co2-scrubbing-rating)))

(solve "./input")
(solve-part2 "./input")

;; (solve "./test")
;; (solve-part2 "./test")