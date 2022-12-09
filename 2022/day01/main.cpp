#include <bits/stdc++.h>

using namespace std;

int main(int, char** argv)
{
  auto fs = fstream(argv[1]);
  auto xs = vector<int> {0};

  for (auto l = ""s; getline(fs, l);)
    if (l == "")
      xs.push_back(0);
    else
      xs.back() += stoi(l);

  sort(xs.begin(), xs.end());
  cout << xs.back() << '\n'
       << reduce(xs.end() - 3, xs.end()) << '\n';
}