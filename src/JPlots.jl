using Plots

function setPlotBackend(backend::String)
    if backend == "JS"
        Plots.plotlyjs()
    else 
        if backend == "GR"
            Plots.gr()
        else
            throw(ArgumentError("Please select JS or GR."))
        end
    end
end

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

function plotGrid(geometry::Geometry)
    if geometry.griddim == 1
        return scatter(
            geometry.cells.centers[:,1],
            ones(geometry.cells.numberOf,1),
            xlabel = "Length (m)",
            grid = false,
            showaxis = :x,
            legend = false,
            markersize = 10,
            msc=:auto
            )
    end

    if geometry.griddim == 2
        return scatter(
            geometry.cells.centers[:,1],
            geometry.cells.centers[:,2],
            xlabel = "Length (m)",
            ylabel = "Width (m)",
            grid = false,
            showaxis = :xy,
            legend = false,
            markersize = 8,
            msc=:auto
            )
    end

    if geometry.griddim == 3
        return scatter(
            geometry.cells.centers[:,1],
            geometry.cells.centers[:,2], 
            geometry.cells.centers[:,3],
            xlabel = "Length (m)",
            ylabel = "Width (m)",
            zlabel = "Depth (m)",
            grid = false,
            showaxis = :xyz,
            legend = false,
            markersize = 6,
            msc=:auto
            )
    end
end

function plotHeatmap(geometry::Geometry, heatmapProperty::Array)

    size(geometry.cells.centers)[1] ≠ size(heatmapProperty)[1] && throw(ArgumentError("Geometry and Property sizes are inconsistent ()"))

    if geometry.griddim == 1
        return scatter(
            geometry.cells.centers[:,1],
            ones(geometry.cells.numberOf,1),
            marker_z=heatmapProperty, 
            marker=:rect,
            xlabel = "Length (m)",
            grid = false,
            showaxis = :x,
            legend = false,
            markersize = 10,
            msc=:auto
            )
    end

    if geometry.griddim == 2
        return scatter(
            geometry.cells.centers[:,1],
            geometry.cells.centers[:,2],
            marker_z=heatmapProperty, 
            marker=:rect,
            xlabel = "Length (m)",
            ylabel = "Width (m)",
            grid = false,
            showaxis = :xy,
            legend = false,
            markersize = 8,
            msc=:auto
            )
    end

    if geometry.griddim == 3
        return scatter(
            geometry.cells.centers[:,1],
            geometry.cells.centers[:,2], 
            geometry.cells.centers[:,3],
            marker_z=heatmapProperty, 
            marker=:rect,
            xlabel = "Length (m)",
            ylabel = "Width (m)",
            zlabel = "Depth (m)",
            grid = false,
            showaxis = :xyz,
            legend = false,
            markersize = 6,
            msc=:auto
            )
    end
end