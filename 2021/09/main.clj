(ns user (:require [clojure.string :as s]))

(defn parse-row [input-row]
  (->> (s/split input-row #"")
       ((partial map #(Integer. %)))))

(defn parse-input [input-rows]
  (map parse-row input-rows))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))



(defn neighbors-at-position [position grid]
  (let [x (first position)
        y (last position)
        prev-y (max (dec y) 0)
        next-y (min (inc y) (dec (count grid)))
        rows (subvec (vec grid) prev-y (inc next-y))
        prev-x (max (dec x) 0)
        next-x (min (inc x) (dec (count (first rows))))
        mini-grid (map (fn [row] (subvec (vec row) prev-x (inc next-x))) rows)]
    (apply concat mini-grid)))

(defn get-lowpoint-coordinates [grid]
  (filter some? (for [[y row] (map-indexed list grid)
                      [x cell] (map-indexed list row)]
                  (let [neighbors (neighbors-at-position (list x y) grid)
                        lowest-value (filter #(<= % cell) neighbors)
                        lowpoint-or-nil (if (= 1 (count lowest-value))
                                          (list x y)
                                          nil)]
                    lowpoint-or-nil))))

(filter some? (apply list [(list 0 1) (list 0 2) nil (list 4 3) (list 5 4) nil nil nil (list 9 3)]))

(defn get-lowpoint-scores [grid]
  (for [[y row] (map-indexed list grid)
        [x cell] (map-indexed list row)]
    (let [neighbors (neighbors-at-position (list x y) grid)
          lowest-value (filter #(<= % cell) neighbors)]
      (if (= 1 (count lowest-value))
        (inc cell)
        nil))))

(defn get-basin-bounds-reducer [lowpoint] 
  (fn [coll k v]
    (let [start (:start coll)
          end (:end coll)]
      (if (= v 9)
        (cond
          (and (< k lowpoint) (> k start)) (assoc coll :start (inc k))
          (and (> k lowpoint) (< k end)) (assoc coll :end k)
          :else coll)
        coll))))

(let [row [9 2 4 8 7 9 8 4 5 6 3 1 2 4 7 8 3 9 7]
      x 12
      indexed-row (vec (map-indexed (fn [k v] (list k v)) row))
      basin-bounds-reducer (get-basin-bounds-reducer x)
      bounds (reduce-kv basin-bounds-reducer {:start 0 :end (dec (count row))} row)
      basin (subvec indexed-row (:start bounds) (:end bounds))
    ;;   upper-range (subvec indexed-row x (count row))
    ;;   
    ;;   lower-range (reverse (subvec indexed-row 0 x))
    ;;   upper-highpoint (into {} indexed-row)
      ]
  basin
;;   (group-by second (into {} (map (fn [[k v]] {k v}) indexed-row)))
  
  )

(let [[x y] (list 1 2)]
  {:x x :y y})

(defn get-basin-size [grid lowpoint-coodrinate]
  (let [[x y] get-lowpoint-coordinate
        row (get grid y)
        basin-bounds-reducer (get-basin-bounds-reducer x)
        bounds (reduce-kv basin-bounds-reducer {:start 0 :end (dec (count row))} row)
        basin (subvec row (:start bounds) (:end bounds))
        ;; upper-range (list x (count row))
        ;; lower-range (list 0 x)
        ]
    basin))

(defn get-basin-sizes [grid lowpoints]
  (->> lowpoints
       (map (partial get-basin-size grid)))

;; (let [input-data (readfile "./09/test")
;;       grid (parse-input input-data)
;;       basin (get-basin-sizes grid)]
;;   basin)

(defn solve-part-2 [filename part]
  (let [input-data (readfile filename)
        grid (parse-input input-data)
        lowpoints (get-lowpoint-coordinates grid)
        basin-scores (get-basin-sizes grid lowpoints)]
    lowpoints))

(defn solve [filename part]
  (let [input-data (readfile filename)
        grid (parse-input input-data)
        lowpoint-scores (get-lowpoint-scores grid)
        risk-levels (filter identity lowpoint-scores)]
    (apply + risk-levels)))

(solve "./09/test" 1)
(solve-part-2 "./09/test" 2)

(solve "./09/input" 1)
;; (solve "./09/input" 2)