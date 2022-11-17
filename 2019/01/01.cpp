#include <fstream>
#include <iostream>
#include <numeric>
#include <ranges>

using namespace std;

auto fuelCost(const long mass) -> long { return mass / 3 - 2; }

auto fuelFuel(const long f, const long acc = 0) -> long
{
  return f <= 0 ? acc : fuelFuel(fuelCost(f), f + acc);
}

auto main(int, char** argv) -> int
{
  auto fs  = ifstream(argv[1]);
  int  sum = 0;

  for (auto const x : views::istream<int>(fs) | views::transform(fuelCost))
    sum += x;

  cout << sum << "\n"
       << sum + fuelFuel(fuelCost(sum));
}
