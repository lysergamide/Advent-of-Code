#include <algorithm>
#include <fstream>
#include <iostream>
#include <iterator>
#include <optional>
#include <unordered_set>

auto main() -> int
{
    using namespace std;

    constexpr auto YEAR = 2020;

    auto f    = ifstream("./input/01.txt");
    auto nums = unordered_set<int>{ istream_iterator<int>(f),
                                    istream_iterator<int>() };

    const auto solver = [&](auto year) -> optional<int> {
        auto ret = find_if(begin(nums), end(nums), [&](const auto& x) {
            return nums.find(year - x) != nums.end();
        });

        if (ret != end(nums))
            return *ret * (year - *ret);

        return {};
    };

    auto silver = *solver(YEAR);
    auto gold   = [&]() {  // boomers seething
        for (const auto n : nums)
            if (auto tmp = solver(YEAR - n))
                return n * *tmp;
    }();

    cout << silver << '\n' << gold << '\n';
}