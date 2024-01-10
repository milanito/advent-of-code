# frozen_string_literal: true

class Solution
  def self.part_1(*input)
    new(*input).part_1
  end

  def self.part_2(*input)
    new(*input).part_2
  end

  def initialize(input)
    @input = input
  end

  def data
    @data ||= begin
                processed = @input.lines(chomp: true).map do |line|
                  process_input line
                end

                processed.length == 1 ? processed.first : process_dataset(processed)
              end
  end

  private
    def process_input(line)
      line
    end

    def process_dataset(set)
      set
    end
end

module Year2023
  class Day22 < Solution
    # @input is available if you need the raw data input
    # Call `data` to access either an array of the parsed data, or a single record for a 1-line input file

    Brick = Struct.new(:x1, :y1, :z1, :x2, :y2, :z2)

    def get_all_points(x1, y1, z1, x2, y2, z2)
      (x1..x2).to_a.product((y1..y2).to_a).product((z1..z2).to_a).map { [_1[0][0], _1[0][1], _1[1]] }
    end

    def setup(brick_input)
      bricks = brick_input.map { |b| Brick.new(*b.scan(/\d+/).map(&:to_i)) }.sort_by(&:z1)

      # populate a grid to help detect collision
      grid = {}
      bricks.each { |b|
        get_all_points(*b).each { |x,y,z| grid[[x,y,z]] = b }
      }

      # drop the bricks by decrementing z and testing for collision
      bricks.each { |b|
        until b.z1==1
          points = get_all_points(*(b.to_a))
          break if points.any? { |x, y, z| grid[[x, y, z - 1]] &&  grid[[x, y, z - 1]] != b }
          points.each { |x, y, z| grid.delete([x,y,z]); grid[[x,y,z-1]] = b }
          b.z2 -= 1
          b.z1 -= 1
        end
      }

      above = bricks.map { |b|
        [b, get_all_points(*(b.to_a)).map{ |x,y,z|
          grid[[x,y,z+1]] if(grid[[x,y,z+1]] && grid[[x,y,z+1]] != b)
        }.compact.to_set]
      }.to_h

      below = bricks.map { |b|
        [b, get_all_points(*(b.to_a)).map{ |x,y,z|
          grid[[x,y,z-1]] if(grid[[x,y,z-1]] && grid[[x,y,z-1]] != b)
        }.compact.to_set]
      }.to_h

      return bricks, grid, above, below
    end

    def part_1
      bricks, grid, above, below = setup(data)

      bricks.find_all { |b|
        above[b].all?{ below[_1].size>1 }
      }.size
    end

    def part_2
      bricks, grid, above, below = setup(data)

      bricks.sum { |b|
        felled = [b].to_set
        q = above[b].to_a
        while (t = q.shift)
          next if felled.include?(t)
          next unless (below[t].all? { felled.include?(_1) })
          felled << t
          q += above[t].to_a
        end
        felled.size - 1
      }
    end

  end
end
