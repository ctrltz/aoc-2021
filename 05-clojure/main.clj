(require '[clojure.string :as str])

(defn myrange [x y]
  (def dir (- (compare x y)))
  (range x (+ y dir) dir)
) 

(defn points [desc part]
  (let [
    [x1 y1 x2 y2] 
    (map #(Integer/parseInt %)
      (str/split (str/replace desc #" -> " ",") #","))
    ]
    (def dx (Math/abs (- x1 x2)))
    (def dy (Math/abs (- y1 y2)))
    (concat
      (when (= x1 x2) 
        (map vector 
          (repeat (+ 1 (Math/abs (- y2 y1))) x1) 
          (myrange y1 y2)
        )
      )
      (when (= y1 y2) 
        (map vector 
          (myrange x1 x2)
          (repeat (+ 1 (Math/abs (- x2 x1))) y1) 
        )
      )
      (when (and (= 2 part) (= dx dy))
        (map vector
          (myrange x1 x2)
          (myrange y1 y2)
        )
      )
    )
  )
)

(defn run [lines part]
  (count (filter #(> % 1) (vals (frequencies (mapcat #(points % part) lines)))))
)

(when (not= 1 (count *command-line-args*))
  (println "Usage:" *file* "filename")
  (System/exit 0))
  
(let [[filename] *command-line-args*]
  (with-open [rdr (clojure.java.io/reader filename)]
    (def lines (doall (line-seq rdr)))
    (println "Answer to Part 1:" (run lines 1))
    (println "Answer to Part 2:" (run lines 2))
  )
)
