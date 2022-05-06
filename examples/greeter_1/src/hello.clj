(ns hello
  (:require greeter))

(defn -main [& args]
  (greeter/greet (first args)))
