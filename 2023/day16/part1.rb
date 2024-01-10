lines = File.readlines('./input.txt', chomp: true).map { |line| line.split('') }

result = {}
factor = lines[0].length

beams = [{
  x: 0,
  y: 0,
  is_moving: true,
  direction: 'right'
}]

def check_beam(beam, lines)
  beam[:is_moving] = false if beam[:x] < 0 || beam[:x] >= lines[0].length || beam[:y] < 0 || beam[:y] >= lines.length
end

def update_beam(beam)
  beam[:x] += 1 if beam[:direction] == 'right'
  beam[:x] -= 1 if beam[:direction] == 'left'
  beam[:y] += 1 if beam[:direction] == 'bottom'
  beam[:y] -= 1 if beam[:direction] == 'top'
end

def update_beam_mirror_right(beam)
  if beam[:direction] == 'top'
    beam[:x] += 1 
    beam[:direction] = 'right'
  elsif beam[:direction] == 'bottom'
    beam[:x] -= 1
    beam[:direction] = 'left'
  elsif beam[:direction] == 'left'
    beam[:y] += 1
    beam[:direction] = 'bottom'
  elsif beam[:direction] == 'right'
    beam[:y] -= 1
    beam[:direction] = 'top'
  end
end

def update_beam_mirror_left(beam)
  if beam[:direction] == 'bottom'
    beam[:x] += 1
    beam[:direction] = 'right'
  elsif beam[:direction] == 'top'
    beam[:x] -= 1
    beam[:direction] = 'left'
  elsif beam[:direction] == 'right'
    beam[:y] += 1
    beam[:direction] = 'bottom'
  elsif beam[:direction] == 'left'
    beam[:y] -= 1
    beam[:direction] = 'top'
  end
end

rounds = 0
total = 0

while beams.length > 0 && rounds < factor / 2
  current = result.count

  pp "Total #{total}"
  pp "Current #{current}"
  pp "Moving Beams #{beams.length}"

  if current == total
    rounds += 1
  else
    rounds = 0
    total = current
  end

  new_beams = []
  beams.each_with_index do |beam, idx|
    next if !beam[:is_moving]

    result["#{beam[:y]}-#{beam[:x]}"] = true

    if lines[beam[:y]][beam[:x]] == '.'
      update_beam(beam)
      check_beam(beam, lines)
    elsif lines[beam[:y]][beam[:x]] == '/'
      update_beam_mirror_right(beam)
      check_beam(beam, lines)
    elsif lines[beam[:y]][beam[:x]] == '\\'
      update_beam_mirror_left(beam)
      check_beam(beam, lines)
    elsif lines[beam[:y]][beam[:x]] == '-'
      if ['right', 'left'].include?(beam[:direction])
        update_beam(beam) 
        check_beam(beam, lines)
      elsif ['top', 'bottom'].include?(beam[:direction])
        new_beam = beam.clone

        beam[:x] += 1 
        beam[:direction] = 'right'
        check_beam(beam, lines)

        new_beam[:x] -= 1 
        new_beam[:direction] = 'left'
        check_beam(new_beam, lines)
        new_beams.push(new_beam)
      end
    elsif lines[beam[:y]][beam[:x]] == '|'
      if ['top', 'bottom'].include?(beam[:direction])
        update_beam(beam) 
        check_beam(beam, lines)
      elsif ['right', 'left'].include?(beam[:direction])
        new_beam = beam.clone

        beam[:y] += 1 
        beam[:direction] = 'bottom'
        check_beam(beam, lines)

        new_beam[:y] -= 1 
        new_beam[:direction] = 'top'
        check_beam(new_beam, lines)
        new_beams.push(new_beam)
      end
    end
  end
  beams.push(*new_beams)
  beams = beams.select { |h| h[:is_moving] }.uniq { |h| "#{h[:x]}-#{h[:y]}-#{h[:direction]}"}
end

pp total
