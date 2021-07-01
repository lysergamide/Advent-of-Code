use regex::Regex;
use std::str::FromStr;

const I: &str = include_str!("../03.txt");

struct Fabric {
    id: i32,
    top_left: (i32, i32),
    bottom_right: (i32, i32),
}

struct Sheet {
    grid: [[i32; 1000]; 1000],
}

impl Sheet {
    pub fn new() -> Sheet {
        Sheet {
            grid: [[0; 1000]; 1000],
        }
    }

    fn scan(&mut self, fab: &Fabric) -> () {
        let (x1, y1) = fab.top_left;
        let (dx, dy) = fab.bottom_right;

        for y in y1..(y1 + dy) {
            for x in x1..(x1 + dx) {
                self.grid[y as usize][x as usize] += 1;
            }
        }
    }

    pub fn scan_all(&mut self, squares: &Vec<Fabric>) -> () {
        squares.iter().for_each(|s| self.scan(s));
    }

    pub fn count_overlap(&self) -> usize {
        self.grid
            .iter()
            .map(|&row| row.iter().filter(|&x| *x > 1).count())
            .sum()
    }

    fn no_overlap(&self, sqr: &Fabric) -> bool {
        let (x1, y1) = sqr.top_left;
        let (dx, dy) = sqr.bottom_right;

        for y in y1..(y1 + dy) {
            for x in x1..(x1 + dx) {
                if self.grid[y as usize][x as usize] > 1 {
                    return false;
                }
            }
        }

        true
    }

    pub fn find_claim(&self, squares: &Vec<Fabric>) -> i32 {
        squares.iter().find(|s| self.no_overlap(s)).unwrap().id
    }
}

fn main() {
    let mut sheet = Sheet::new();
    let squares: Vec<Fabric> = I
        .lines()
        .map(|line| {
            let re = Regex::new(r"#(\d+) @ (\d+),(\d+): (\d+)x(\d+)").unwrap();
            let nums: Vec<i32> = re
                .captures(line)
                .unwrap()
                .iter()
                .skip(1)
                .map(|n| i32::from_str(n.unwrap().as_str()).unwrap())
                .collect();

            Fabric {
                id: nums[0],
                top_left: (nums[1], nums[2]),
                bottom_right: (nums[3], nums[4]),
            }
        })
        .collect();

    sheet.scan_all(&squares);
    println!(
        "silver: {}\ngold: {}",
        sheet.count_overlap(),
        sheet.find_claim(&squares)
    );
}
