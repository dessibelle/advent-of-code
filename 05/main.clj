(ns user (:require [clojure.string :as s])

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

(defn get-bounds [vectors]
  (let [coords (apply concat vectors)
        x-coords (map :x coords)
        y-coords (map :y coords)]
    (list {:x (apply min x-coords)
           :y (apply min y-coords)}
          {:x (apply max x-coords)
           :y (apply max y-coords)})))

(defn get-bounds-size [bounds key]
  (let [coords (map key bounds)]
    ;; (- (inc (apply max coords)) (apply min coords))
    (inc (apply max coords))))

(defn create-board [bounds]
  (let [x-size (get-bounds-size bounds :x)
        y-size (get-bounds-size bounds :y)
        empty-row (repeat x-size 0)]
    (println bounds)
    (println "using board of" x-size "x" y-size)
    (repeat y-size empty-row)))

(defn perpendicular-to-axis? [axis vector]
  (apply = (map axis vector)))

(defn apply-vector [row start end]
  (let [row-len (count row)
        vector-len (- (+ 1 end) start)
        addition  (concat (repeat start 0) (repeat vector-len 1) (repeat (- row-len vector-len) 0))]
    (map + row addition)))

(defn apply-vector-to-board [board vector col-key row-key]
  (let [y (row-key (first vector))
        start (apply min (map col-key vector))
        end (apply max (map col-key vector))]
    (map-indexed (fn [idx row] (if (= idx y) (apply-vector row start end) row)) board)))

(defn transpose-board [& xs]
  (apply map list xs))

(defn apply-vectors [board vectors]
  (let [horizontal-lines (filter (partial perpendicular-to-axis? :y) vectors)
        vertical-lines (filter (partial perpendicular-to-axis? :x) vectors)
        state (reduce (fn [coll vector] (apply-vector-to-board coll vector :x :y)) board horizontal-lines)
        state (apply transpose-board state) ;; transpose cols to rows
        state (reduce (fn [coll vector] (apply-vector-to-board coll vector :y :x)) state vertical-lines)
        state (apply transpose-board state)]  ;; transpose rows back to cols
    state))

(defn format-row [board-row]
  (s/join "" (map #(if (= 0 %) "." %) board-row)))

(defn format-board [board]
  (s/join "\n" (map format-row board)))

(defn calculate-score [board]
  (apply + (map (fn [row] (count (filter (partial < 1) row))) board)))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn solve [filename]
  (let [input-data (readfile filename)
        vectors (map parse-vector input-data)
        straight-lines (filter straight-line? vectors)
        bounds (get-bounds straight-lines)
        board (create-board bounds)
        state (apply-vectors board vectors)
        score (calculate-score state)]
    (println bounds)
    ;; (println (format-board state))
    score))
    
(solve "./test")

(solve "./input")
