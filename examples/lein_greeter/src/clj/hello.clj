(ns hello
  (:import Greeter))

(defn -main
  [& args]
  (Greeter/greet (first args)))
