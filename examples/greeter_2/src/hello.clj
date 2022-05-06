(ns hello
  (:require greeter.greeter))

(defn -main [& args]
  (greeter.greeter/greet (first args)))
