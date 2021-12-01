solve :: [Int] -> Int
solve xs = length . filter (uncurry (<)) $ zip xs (tail xs)

window :: Int -> [Int] -> [[Int]]
window n [] = []
window n xs = (take n xs) : window n (tail xs)

main :: IO()
main = do
  nums <- map read.lines <$> (readFile "input") :: IO [Int]
  print $ solve nums
  print $ (solve . map sum . window 3) nums
