fn read_input(path: &str) -> String {
    match std::fs::read_to_string(path) {
        Ok(contents) => contents,
        Err(e) => {
            eprintln!("Failed to read file '{}': {}", path, e);
            std::process::exit(1);
        }
    }
}

fn parse_rotation(line: &str) -> i32 {
    let direction = line.chars().next().unwrap();
    let distance = line[1..].parse::<i32>().unwrap();
    let multiplier = if direction == 'R' { 1 } else if direction == 'L' { -1 } else { 0 };
    let delta = distance * multiplier;
    return delta;
}


fn parse_input(input: &str) -> Vec<i32> {
    return input.lines().map(parse_rotation).collect()
}

fn apply_rotations(rotations: &Vec<i32>, starting_position: i32) -> (i32, i32) {
    let mut position = starting_position;

    // let min = rotations.iter().min().unwrap();
    // let max = rotations.iter().max().unwrap();
    // println!("min: {:?}, max: {:?}", min, max);

    let mut times_visited_zero = 0;
    for rotation in rotations {
        position = (position + (rotation % 100)) % 100;
        if position == 0 {
          times_visited_zero += 1;
        }
    }
    return (position, times_visited_zero);
}

fn main() {
    let args: Vec<String> = std::env::args().collect();
    if args.len() < 2 {
        eprintln!("Usage: {} <input_path>", args[0]);
        std::process::exit(1);
    }
    let binding = std::fs::canonicalize(&args[1])
        .unwrap_or_else(|_| std::path::PathBuf::from(&args[1]));
    let input_path = binding.to_str().unwrap();
    let input = read_input(input_path);
    let rotations = parse_input(&input);
    let (position, times_visited_zero) = apply_rotations(&rotations, 50);
    println!("{:?}", position);
    println!("{:?}", times_visited_zero);
}
