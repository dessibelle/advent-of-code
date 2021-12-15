(ns user (:require [clojure.string :as s]))

(defn char-distance [a b]
  (- (int (.charAt a 0)) (int (.charAt b 0))))

(defn signal-string-to-bit-indices [signal-string]
  (if (empty? signal-string)
    '()
    (let [chars (s/split signal-string #"")
          offsets (map (fn [char] (char-distance char "a")) chars)]
      offsets)))

(defn signal-string-to-int [signal-string]
  (reduce bit-set 0 (signal-string-to-bit-indices signal-string)))

(defn parse-note [raw-note]
  (let [parts (s/split raw-note #"\s+\|\s+")
        raw-signal (s/split (first parts) #"\s+")
        raw-output (s/split (last parts) #"\s+")
        signal (map signal-string-to-int raw-signal)
        output (map signal-string-to-int raw-output)
        ]
    parts
    {:signal signal
     :output output}))

(comment

ab     : 1       two signals
ab d   : 7       three signals
ab  ef : 4       four signals
abcdefg: 8       seven signals

a cd fg: 2       five signals, two common with 4
abcd f : 3       five signals, contains 1
 bcdef : 5       five signals, contained within 6

abcdef : 9       six signals, contains 3 (and 5)
 bcdefg: 6       six signals, does not contain 1
abcde g: 0       six signals, does not contain 3 (or 5)

)

(defn num-bits-set [byte]
  (->> (map (fn [idx] (bit-test byte idx)) (range 0 8))
       (filter true?)
       (count)))

(defn matches-num-bits [num-bits signal-int]
  (= num-bits (num-bits-set signal-int)))

(defn find-first-by [predicate coll]
  (first (filter predicate coll)))

(defn signal-to-digit-map [wires]
  (let [one (find-first-by (partial matches-num-bits 2) wires)
        four (find-first-by (partial matches-num-bits 4) wires)
        seven (find-first-by (partial matches-num-bits 3) wires)
        eight (find-first-by (partial matches-num-bits 7) wires)
        two-three-five (filter (partial matches-num-bits 5) wires)
        zero-six-nine (filter (partial matches-num-bits 6) wires)
        three (find-first-by #(= one (bit-and % one)) two-three-five)
        six (find-first-by #(not= one (bit-and % one)) zero-six-nine)
        two-five (remove (partial = three) two-three-five)
        zero-nine (remove (partial = six) zero-six-nine)
        nine (find-first-by #(= three (bit-and % three)) zero-nine)
        zero (find-first-by #(not= three (bit-and % three)) zero-nine)
        five (find-first-by #(= % (bit-and % six)) two-five)
        two (find-first-by #(not= % (bit-and % six)) two-five)]
    {zero  0
     one   1
     two   2
     three 3
     four  4
     five  5
     six   6
     seven 7
     eight 8
     nine  9}))

(defn exp [x n]
  (reduce * (repeat n x)))

(defn decode-note [note]
  (let [signal (:signal note)
        digit-map (signal-to-digit-map signal)
        output-digits (:output note)
        output-values (map digit-map output-digits)
        output (reduce-kv (fn [sum k v] (+ sum (* v (exp 10 k)))) 0 (vec (reverse output-values)))]
    output))

(defn readfile [filename]
  (->> filename
       slurp
       s/split-lines))

(defn output-to-digit [output]
  (case (count output)
    2 1
    4 4
    3 7
    7 8
    0))

(defn solve-part-1 [filename part]
  (let [input-data (readfile filename)
        notes (map parse-note input-data)
        output (map :output notes)
        digits (map output-to-digit (apply concat output))
        known-digits (remove (partial = 0) digits)
        result (count known-digits)]
    result))

(defn solve-part-2 [filename part]
  (let [input-data (readfile filename)
        notes (map parse-note input-data)
        decoded-outputs (map decode-note notes)]
    (apply + decoded-outputs)))

;; (solve-part-1 "/Users/simon/Code/adventofcode2021/08/test" 1)
;; (solve-part-2 "/Users/simon/Code/adventofcode2021/08/test" 2)

;; (solve-part-1 "/Users/simon/Code/adventofcode2021/08/input" 1)
(solve-part-2 "/Users/simon/Code/adventofcode2021/08/input" 2)
