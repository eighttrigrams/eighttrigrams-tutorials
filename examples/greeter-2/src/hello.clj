(ns hello
  (:require [greeter.greeter :refer :all]))

(defn -main [& args]
  (greet (first args)))