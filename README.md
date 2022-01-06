# Clojure Tutorial

This is intended to bridge the gap between language-focused tutorials and setting 
up a project.

## Prerequisites

An installation of `Clojure` including the `clj` tool as well as `Leiningen`.

## Running code

## The REPL

As soon as you have installed **Clojure**, you can start a **REPL** (read-eval-print-loop) 
session.

    $ clj
    user=> (+ 1 1)
    2

Before `clj` there was (and still is) the `clojure` command. Typically one used to
call it with `rlwrap` as in `rlwrap clojure` to have a command line history via the
arrow up button. Now this is done just calling `clj`.

## Scripting

You also can put code into a file and execute it from the command line.

[./examples/add_1.clj](./examples/add_1.clj):

```clojure
(prn (+ 1 1))
```

Run it as a script with

    examples$ clj add_1.clj
    2

or load a script 

[./examples/add_2.clj](./examples/add_2.clj):

```clojure
(def add +)
```

from the REPL

    examples$ clj
    user=> (clojure.main/load-script "add_2.clj")
    user=> (add 2 2)
    4

One can read other Clojure scripts from Clojure script files. 
However, there is a much better way in Clojure, where it is very easy to set up 

## Minimal projects

As soon as you want to distribute code across multiple source files, 
you can very easily set up projects, following very limited conventions. 

[./examples/greeter_1/src/greeter.clj](./examples/greeter_1/src/greeter.clj):

```clojure
(ns greeter)
(defn greet [name] 
  (prn (str "Hello, " name "!")))
```

[./examples/greeter_1/src/hello.clj](./examples/greeter_1/src/hello.clj):

```clojure
(ns hello
  (:require [greeter :refer :all]))
(defn -main [& args]
  (greet (first args)))
```

Run it

```bash
examples/greeter_1$ clj -m hello Daniel
"Hello, Daniel!"
```

