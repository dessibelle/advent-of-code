(ns user (:require [clojure.string :as s]))

(defn parse-coordinate [coord-string]
  (-> coord-string
      (s/split #",")
      ((partial map #(Integer. %)))
      (#(hash-map :x (first %) :y (second %)))))

(defn parse-vector [vector-string]
  (-> vector-string
      (s/split #" -> ")
      (#(map parse-coordinate %))))

(defn straight-line? [vector]
  (let [x-coords (map :x vector)
        y-coords (map :y vector)]
    (or (apply = x-coords)
        (apply = y-coords))))

(defn diagonal-line? [vector]
  (let [x-coords (map :x vector)
        y-coords (map :y vector)
        cathetus-size #(apply - (sort-by identity > %))
        x-size (cathetus-size x-coords)
        y-size (cathetus-size y-coords)]
    (= x-size y-size)))

(defn vector-range [v1 v2]
  (let [largest-first (> v1 v2)
        val1 (if largest-first (inc v1) v1)
        val2 (if largest-first v2 (inc v2))]
    (if largest-first
      (reverse (range val2 val1))
      (range val1 val2))))

(defn interpolate-vector [vector]
  (let [p1 (first vector)
        p2 (last vector)
        x1 (:x p1) x2 (:x p2)
        y1 (:y p1) y2 (:y p2)
        x-length (apply - (sort-by identity > [x1 x2]))
        y-length (apply - (sort-by identity > [y1 y2]))
        x-vals (if (= x-length 0) (repeat (inc y-length) x1) (vector-range x1 x2))
        y-vals (if (= y-length 0) (repeat (inc x-length) y1) (vector-range y1 y2))
        points (map list x-vals y-vals)]
    points))

(defn vectors-to-points [vectors]
  (map interpolate-vector vectors))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn solve [filename part]
  (let [input-data (readfile filename)
        vectors (map parse-vector input-data)
        straight-lines (filter straight-line? vectors)
        diagonal-lines (if (= part 1) '() (filter diagonal-line? vectors))
        points-by-vector (vectors-to-points (concat straight-lines diagonal-lines))
        points-by-frequency (frequencies (apply concat points-by-vector))
        points (filter (fn [[_ val]] (< 1 val)) points-by-frequency)]
    (count points)
    ))

;; (solve "./test" 1)
;; (solve "./test" 2)

(solve "./input" 1)
(solve "./input" 2)
