#include <fstream>
#include <functional>
#include <iostream>
#include <iterator>
#include <vector>

#include <range/v3/algorithm.hpp>
#include <range/v3/numeric.hpp>
#include <range/v3/range.hpp>
#include <range/v3/view.hpp>

using namespace std;
namespace r  = ::ranges;
namespace rv = ::ranges::views;

auto main(int argc, char** argv) -> int
{
  const auto sum       = [](const auto& xs) { return r::fold_left(xs, 0, plus()); };
  const auto increase  = [](const auto& xs) { return xs[0] < xs[1]; };
  const auto ascending = [&](const auto& xs) { return r::count_if(xs | rv::sliding(2), increase); };

  auto fs   = ifstream(argv[1]);
  auto nums = vector<int> {istream_iterator<int>(fs), istream_iterator<int>()};

  cout << ascending(nums) << "\n";
  cout << ascending(nums | rv::sliding(3) | rv::transform(sum)) << "\n";
}