use std::collections::HashSet;
use std::fs::*;
use std::io::BufRead;
use std::io::BufReader;

fn main() {
    let mut sum: i32 = 0;
    let mut duplicate = 0;
    let mut found = false;
    let mut seen = HashSet::new();

    let buffer = BufReader::new(File::open("01.txt").unwrap());

    buffer.lines().for_each(|num| {
        let n = num.unwrap();
        let sign = n.chars().nth(0).unwrap();
        let val = n[1..].parse::<i32>().unwrap();

        sum += if sign == '-' { -val } else { val };

        if !found && seen.contains(&sum) {
            duplicate = sum;
            found = true;
        } else if !found {
            seen.insert(sum);
        }
    });

    //    read_to_string("01.txt")
    //        .unwrap()
    //        .replace('\n', "")
    //        .split(',')
    //        .for_each(|num| {
    //            println!("{}", num);
    //            let sign = num.chars().nth(0).unwrap();
    //            let val = num[1..].parse::<i32>().unwrap();
    //
    //            sum += if sign == '-' { -val } else { val };
    //
    //            if !found && seen.contains(&sum) {
    //                duplicate = sum;
    //                found = true;
    //            } else if !found {
    //                seen.insert(sum);
    //            }
    //        });

    println!("{}", sum);
    println!("{}", duplicate);
}
