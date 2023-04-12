import Debug.Trace

debug msg d = trace (msg ++ show d) d

times2 = (*) 2

main = 
    putStrLn 
    $ show 
    $ debug "2: "
    $ times2
    $ debug "1: " 
    $ times2 
    $ 3
