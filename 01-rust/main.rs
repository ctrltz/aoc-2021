use std::collections::VecDeque;
use std::env;
use std::fs;

fn main()
{
    let args: Vec<String> = env::args().collect();
    if args.len() != 2
    {
        panic!("Exactly one argument should be provided - the name of the input file");
    }

    let filename = &args[1];
    let contents = fs::read_to_string(filename)
        .expect("Failed to read the file");

    // Part 1
    let mut prev = -1;
    let mut inc_count = 0;

    for l in contents.lines()
    {
        let num : i32 = l.parse().expect("Not a number");
        if prev > 0 && num > prev
        {
            inc_count += 1;
        }
        prev = num;
    }

    println!("Answer to Part 1: {}", inc_count);

    // Part 2
    let win_size = 3;
    let mut prev = -1;
    let mut win: VecDeque<i32> = VecDeque::with_capacity(win_size);
    let mut win_sum = 0;
    let mut inc_count = 0;
    for l in contents.lines()
    {
        let num: i32 = l.parse().expect("Not a number");
        if win.len() == win_size
        {
            let el: i32 = win.pop_front().unwrap();
            win_sum -= el;
        }
        win.push_back(num);
        win_sum += num;
        if win.len() == win_size
        {
            if prev > 0 && win_sum > prev
            {
                 inc_count += 1;
            }
            prev = win_sum;
        }
    }

    println!("Answer to Part 2: {}", inc_count);
}
