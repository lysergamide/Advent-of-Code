const I: &str = include_str!("../01.txt");
use std::collections::HashSet;

fn main() {
    let nums: Vec<i32> = I.lines().filter_map(|s| s.parse::<i32>().ok()).collect();
    let mut seen = HashSet::new();
    let mut sum = 0;

    let silver: i32 = nums.iter().sum();
    let gold = nums
        .iter()
        .cycle()
        .find_map(|n| {
            sum += n;
            seen.replace(sum)
        })
        .unwrap();

    println!("{}\n{}", silver, gold);
}