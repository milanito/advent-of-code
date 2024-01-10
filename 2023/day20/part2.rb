
def get_circuit(input)
  all_inputs = {}
  circuit = input.map { |line|
    if(line =~ /(%|&)(\w+) -> ([\w,\s]+)/)
      n = Regexp.last_match(2).to_sym
      h = {:type => Regexp.last_match(1).to_sym, :state => 0, :outputs => Regexp.last_match(3).split(", ").map(&:to_sym)}
      h[:outputs].each { |o| (all_inputs[o] ||= Set.new) << n }
      [n, h]
    elsif(line =~ /broadcaster -> ([\w,\s]+)/)
      n = :broadcaster
      h = {:type => n, :outputs => Regexp.last_match(1).split(", ").map(&:to_sym)}
      h[:outputs].each { |o| (all_inputs[o] ||= Set.new) << n }
      [n, h]
    end
  }.to_h
  circuit.each { |k,v|
    next if(k==:broadcaster)
    v[:inputs] = {}
    all_inputs[k].each{ v[:inputs][_1] = 0}
  }
end

def push_button(circuit, pulse_cnt)
  queue = [ [0, :broadcaster, :button] ]
  until queue.empty?
    op, dst, src = queue.shift
    (pulse_cnt[dst] ||= [0,0])[op] += 1
    next unless (circuit[dst])

    pulse_out = case(circuit[dst][:type])
      when :broadcaster
        0
      when :%
        (circuit[dst][:state] ^= 1) if(op==0)
      when :&
        circuit[dst][:inputs][src] = op
        (circuit[dst][:inputs].values.all?{_1==1}) ? 0 : 1
      end

    circuit[dst][:outputs].each { queue << [pulse_out, _1, dst] } if(pulse_out!=nil)
  end
  pulse_cnt
end

def part_2
  circuit = get_circuit(data)
  # find the inputs that drive the conjunction that drives 'rx'
  watch = circuit.values.find { |v| v.outputs[0] == :rx }[:inputs]
  cycles = {}
  (1..).find { |i|
    pulse_cnt = push_button(circuit, {})
    # record the cycle that each conjunction input flop receives a low pulse,
    # since the flops can only toggle their state on low pulses
    watch.each { |k,v| cycles[k] = i if(cycles[k]==nil && pulse_cnt[k][0]>0) }
    # quit when we have found a low pulse on every flop towards the final conjunction
    watch.size == cycles.size
  }
  cycles.values.reduce(1) { |acc, i| acc.lcm(i) }
end
