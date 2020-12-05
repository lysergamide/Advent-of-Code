require "set"

I = File.readlines("input/05.txt", chomp: true)

def binary_search(upper, lower, ticket, &fn)
  ticket.each_char do |c|
    mid = (upper + lower) / 2
    fn.call(c) ? lower = mid : upper = mid
  end

  lower
end

def get_seat(ticket)
  binary_search(0, 127, ticket[0..6]) { _1 == "F" } * 8 +
    binary_search(0, 7, ticket[7..]) { _1 == "L" }
end

seats = I.map { get_seat _1 }.to_set
silver = seats.max
gold = seats.find { !seats.include?(_1 + 1) && seats.include?(_1 + 2) } + 1

puts(
  "Day 05\n" \
  "==================\n" \
  "✮: #{silver}\n" \
  "★: #{gold}"
)
