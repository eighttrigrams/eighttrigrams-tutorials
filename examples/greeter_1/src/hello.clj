(ns hello
  (:require greeter))

(defn -main [& args]
  (greet (first args)))
