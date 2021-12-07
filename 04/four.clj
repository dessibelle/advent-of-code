(ns user (:require [clojure.string :as s]))

(defn parse-number-string [numbers-string separator]
  (map #(Integer. %) (s/split numbers-string separator)))

(defn parse-bingo-board-row [raw-bingo-row]
  (-> raw-bingo-row
      (s/trim)
      (parse-number-string #"\s+")))

(defn parse-bingo-boards [bingo-board-strings]
  (->> bingo-board-strings
       (map parse-bingo-board-row)
       (partition 5)))

(defn bold-string [str-val]
  (s/join "" ["\033[1m" str-val "\033[0m"]))

(defn format-number
  ([bingo-number] (format-number bingo-number false))
  ([bingo-number checked]
   (let [formatted-number (format "%2s" bingo-number)]
     (if (true? checked)
       (bold-string formatted-number)
       formatted-number))))

(defn format-row [bingo-row]
  (map (fn [number-or-state]
         (if (number? number-or-state)
           (format-number number-or-state)
           (format-number (:val number-or-state) (:checked number-or-state))))
       bingo-row))

(defn format-board [bingo-board]
  (->> bingo-board
       (map format-row)
       (map (partial s/join " "))
       (s/join "\n")))

(defn create-empty-game-state [bingo-board]
  (map (fn [row] (map (partial hash-map :checked false :val) row)) bingo-board))

(defn transpose-board [& xs]
  (apply map list xs))

(defn is-bingo-on-row [game-state-row]
  (if (every? true? (map :checked game-state-row))
    game-state-row
    nil))

(defn is-bingo-on-board [game-state-board]
  (let [row-evals (map is-bingo-on-row game-state-board)
        col-evals (map is-bingo-on-row (apply transpose-board game-state-board))
        all-evals (concat row-evals col-evals)
        is-bingo (remove nil? all-evals)]
    (if (> (count is-bingo) 0)
      game-state-board
      nil)))

(defn get-boards-with-bingo [game-state]
  (remove nil? (apply concat (map is-bingo-on-board game-state))))

(defn apply-bingo-number-to-cell [number cell]
  (if (= number (:val cell))
    (assoc cell :checked true)
    cell))

(defn apply-bingo-number-to-row [number row]
  (map (partial apply-bingo-number-to-cell number) row))

(defn apply-bingo-number-to-board [number bingo-board]
  (map (partial apply-bingo-number-to-row number) bingo-board))

(defn apply-bingo-number-to-boards [number bingo-boards]
  (map (partial apply-bingo-number-to-board number) bingo-boards))

(defn apply-game-state [bingo-numbers bingo-boards]
  (let [raw-game-state (map create-empty-game-state bingo-boards)]
    (reduce (fn [reduce-state number]
              (let [game-state (:game-state reduce-state)
                    next-game-state (apply-bingo-number-to-boards number game-state)
                    board-with-bingo (get-boards-with-bingo next-game-state)]
                (if (empty? (:bingo-board reduce-state))
                  (assoc reduce-state
                         :game-state next-game-state
                         :bingo-board board-with-bingo
                         :last-number number)
                  reduce-state)))
            {:game-state raw-game-state
             :bingo-board nil
             :last-number -1}
            bingo-numbers)))

(defn calculate-part-1-score [board last-number]
  (println (format-board board))
  (let [unchecked-cells (filter #(false? (:checked %)) (apply concat board))
        unchecked-numbers (map :val unchecked-cells)]
    (* (apply + unchecked-numbers) last-number)))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines
       (remove (partial = ""))))

(defn solve [filename]
  (let [input-data (readfile filename)
        bingo-numbers (parse-number-string (first input-data) #",")
        raw-bingo-boards (parse-bingo-boards (drop 1 input-data))
        state (apply-game-state bingo-numbers raw-bingo-boards)]
    (println (calculate-part-1-score (:bingo-board state) (:last-number state)))))


(solve "./input.txt")
;; (solve-part2 "./input.txt")

;; (solve "./test.txt")
;; (solve-part2 "./test.txt")