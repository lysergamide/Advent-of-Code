import Data.Complex

type Cfloat = Complex Float

parseComplex :: [String] -> Cfloat
parseComplex [direction, value] =
  let x = read value :: Float
  in case direction of
       "forward" -> (x :+ 0.0)
       "down"    -> (0.0 :+ x)
       "up"      -> (0.0 :+ (-x))

reducer :: (Cfloat, Cfloat) -> Cfloat -> (Cfloat, Cfloat)
reducer (x, y) n = (x + n, y + (1 :+ (imagPart x)))

score :: Cfloat -> Int
score x = floor $realPart x * imagPart x

main :: IO()
main = do
  xs <- map (parseComplex.words) . lines <$> readFile "input"
  let (silver, gold) = foldl reducer (0, 0) xs
  print $ score silver
  print $ score gold
