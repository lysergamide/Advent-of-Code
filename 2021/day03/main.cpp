#include <algorithm>
#include <fstream>
#include <iostream>
#include <list>
#include <string_view>
#include <unordered_map>
#include <vector>

using namespace std;

using Strings = vector<string>;
using ul      = unsigned long;
using Tally   = unordered_map<char, size_t>;

template <typename T, template <typename...> typename Container>
auto tallyCol(const Container<T>& container, const size_t idx) -> Tally
{
  auto ret = Tally {};

  for (const auto& x : container)
    ++ret[x[idx]];

  return ret;
}

auto part1(const Strings& lines) -> ul
{
  const auto size = lines.front().size();

  auto x = 0ul;
  auto y = 0ul;

  for (size_t i = 0; i < size; ++i) {
    auto counts = tallyCol(lines, i);

    const auto mm = counts['0'] > counts['1'];

    x = (x << 1) + mm;
    y = (y << 1) + (mm == 0);
  }

  return x * y;
}

template <typename Comp>
auto part2(const Strings& lines, Comp&& fn) -> ul
{
  auto remaining = list<string_view> {lines.begin(), lines.end()};

  for (size_t col = 0; remaining.size() > 1; ++col) {
    auto counts = tallyCol(remaining, col);

    const char key = fn(counts['0'], counts['1']) ? '0' : '1';

    remaining.remove_if([&](string_view str) { return str[col] != key; });
  }

  return stoul(remaining.begin()->data(), nullptr, 2);
}

auto main(int, char** argv) -> int
{
  static const auto leq = less_equal<ul>();
  static const auto gt  = greater<ul>();

  auto fs    = ifstream(argv[1]);
  auto lines = Strings {};

  for (auto l = ""s; getline(fs, l);)
    lines.push_back(l);

  cout << part1(lines) << '\n';
  cout << part2(lines, leq) * part2(lines, gt) << '\n';
}