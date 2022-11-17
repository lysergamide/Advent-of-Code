#include <complex>
#include <fstream>
#include <functional>
#include <iostream>
#include <regex>
#include <string_view>

#include <range/v3/all.hpp>

using namespace std;
using namespace std::complex_literals;

using Pos = complex<long>;

namespace r  = ::ranges;
namespace rv = r::views;

auto parse(string_view str) -> pair<string, long>
{
  constexpr auto    RESTR = R"((\w+)\s+(\d+))";
  const static auto re    = regex(RESTR);

  auto matches = cmatch {};
  regex_search(str.data(), matches, re);

  const auto direction = string {matches[1].str()};
  const auto magnitude = stol(matches[2].str());

  return {direction, magnitude};
}

auto part1(const Pos& acc, string_view str) -> Pos
{

  const auto& [direction, magnitude] = parse(str);

  if (direction == "forward")
    return acc + Pos(magnitude, 0l);
  else if (direction == "down")
    return acc + Pos(0l, magnitude);
  else if (direction == "up")
    return acc + Pos(0l, -magnitude);

  cout << "err";
  return 0;
}

auto part2(const pair<Pos, long>& acc, string_view str) -> pair<Pos, long>
{
  const auto& [direction, magnitude] = parse(str);

  auto [pos, aim] = acc;

  if (direction == "forward")
    return {{pos.real() + magnitude, pos.imag() + magnitude * aim}, aim};
  else if (direction == "down")
    return {pos, aim + magnitude};
  else if (direction == "up")
    return {pos, aim - magnitude};

  cout << "err";
  return {0, 0};
}

auto main(int argc, char** argv) -> int
{
  using namespace std::placeholders;

  constexpr auto init = Pos(0, 0);

  auto fs = ifstream(argv[1]);

  const auto I     = string {istreambuf_iterator<char>(fs), istreambuf_iterator<char>()};
  const auto lines = rv::split(I, '\n') | rv::transform(r::to<string>());
  const auto pos1  = r::accumulate(lines, init, part1);
  const auto pos2  = get<Pos>(r::accumulate(lines, pair<Pos, long>(init, 0), part2));

  cout << pos1.real() * pos1.imag() << '\n';
  cout << pos2.real() * pos2.imag() << '\n';
}