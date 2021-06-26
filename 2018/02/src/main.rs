use itertools::Itertools;
use std::collections::HashMap;

const I: &str = include_str!("../02.txt");

fn main() {
    let mut dubs = 0;
    let mut trips = 0;

    for line in I.lines() {
        let mut map = HashMap::new();
        line.chars().for_each(|c| *map.entry(c).or_insert(0) += 1);
        if map.values().any(|x| *x == 2) {
            dubs += 1
        }
        if map.values().any(|x| *x == 3) {
            trips += 1
        }
    }
    let pair = I
        .lines()
        .combinations(2)
        .find(|comb| {
            comb[0]
                .chars()
                .zip(comb[1].chars())
                .filter(|(a, b)| a != b)
                .count()
                == 1
        })
        .unwrap();

    let silver = dubs * trips;
    let gold = pair[0]
        .chars()
        .zip(pair[1].chars())
        .filter(|(a, b)| a == b)
        .map(|x| x.0)
        .collect::<String>();

    println!("{}\n{}", silver, gold);
}
