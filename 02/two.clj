(ns user (:require [clojure.string :as s]))

(defn parse-string-tuple [tuple]
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
      (parse-string-tuple)))

(defn part1-reducer [collection]
  (reduce (fn [coll item] (let [key (first item)
                                     delta (second item)
                                     current (key coll)
                                     next (+ current delta)]
                                 (assoc coll key next)))
               {:x 0 :y 0} collection))

(defn part2-reducer [collection]
  (let [result (reduce (fn [coll item] (let [key (first item)
                                             delta (second item)
                                             x (:x coll)
                                             y (:y coll)
                                             is-forward-motion (and (= key :x) (> delta 0))
                                             is-vertical-motion (= key :y)
                                             aim (:aim coll)
                                             aim-delta (if is-vertical-motion
                                                         delta
                                                         0)
                                             next-aim (+ aim aim-delta)
                                             next-y (+ y (if is-forward-motion (* delta aim) 0))
                                             next-x (+ x (if (= key :x) delta 0))]
                                         (assoc coll :x next-x :y next-y :aim next-aim)))
                       {:x 0 :y 0 :aim 0} collection)]
    (dissoc result :aim)))

(defn readfile [filename reducer]
  (->> filename
       slurp
       s/split-lines
       (map parse-line)
       (map (fn [tuple] (apply tuple-to-cordinate tuple)))
       (reducer)
       (vals)
       (apply *)))

(readfile "./input.txt" part1-reducer)
(readfile "./input.txt" part2-reducer)

;; (readfile "./test.txt" part1-reducer)
;; (readfile "./test.txt" part2-reducer)