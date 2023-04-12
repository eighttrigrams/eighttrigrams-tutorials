import Debug.Trace

debug d msg = trace (msg ++ show d) d

isPos n
  | n<0       = False `debug` "f: "
  | otherwise = True `debug` "t: "

main = 
    putStrLn 
    $ show 
    $ isPos 3
