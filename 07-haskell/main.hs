import Debug.Trace
import System.Environment
import System.Exit

dist :: Int -> Int -> Int
dist s e = 
    abs(s - e)

sum1ton :: Int -> Int
sum1ton n =
    (n * (n + 1)) `div` 2

cumdist :: Int -> Int -> Int
cumdist s e =
    sum1ton (dist s e)

fuel :: [Int] -> Int -> (Int -> Int -> Int) -> Int
fuel xs p df = 
    sum (map (\x -> df x p) xs)

solve :: [Int] -> Int -> Int -> (Int -> Int -> Int) -> Int
solve xs l r df = 
    let a = floor (fromIntegral (2 * l + r) / 3) :: Int
        b = ceiling (fromIntegral (l + 2 * r) / 3) :: Int
        fa = fuel xs a df
        fb = fuel xs b df
    in if (a + 1) < b 
        then if fa < fb
            then solve xs l b df
            else solve xs a r df
        else if fa < fb
            then a
            else b

comma2space :: Char -> Char
comma2space c
    | c == ','   = ' '
    | otherwise  = c

parseStr :: String -> [Int]
parseStr str =
    let numbers = map comma2space str
    in map (\x -> read x :: Int) (words numbers)

usage = putStrLn "Usage: ./main <file>"
exit = exitWith ExitSuccess

main = getArgs >>= parse

parse args =
    let argc = length args
    in if argc /= 1
        then usage >> exit
        else run (args !! 0)

run file = 
    let part1 = solver dist
        part2 = solver cumdist
    in do
        contents <- readFile file
        let xs = parseStr contents
        let l = minimum xs
        let r = maximum xs
        putStr "Answer to Part 1: "
        print (part1 xs l r)
        putStr "Answer to Part 2: "
        print (part2 xs l r)

solver :: (Int -> Int -> Int) -> [Int] -> Int -> Int -> (Int, Int)
solver df xs l r =
    let ans = solve xs l r df
    in (ans, fuel xs ans df)
