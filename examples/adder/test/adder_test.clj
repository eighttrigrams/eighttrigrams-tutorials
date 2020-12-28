(ns adder-test
  (:require [clojure.test :refer :all]
            [adder :refer :all]))

(deftest test-adder
  (is (= 2 (add 1 1))))
