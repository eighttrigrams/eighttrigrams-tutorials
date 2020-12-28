# Clojure

As soon as you have installed **Clojure**, you can start a **repl** (read-eval-print-loop) 
session.

    $ clj
    user=> (+ 1 1)
    2

You also can put code into a file and execute it from the command line.

    ./examples/hello.clj:
    (prn (+ 1 1))

    examples$ clj hello.clj
    2

As soon as you want to distribute code across multiple source files, 
you can very easily set up projects, following very limited conventions. 

    ./examples/greeter-1/src/greeter.clj:
    (ns greeter)
    (defn greet [name] 
      (prn (str "Hello, " name "!")))

    ./examples/greeter-1/src/hello.clj:
    (ns hello
      (:require [greeter :refer :all]))
    (defn -main [& args]
      (greet (first args)))

    examples/greeter-1$ clj -m hello Daniel
    "Hello, Daniel!"

The first build tool you should check out is **deps.edn**. 
It comes as part of the language and allows you to use dependencies, 
from maven, from github, as well
as on the local file system, such that the files from the last 
example could also be laid out as follows:

    ./examples/greeter-2/application/deps.edn:
    {:deps
     {greeter {:local/root "../library"}}}

    ./examples/greeter-2/library/deps.edn:
    {}

    ./examples/greeter-2/library/src/greeter.clj:
    (ns greeter)
    (defn greet [name] 
      (prn (str "Hello, " name "!")))

    ./examples/greeter-2/application/src/hello.clj:
    (ns hello
      (:require [greeter :refer :all]))
    (defn -main [& args]
      (greet (first args)))

    examples/greeter-2/application$ clj -m hello Daniel
    "Hello, Daniel!"

Using it you can install a test runner, which 
facilitates writing unit tests with **clojure.test**, 
which is also part of the language.


    ./examples/adder/deps.edn:
    {
      :deps {com.cognitect/test-runner {
        :git/url "https://github.com/cognitect-labs/test-runner.git"
        :sha "209b64504cb3bd3b99ecfec7937b358a879f55c1"}}
      :aliases {:test {:extra-paths ["test"]
                       :main-opts ["-m" "cognitect.test-runner"]}}
    }

    ./examples/adder/src/adder.clj:
    (ns adder)
    (defn add [a b] (+ a b))

    ./examples/adder/test/adder_test.clj:
    (ns adder-test
      (:require [clojure.test :refer :all]
                [adder :refer :all]))
    (deftest test-adder
      (is (= 2 (add 1 1))))

    examples/adder$ clj -Atest
    Running tests in #{"test"}

    Testing adder-test
    
    Ran 1 tests containing 1 assertions.
    0 failures, 0 errors.
