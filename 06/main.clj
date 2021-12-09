(ns user (:require [clojure.string :as s]))

(defn parse-numbers [numbers-string]
  (-> numbers-string
      (s/split #",")
      ((partial map #(Integer. %)))))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn compute-generations [fish generations]
  (if (= 0 generations)
    fish
    (let [spawn (flatten (map (fn [timer] (if (= timer 0) (list 6 8) (- timer 1))) fish))]
      (compute-generations spawn (- generations 1)))))

(defn solve [filename part]
  (let [input-data (readfile filename)
        fish (parse-numbers (first input-data))
        spawn (compute-generations fish 80)]
    (count spawn)))

;; (solve "./test" 1)
;; (solve "./test" 2)


(solve "./input" 1)
;; (solve "./input" 2)
