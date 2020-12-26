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

    let silver = dubs * trips;
    let gold = I
        .lines()
        .combinations(2)
        .find(|p| {
            p[0].chars()
                .zip(p[1].chars())
                .filter(|(a, b)| a == b)
                .count()
                == 1
        })
        .and_then(|p| Some(p[0].chars().filter(|c| p[1].contains(c)).collect()))
        .unwrap();

    println!("{}", silver);
    println!("{}", gold);
}
