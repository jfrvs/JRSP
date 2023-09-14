using Plots
gr()

function convertFromVectorTo123D(data::Array, dimensions::Array)

    prod(size(data)) != prod(dimensions) && throw(ArgumentError("Number of data points and dimensions are inconsistent \nNumber of Data Points \eq $(prod(size(data))) \nX×Y×Z: $(prod(dimensions))"))

    if prod(size(dimensions)) == 1
        return reshape(data, dimensions[1], 1, 1)
    end

    if prod(size(dimensions)) == 2
        return reshape(data, dimensions[1], dimensions[2], 1)
    end

    if prod(size(dimensions)) == 3
        return reshape(data, dimensions[1], dimensions[2], dimensions[3])
    end

end