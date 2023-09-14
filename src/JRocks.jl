function randomRock(initialNumber, range, len, dimensions; numberOfPossibleSteps = 3, expCoef = 1)

    len != prod(dimensions) && throw(ArgumentError("Number of cells and dimensions are inconsistent \nNumber of Cells \eq $len \nX×Y×Z: $(prod(dimensions))"))

    if prod(size(dimensions)) == 1
        result = fill(initialNumber, len, 1)

        rangeVectorLin = collect(-1:2/(numberOfPossibleSteps-2+1):1)
        rangeVectorSign = round.(rangeVectorLin, RoundFromZero)
        rangeVector = (abs.(rangeVectorLin).^expCoef).*(range/2).*rangeVectorSign

        println(rangeVector)

        for i in 1:len
            result[i] = result[i] + rangeVector[rand(1:length(rangeVector))]
        end

        return result
    end

    if prod(size(dimensions)) == 2
        result = fill(initialNumber, dimensions[1], dimensions[2])

        rangeVectorLin = collect(-1:2/(numberOfPossibleSteps-2+1):1)
        rangeVectorSign = round.(rangeVectorLin, RoundFromZero)
        rangeVector = (abs.(rangeVectorLin).^expCoef).*(range/2).*rangeVectorSign

        println(rangeVector)

        for i in 1:size(result)[1]
            for j in 1:size(result)[2]
                result[i,j] = result[i, j] + rangeVector[rand(1:length(rangeVector))]
            end
        end

        return result
    end

#=     if prod(size(dimensions)) == 3
        result = []
        rangeVector = (collect(-1:2/(numberOfPossibleSteps-2+1):1).^nat2odd(expCoef)).*(range/2)
        println(rangeVector)
        push!(result, initialNumber)

        for i in 1:(len-1)
            push!(result, result[i]+rangeVector[rand(1:length(rangeVector))])
        end
        return result
    end =#

    throw(ArgumentError("Incorrect number of dimensions. Value must be 1, 2 or 3."))

end

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