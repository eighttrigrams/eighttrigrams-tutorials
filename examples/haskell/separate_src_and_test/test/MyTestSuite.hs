module Main where

import Test.HUnit
import MyModule

test1 = TestCase $ assertEqual "a failing test" 5 (times2 2)

main = 
    runTestTT $ TestList [test1]
