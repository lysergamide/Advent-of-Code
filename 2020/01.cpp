#include <algorithm>
#include <cstdio>
#include <fstream>
#include <iterator>
#include <optional>
#include <unordered_set>

auto main() -> int
{
    using namespace std;

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

    auto silver = *solver(2020);
    auto gold   = [&]() {  // boomers seething
        for (const auto n : nums)
            if (auto tmp = solver(2020 - n))
                return n * *tmp;
    }();

    printf("%d\n%d\n", silver, gold);
}