module Main where

import Test.HUnit

test1 = TestCase $ assertEqual "a succeeding test" "a" "a"

test2 = TestCase $ assertEqual "a failing test" "a" "b"

main = 
    runTestTT $ TestList [test1, test2]
