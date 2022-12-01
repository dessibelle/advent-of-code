(ns user (:require [clojure.string :as s]))

(defn parse-numbers [numbers-string]
  (-> numbers-string
      (s/split #",")
      ((partial map #(Integer. %)))
      frequencies))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn spawn-reducer [next-gen key val]
  (case key
    0 (assoc next-gen
             6 (+ (get next-gen 6 0) val)
             8 (+ (get next-gen 8 0) val))
    (let [new-key (dec key)]
      (assoc next-gen
             new-key (+ (get next-gen new-key 0) val)))))

(defn compute-generations [fish generations]
  (if (= 0 generations)
    fish
    (let [spawn (reduce-kv spawn-reducer {} fish)]
      (compute-generations spawn (- generations 1)))))

(defn solve [filename part]
  (let [input-data (readfile filename)
        fish (parse-numbers (first input-data))
        spawn (compute-generations fish (if (= part 1) 80 256))
        score (apply + (vals spawn))]
    score))

;; (solve "./test" 1)
;; (solve "./test" 2)

(solve "./input" 1)
(solve "./input" 2)
