using Flexpart.FlexpartOptions
using Flexpart
using Test

fpdir = FlexpartDir()
fpoptions = FlexpartOption(fpdir)

@testset "Access and change option values" begin
    @test fpoptions["COMMAND"][:COMMAND][:LDIRECT].value == "1"
    @test fpoptions["RELEASES"][:RELEASE][:ZKIND].value == "1"
    fpoptions["COMMAND"][:COMMAND][:LDIRECT] = "0"
    @test fpoptions["COMMAND"][:COMMAND][:LDIRECT].value == "0"
    fpoptions["RELEASES"][:RELEASE][:COMMENT] = "foo"
end

@testset "Add suboptions to option groups" begin
    newrel = deepcopy(fpoptions["RELEASES"][:RELEASE][1])
    @test newrel[:COMMENT].value == "foo"
    newrel[:COMMENT] = "bar"
    @test fpoptions["RELEASES"][:RELEASE][:COMMENT].value == "foo"
    push!(fpoptions["RELEASES"][:RELEASE], newrel)
    @test length(fpoptions["RELEASES"][:RELEASE]) == 2
end

@testset "merge!" begin
    outgrid = Flexpart.area2outgrid([50., 4., 48., 5.,], 0.05)
    merge!(fpoptions["OUTGRID"][:OUTGRID], outgrid)
    @test fpoptions["OUTGRID"][:OUTGRID][:OUTLAT0].value == 48.0 
end

@testset "Write options" begin
    Flexpart.write(fpoptions)
end
