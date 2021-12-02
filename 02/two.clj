(ns user (:require [clojure.string :as s] [clojure.java.io :as io]))

(defn parse-tuple-string [tuple]
  (list (keyword (first tuple)) (Integer. (second tuple))))

(defn direction-to-axis [direction]
  (direction {:forward  :x
              :backward :x
              :up       :y
              :down     :y}))

(defn direction-to-multiplier [direction]
  (direction {:forward  1
               :backward -1
               :up       -1
               :down     1}))

(defn direction-to-delta [direction delta]
  (* delta (direction-to-multiplier direction)))

(defn tuple-to-cordinate [direction delta]
  (list (direction-to-axis direction)
        (direction-to-delta direction delta)))

(defn parse-line [line]
  (-> line
      (s/split #" ")
      (parse-tuple-string)))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines
       (map parse-line)
       (map (fn [tuple] (apply tuple-to-cordinate tuple)))
       (reduce (fn [coll item] (let [key (first item)
                                     delta (second item)
                                     current (key coll)
                                     next (+ current delta)]
                                 (assoc coll key next)))
               {:x 0 :y 0})
       (vals)
       (apply *)))

