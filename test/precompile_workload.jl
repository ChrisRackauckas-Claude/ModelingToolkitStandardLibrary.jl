using ModelingToolkitStandardLibrary.Blocks
using ModelingToolkitBase: System, connect, equations, t_nounits as t
using Test

@testset "Precompile workload" begin
    constant = Constant(; name = :constant, k = 1.0)
    integrator = Integrator(; name = :integrator, x = 0.0)
    model = System(
        [connect(constant.output, integrator.input)],
        t;
        name = :model,
        systems = [integrator, constant]
    )

    @test model isa System
    @test !isempty(equations(model))
end