Adhering to these conventions one can access the application from the REPL.

    examples/greeter_1$ clj
    user=> (require '[greeter :refer :all])
    user=> (greet "Daniel")
    "Hello, Daniel!"

### Namespaces

Clojure namespaces correspond to Java namespaces, such that the file hierarchy 
aligns with the namespace names. In the next example greeter is located one level below
from where it was in the last example.

[./examples/greeter_2/src/greeter/greeter.clj](./examples/greeter_2/src/greeter/greeter.clj):

```clojure
(ns greeter.greeter)
(defn greet [name] 
  (prn (str "Hello, " name "!")))
```

[./examples/greeter_2/src/hello.clj](./examples/greeter_2/src/hello.clj):

```clojure
(ns hello
  (:require [greeter.greeter :refer :all]))
(defn -main [& args]
  (greet (first args)))
```

Inside the REPL one can access it then.

    examples/greeter_2$ clj
    user=> (require '[greeter.greeter :refer :all])
    user=> (greet "Daniel")
    "Hello, Daniel!"

## Minimalistic dependency management

The first build tool you should check out is **deps.edn**. 
It comes as part of the language and allows you to use dependencies, 
from maven, from github, as well
as on the local file system, such that the files from the last 
example could also be laid out as follows:

[./examples/deps_greeter/application/deps.edn](./examples/deps_greeter/application/deps.edn):

```clojure
{:deps
 {greeter {:local/root "../library"}}}
```

[./examples/deps_greeter/library/deps.edn](./examples/deps_greeter/library/deps.edn):

```clojure
{}
```

[./examples/deps_greeter/library/src/greeter.clj](./examples/deps_greeter/library/src/greeter.clj):

```clojure
(ns greeter)
(defn greet [name] 
  (prn (str "Hello, " name "!")))
```

[./examples/deps_greeter/application/src/hello.clj](./examples/deps_greeter/application/src/hello.clj):

```clojure
(ns hello
  (:require [greeter :refer :all]))
(defn -main [& args]
  (greet (first args)))
```

Run it with

```bash
examples/deps_greeter/application$ clj -m hello Daniel
"Hello, Daniel!"
```

Again, we can "reach" inside the application using the REPL.

    examples/deps_greeter/application$ clj
    Clojure 1.9.0
    user=> (require '[greeter :refer :all])
    nil
    user=> (greet "Daniel")
    "Hello, Daniel!"
    nil

This of course does work not only for local libraries, 
but for dependencies from github and maven as well.

[./examples/deps/deps.edn](./examples/deps/deps.edn):

```clojure
{:deps {org.clojure/java.classpath {:mvn/version "1.0.0"}}}
```

    examples/deps$ clj
    Clojure 1.9.0
    user=> (require '[clojure.java.classpath :refer :all])
    nil
    user=> (system-classpath)
    [Shows classpath info]

Working with local dependencies is great, because code changes are directly
available, like when you have the code in a separate namespace. Yet it already is
in a form where it can be made a 'external' github dependency by just changing 
from `:local/root` to `:git/url`.

## Minimalistic testing

Using the deps tool you can install a test runner, which 
facilitates writing unit tests with **clojure.test**, 
which is also part of the language.

[./examples/adder/deps.edn](./examples/adder/deps.edn):

```clojure
{
  :deps {com.cognitect/test-runner {
    :git/url "https://github.com/cognitect-labs/test-runner.git"
    :sha "209b64504cb3bd3b99ecfec7937b358a879f55c1"}}
  :aliases {:test {:extra-paths ["test"]
                   :main-opts ["-m" "cognitect.test-runner"]}}
}
```

[./examples/adder/src/adder.clj](./examples/adder/src/adder.clj):
```clojure
(ns adder)
(def add +)
```

[./examples/adder/test/adder_test.clj](./examples/adder/test/adder_test.clj):

```clojure
(ns adder-test
  (:require [clojure.test :refer :all]
            [adder :refer :all]))
(deftest test-adder
  (is (= 2 (add 1 1))))
```

Execute with

```bash
examples/adder$ clj -Atest
Running tests in #{"test"}

Testing adder-test

Ran 1 tests containing 1 assertions.
0 failures, 0 errors.
```

With the Cognitect test runner 
test suites in the form of namespaces (separate namespace segments 
after `-n` with `.` as usual if there are any) can be executed by

    clj -Atest -nadder-test

and single tests with (separate test name from namespace with `/`)

    clj -Atest -vadder-test/test-adder

## Leiningen

A more powerful build tool is **Leiningen** (or **lein** for short). The greeter example
looks like this, using the opportunity to show how Java can be mixed in when using Leiningen.

[./examples/lein_greeter/src/clj/hello.clj](./examples/lein_greeter/src/clj/hello.clj):

```clojure
(ns hello 
  (:import Greeter))
(defn -main [& args]
  (Greeter/greet (first args)))
```

[./examples/lein_greeter/src/java/Greeter.java](./examples/lein_greeter/src/java/Greeter.java):
```java
public class Greeter {
    public static void greet(String name) {
        System.out.println("Hello, " + name + "!");
    }
}
```

[./examples/lein_greeter/project.clj](./examples/lein_greeter/project.clj):

```clojure
(defproject lein-greeter "0.1.0-SNAPSHOT"
:dependencies [[org.clojure/clojure "1.10.0"]]
:main ^:skip-aot hello
:source-paths      ["src/clj"]
:java-source-paths ["src/java"])
```

Run it with

```bash
examples/lein_greeter$ lein run Daniel
Hello, Daniel!
```

### Tests

The src and test code is the same as in the the `examples/adder` example. 

See

[./examples/lein_adder/src/adder.clj](./examples/lein_adder/src/adder.clj) 

and

[./examples/lein_adder/test/adder_test.clj](./examples/lein_adder/test/adder_test.clj).

The Leiningen project description includes the `test` path as an additional source path. 

[./examples/lein_adder/project.clj](./examples/lein_adder/project.clj):

```clojure
(defproject lein-adder "0.1.0-SNAPSHOT"
:dependencies [[org.clojure/clojure "1.10.0"]]
:source-paths      ["src" "test"])
```

Run tests

    examples/lein_adder$ lein test
    lein test adder-test

    Ran 1 tests containing 1 assertions.
    0 failures, 0 errors.

Test a single namespace

    examples/lein_adder$ lein test :only adder-test

or execute a single test

    examples/lein_adder$ lein test :only adder-test/test-adder

## Details

### Namespaces and filenames

Note that when a namespace contains `-` as in `the-greeter` the filename
has to be `the_greeter.clj`.

### Require

#### require, use, import

Note that we have seen different calls to `require` depending on if it was part
of a namespace declaration as in 

```clojure
(ns hello
  (:require [greeter :refer :all]))
```
or when called in the REPL
```
user=> (require '[greeter :refer :all])
```

Also there was an `import` call, which is used with Java classes.

```clojure
(ns hello 
  (:import Greeter))
```

There is also `use`, which is a combination of require and refer, but
from what I've read is discouraged in favour of using the latter.

#### Require usage

Import more than one namespace

```clojure
(ns hello
  (:require [greeter :refer :all]
            [other :refer :all]))
```

To avoid namespace clashed one often requires and using shorthand.

```clojure
(ns hello
  (:require [greeter :as g]))
(g/greet "Daniel")
```

One can also import functions explicitly

```clojure
(ns hello
  (:require [greeter :refer [greet]]))
(greet "Daniel")
```

which works in combination with a shorthand.

```clojure
(ns hello
  (:require [greeter :refer [greet] :as g]))
(g/greet "Daniel")
```

Rename a function like this

```clojure
(ns hello
  (:require [greeter :as g :refer [greet] :rename {greet gr}]))
(g/gr "Daniel")
```

#### Scripting

See `:reload` and `:reload-all` options of require.
