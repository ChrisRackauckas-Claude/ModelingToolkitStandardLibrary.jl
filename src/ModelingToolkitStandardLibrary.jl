module ModelingToolkitStandardLibrary
import SymbolicUtils: unwrap
using ModelingToolkitBase: System, connect, t_nounits as t
using PrecompileTools: @compile_workload, @setup_workload

"""
  @symcheck J > 0 || throw(ArgumentError("Expected `J` to be positive"))
  
Omits the check expression if the argument `J` is symbolic.
"""
macro symcheck(ex)
    ex.args[1].head === :call ||
        error("Expected an expression on the form sym > val || error()")
    sym = ex.args[1].args[2]
    return quote
        _issymbolic(x) = !(unwrap(x) isa Real)
        _issymbolic($(esc(sym))) || ($(esc(ex)))
    end
end

include("Blocks/Blocks.jl")
include("Mechanical/Mechanical.jl")
include("Thermal/Thermal.jl")
include("Electrical/Electrical.jl")
include("Magnetic/Magnetic.jl")
include("Hydraulic/Hydraulic.jl")

@setup_workload begin
    constant = Blocks.Constant(; name = :constant, k = 1.0)
    integrator = Blocks.Integrator(; name = :integrator, x = 0.0)
    connections = [connect(constant.output, integrator.input)]

    @compile_workload begin
        System(connections, t; name = :model, systems = [integrator, constant])
    end
end

end
