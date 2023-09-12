function randomWalk(number, range, len, smoothness)
    result = []
    rangeVector = collect(-range/2:range/smoothness:range/2)

    push!(result, number)

    for i in 1:(len-1)
        push!(result, result[i]+rangeVector[rand(1:length(rangeVector))])
    end
    return result
end

mutable struct Rock
    permeability::Array{Float64}
    porosity::Array{Float64}
    function Rock(geometry::Geometry, permeability::Array, porosity::Number)
        perm = ones(geometry.cells.numberOf, 1)*permeability*9.869233e-13
        poro = ones(geometry.cells.numberOf, 1)*porosity
        new(perm, poro)
    end
    function Rock(geometry::Geometry, permeability::Array, porosity::Number; porosityRange::Number, porosityIncrement::Number)
        perm = ones(geometry.cells.numberOf, 1)*permeability*9.869233e-13
        poro = rand((porosity - porosityRange):(porosityIncrement):(porosity + porosityRange), geometry.cells.numberOf, 1)*porosity
        new(perm, poro)
    end
end