#=

Definitions of rocks

=#

mutable struct Rock
    permeability::Array{Float64}
    porosity::Array{Float64}
    function Rock(geometry::Geometry, permeability::Array, porosity::Number)
        perm = ones(geometry.cells.numberOf, 1)*permeability*9.869233e-13

        poro = ones(geometry.cells.numberOf, 1)*porosity

        new(perm, poro)
    end
    function Rock(geometry::Geometry, permeability::Array, porosity::Number, porosityRange::Number; numberOfPossibleSteps = 3, expCoef = 1)
        perm = ones(geometry.cells.numberOf, 1)*permeability*9.869233e-13

        rangeVectorLin = collect(-1:2/(numberOfPossibleSteps-2+1):1)
        rangeVectorSign = round.(rangeVectorLin, RoundFromZero)
        rangeVector = (abs.(rangeVectorLin).^expCoef).*(porosityRange/2).*rangeVectorSign
        
        poro = rand(rangeVector .+ porosity, geometry.cells.numberOf, 1)

        new(perm, poro)
    end
end