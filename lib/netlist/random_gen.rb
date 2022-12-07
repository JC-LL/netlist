module Netlist
  class RandomGen
    def generate params={}
      nb_inputs =(params[:min_nb_inputs]..params[:max_nb_inputs]).to_a.sample
      nb_outputs=(params[:min_nb_outputs]..params[:max_nb_outputs]).to_a.sample
      c=create_circuit_interface(params[:name],nb_inputs,nb_outputs)
      params[:nb_comp].times do |i|
        nb_inputs =(params[:min_nb_inputs]..params[:max_nb_inputs]).to_a.sample
        nb_outputs=(params[:min_nb_outputs]..params[:max_nb_outputs]).to_a.sample
        comp=create_circuit_interface("comp_#{i}",nb_inputs,nb_outputs)
        c << comp
      end
      magic_connect(c,params)
      return c
    end

    def create_circuit_interface name,nb_inputs,nb_outputs
      c=Circuit.new(name)
      for j in 0..nb_inputs-1
        c << Port.new("i#{j}",:in)
      end
      for j in 0..nb_outputs-1
        c << Port.new("o#{j}",:out)
      end
      c
    end

    def magic_connect(c,params)

      destinations=[]
      destinations << c.components.collect{|comp| comp.inputs.select{|input| input.fanin.size==0}}.flatten
      destinations << c.outputs
      destinations.flatten!
      c.inputs.each do |src|
        nb_cnx=(1..params[:max_fanout]-1).to_a.sample
        for cnx in 1..nb_cnx
          if destinations.any?
            dest=destinations.sample
            destinations.delete(dest)
          else
            # create a supplemental output for top level
            next_idx=c.outputs.size
            c << dest=Port.new("o#{next_idx}",:out)
          end
          src.to dest
        end
      end

      c.components.collect{|comp| comp.outputs}.flatten.each do |src|
        nb_cnx=(1..params[:max_fanout]-1).to_a.sample
        for cnx in 1..nb_cnx
          if destinations.any?
            dest=destinations.sample
            destinations.delete(dest)
          else
            # create a supplemental output for top level
            next_idx=c.outputs.size
            c << dest=Port.new("o#{next_idx}",:out)
            # and connect it
          end
          src.to dest
        end
      end
    end
  end
end
