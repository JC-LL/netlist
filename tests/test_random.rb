require_relative "../lib/netlist.rb"

include Netlist

generator=RandomGen.new


params={
  :name => "test",
  :nb_comp => 100,
  :min_nb_inputs => 1,
  :max_nb_inputs => 5,
  :min_nb_outputs => 1,
  :max_nb_outputs => 3,
  :max_fanout => 6,
  :max_fanin => 1, # logical circuits !
}
puts circuit=generator.generate(params)

Viewer.new.view circuit
