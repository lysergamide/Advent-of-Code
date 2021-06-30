extern crate regex;

use regex::Regex;
use std::collections::HashMap;
use std::str::FromStr;

const I: &str = include_str!("../03.txt");

struct fabric {
    id: i32,
    top_left: [i32; 2],
    bottom_right: [i32; 2],
}

fn main() {
    //    let mut map = HashMap::new();

    let re = Regex::new(r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)").unwrap();
    let squares: Vec<fabric> = I
        .lines()
        .map(|line| {
            let nums: Vec<i32> = re
                .captures(line)
                .unwrap()
                .iter()
                .skip(1)
                .map(|n| i32::from_str(n.unwrap().as_str()).unwrap())
                .collect();

            fabric {
                id: nums[0],
                top_left: [nums[1], nums[2]],
                bottom_right: [nums[3], nums[4]],
            }
        })
        .collect();
}
