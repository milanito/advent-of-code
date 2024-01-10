class PartSorter
    def initialize(file_name)
        @parts = []
        @instructions = {}
        @process_queue = []
        read_file(file_name)
        @accepted_parts = []
    end

    def read_file(file_name)
        instructions, parts = File.read(file_name).split("\n\n")

        instructions.split("\n").each do |instruction|
            key = instruction.split("{")[0].strip
            value = instruction.split("{")[1].split("}")[0].strip
            value = value.split(",").map {|v| v.strip}
            @instructions[key] = value
        end
    end

    def send_part_to(instruction, part)
        destination = instruction
        destination = instruction.split(":")[1].strip if instruction.include?(":")
        @process_queue << [destination, part]
    end

    def process_queue
        while @process_queue.length > 0 do
            destination, part = @process_queue.shift
            if destination == "A" || destination == "R"
                process_instruction(destination, part) 
                next
            end
            # p "#{@instructions}, #{destination}"
            @instructions[destination].each do |instruction|
                succeded = process_instruction(instruction, part)
                if succeded == true
                    break
                else
                    part = succeded unless succeded == false
                end
            end
        end
    end

    def sum_accepted_parts
        # p @accepted_parts
        total = 0
        @accepted_parts.each do |part|
            total += part["x"] + part["m"] + part["a"] + part["s"]
        end
        total
    end

    def process_instruction(instruction, part)
        if instruction == "A" 
            @accepted_parts << part
            return true
        elsif instruction == "R"
            return true
        end

        terminal = !instruction.include?(":")
        if terminal
            send_part_to(instruction, part)
            return true
        end

        less_than = instruction.include?("<")
        greater_than = instruction.include?(">")

        if less_than
            key = instruction.split("<")[0].strip
            value = instruction.split("<")[1].strip.to_i
            part_range_start, part_range_end = part[key]
            new_part = part.clone
            part[key] = [part_range_start,value - 1]
            new_part[key] = [value, part_range_end]      
            send_part_to(instruction, part)
            return new_part
        elsif greater_than
            key = instruction.split(">")[0].strip
            value = instruction.split(">")[1].strip.to_i
            part_range_start, part_range_end = part[key]
            new_part = part.clone
            part[key] = [value + 1, part_range_end]
            new_part[key] = [part_range_start, value]
            send_part_to(instruction, part)
            return new_part
        end
    end

    def find_combinations
        starting_part = {"x" => [1,4000], "m" => [1,4000], "a" => [1,4000], "s" => [1,4000]}

        @process_queue << ["in", starting_part]
    end

    def final_answer
        total = 0
        @accepted_parts.each do |accepted_part|
            total += calculate_range_permutations(accepted_part)
        end
        total
    end
    def calculate_range_permutations(part)
        ranges = part.values
        count_of_permutations = ranges.reduce(1) { |count, range| count * (range.last - range.first + 1) }
        count_of_permutations
    end

end

part_sorter = PartSorter.new("input.txt")
# p part_sorter.calculate_range_permutations({"x" => [0,1], "m" => [0,1], "a" => [0,1], "s" => [0,1]})
part_sorter.find_combinations
process_queue = part_sorter.process_queue
p part_sorter.final_answer