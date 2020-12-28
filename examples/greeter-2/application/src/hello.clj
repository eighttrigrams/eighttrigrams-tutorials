(ns hello
  (:require [greeter :refer :all]))

(defn -main [& args]
  (greet (first args)))