module Netlist
  class Viewer
    def view circuit
      code=Code.new
      code << "# test"
      code << "digraph #{circuit.name} {"
      code.indent=2
      code << "graph [rankdir = LR];"

      circuit.ports.each do |dir,ports|
        ports.each do |port|
          code << "#{port.name}[shape=cds,xlabel=\"#{port.name}\"]"
        end
      end

      circuit.components.each do |component|
        inputs=component.ports[:in].map{|port| "<#{port.name}>#{port.name}"}.join("|")
        outputs=component.ports[:out].map{|port| "<#{port.name}>#{port.name}"}.join("|")
        fanin="{#{inputs}}"
        fanout="{#{outputs}}"
        label="{#{fanin}| #{component.name} |#{fanout}}"
        code << "#{component.name}[shape=record; style=filled;color=cadetblue; label=\"#{label}\"]"
      end

      circuit.ports[:in].each do |source|
        source.fanout.each do |sink|
          if circuit.ports.values.flatten.any?{|port| port==sink}
            sink_name=sink.name
          else # sub component
            instance_name=sink.circuit.name
            port_name=sink.name
            sink_name="#{instance_name}:#{port_name}"
          end
          code << "#{source.name} -> #{sink_name};"
        end
      end

      circuit.components.each do |component|
        component.ports[:out].each do |source|
          if circuit.ports.values.flatten.any?{|port| port==source}
            source_name=source.name
          else # sub component
            instance_name=source.circuit.name
            port_name=source.name
            source_name="#{instance_name}:#{port_name}"
          end

          source.fanout.each do |sink|
            if circuit.ports.values.flatten.any?{|port| port==sink}
              sink_name=sink.name
            else # sub component
              instance_name=sink.circuit.name
              port_name=sink.name
              sink_name="#{instance_name}:#{port_name}"
            end
            code << "#{source_name} -> #{sink_name};"
          end
        end
      end
      code.indent=0
      code << "}"
      puts code.finalize
      code.save_as "#{circuit.name}.dot",verbose=true
    end
  end
end
