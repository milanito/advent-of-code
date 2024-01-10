input = File.read("./inpu2.txt")
            .split("\n")
            .map{|l| l.scan(/#(.{5})(.)/).to_a.flatten}
            .map{|l,d| [l.to_i(16), d]}

length = input.sum(&:first)

dir = { "3" => 0-1i, "0" => 1+0i, "1" => 0+1i, "2" => -1+0i}

pos = 0+0i
path = []

input.each do |l,d|
  path.unshift pos += dir[d] * l
end

puts path.each_cons(2).sum{ |a,b|
  (b.real - a.real) * (b.imag + a.imag) >> 1
} + (length / 2) + 1
