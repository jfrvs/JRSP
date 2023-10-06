#=

Definitions of grids in 1, 2 and 3 dimensions.

=#

mutable struct Cells
    numberOf::Int64
    facePos::Array{Int64}
    index::Array{Int64}
    faces::Array{Int64}
    volumes::Array{Float64}
    centers::Array{Float64}
end

mutable struct Faces
    numberOf::Int64
    nodePos::Array{Int64}
    neighbors::Array{Int64}
    tags::Array{Int64}
    nodes::Array{Int64}
    areas::Array{Float64}
    normals::Array{Float64}
    centers::Array{Float64}
end

mutable struct Nodes
    numberOf::Int64
    coords::Array{Float64}
end

mutable struct Geometry
    cells::Cells
    faces::Faces
    nodes::Nodes
    dimensions::Array{Int}
    type::Array{String}
    griddim::Int
    function Geometry(xReplicas::Int, xSize::Float64)
        ########## Basic Definitions ##########

        griddim = 1
        type = ["tensorGrid" "cartGrid" "computeGeometry"]
        dimensions = [xReplicas]

        ################ Nodes ################
        
        # Number of nodes
        numberOfNodes = xReplicas + 1

        # Node coordinates
        nodeCoordinates = collect(0:(xSize/xReplicas):xSize)

        # Nodes Constructor
        nodes = Nodes(numberOfNodes, nodeCoordinates)
        #=
        println(nodes.numberOf)
        println(nodes.coords)
        =#

        ################ Cells ################

        # Number of cells
        numberOfCells = xReplicas

        # Cell index
        cellIndex = collect(1:numberOfCells)

        # facePos (Indirection map of size [num+1,1] into the ‘cells.faces’ array)
        facePos = collect(1:2:(numberOfCells + 1)*2)

        # Number of faces
        numberOfFacesX = xReplicas + 1
        numberOfFaces = numberOfFacesX

        FX = reshape(1:numberOfFacesX, (xReplicas + 1))
        F1 = reshape(FX[1:(xReplicas), :, :], (1, :)) # W == 1
        F2 = reshape(FX[2:(xReplicas + 1), :, :], (1, :)) # E == 2
        cellFaces = hcat(reshape([F1; F2], (1,:))', kron(ones(1, numberOfCells), [1 2])')

        # Cell volume
        cellVolume = ones(numberOfCells, 1).*(xSize/xReplicas)

        # Cell centers' coordinates
        cellCenters = (0 + xSize/2xReplicas):(xSize/xReplicas):(xSize - xSize/2xReplicas)

        # Cells Constructor
        cells = Cells(numberOfCells, facePos, cellIndex, cellFaces, cellVolume, cellCenters)
        #=
        println(cells.numberOf)
        println(cells.facePos)
        println(cells.index)
        println(cells.faces)
        println(cells.volumes)
        println(cells.centers)
        =#

        ################ Faces ################

        # nodePos? not clear
        nodePos = collect(1:(numberOfFaces + 1))

        # Neighbors array, not clear

        faceNeighbors = [collect(0:numberOfCells) circshift(collect(0:numberOfCells), -1)]

        # tag vector
        faceTag = zeros(numberOfFaces, 1)

        # Nodes, not clear
        faceNodes = collect(1:numberOfFaces)

        # Face areas
        faceAreas = ones(numberOfFaces,1)

        # Face normals, not clear
        faceNormals = ones(numberOfFaces, 1)

        # Face centers
        faceCenters = (0):(xSize/xReplicas):(xSize)

        # Faces Constructor
        faces = Faces(numberOfFaces, nodePos, faceNeighbors, faceTag, faceNodes, faceAreas, faceNormals, faceCenters)
        #=
        println(faces.numberOf)
        println(faces.nodePos)
        println(faces.neighbors)
        println(faces.tags)
        println(faces.nodes)
        println(faces.areas)
        println(faces.normals)
        println(faces.centers)
        =#

        ############# Constructor #############

        new(cells, faces, nodes, dimensions, type, griddim)
    end
    function Geometry(xReplicas::Int, yReplicas::Int, xSize::Float64, ySize::Float64)
        ########## Basic Definitions ##########

        griddim = 2
        type = ["tensorGrid" "cartGrid" "computeGeometry"]
        dimensions = [xReplicas yReplicas]

        ################ Nodes ################
        
        # Number of nodes
        numberOfNodes = (xReplicas + 1)*(yReplicas + 1)

        # Node coordinates
        nodeCoordinates = []

        for j in 0:(ySize/yReplicas):ySize
            for i in 0:(xSize/xReplicas):xSize
                nodeCoordinates = vcat(nodeCoordinates, [i j])
            end
        end

        # Nodes Constructor
        nodes = Nodes(numberOfNodes, nodeCoordinates)
        #=
        println(nodes.numberOf)
        println(nodes.coords)
        =#

        ################ Cells ################

        # Number of cells
        numberOfCells = xReplicas*yReplicas

        # Cell index
        cellIndex = 1:numberOfCells

        # facePos (Indirection map of size [num+1,1] into the ‘cells.faces’ array)
        facePos = 1:4:(numberOfCells + 1)*4

        # Number of faces
        numberOfFacesX = (xReplicas + 1)*(yReplicas)
        numberOfFacesY = (xReplicas)*(yReplicas + 1)
        numberOfFaces = numberOfFacesX + numberOfFacesY

        FX = reshape(1:numberOfFacesX, (xReplicas + 1), (yReplicas))
        FY = reshape((numberOfFacesX + 1):(numberOfFacesX + numberOfFacesY), (xReplicas), (yReplicas + 1))
        F1 = reshape(FX[1:(xReplicas), :, :], (1, :)) # W == 1
        F2 = reshape(FX[2:(xReplicas + 1), :, :], (1, :)) # E == 2
        F3 = reshape(FY[:, 1:(yReplicas), :], (1, :)) # S == 3
        F4 = reshape(FY[:, 2:(yReplicas + 1), :], (1, :)) # N == 4
        cellFaces = hcat(reshape([F1; F3; F2; F4], (1,:))', kron(ones(1, numberOfCells), [1 3 2 4])')

        # Cell volume
        cellVolume = ones(numberOfCells, 1)*(xSize/xReplicas)*(ySize/yReplicas)

        # Cell centers' coordinates
        cellCenters = []

        for j in 0:(ySize/yReplicas):(ySize - ySize/yReplicas)
            for i in 0:(xSize/xReplicas):(xSize - xSize/xReplicas)
                cellCenters = vcat(cellCenters, [(i + xSize/2xReplicas) (j + ySize/2yReplicas)])
            end
        end

        # Cells Constructor
        cells = Cells(numberOfCells, facePos, cellIndex, cellFaces, cellVolume, cellCenters)
        #=
        println(cells.numberOf)
        println(cells.facePos)
        println(cells.index)
        println(cells.faces)
        println(cells.volumes)
        println(cells.centers)
        =#

        ################ Faces ################

        # nodePos? not clear
        nodePos = 1:2:(numberOfFaces + 1)*2

        # Neighbors array, not clear
        C = zeros((xReplicas + 2), (yReplicas + 2))
        C[2:(xReplicas + 1), 2:(yReplicas + 1)] = reshape(1:(xReplicas*yReplicas), (xReplicas, yReplicas))
        NX1 = reshape(C[1:(xReplicas + 1), 2:(yReplicas + 1)], (:,1));
        NX2 = reshape(C[2:(xReplicas + 2), 2:(yReplicas + 1)], (:,1));
        NY1 = reshape(C[2:(xReplicas + 1), 1:(yReplicas + 1)], (:,1));
        NY2 = reshape(C[2:(xReplicas + 1), 2:(yReplicas + 2)], (:,1));
        faceNeighbors = [NX1 NX2; NY1 NY2]
        #

        # tag vector
        faceTag = zeros(numberOfFaces, 1)
        #

        # Nodes, not clear
        N = reshape(1:(xReplicas + 1)*(yReplicas + 1), (xReplicas + 1), (yReplicas + 1))
        NFX1 = reshape(N[1:(xReplicas + 1), 1:(yReplicas)], (1, :))
        NFX2 = reshape(N[1:(xReplicas + 1), 2:(yReplicas + 1)], (1, :))
        NFY1 = reshape(N[1:(xReplicas), 1:(yReplicas + 1)], (1, :))
        NFY2 = reshape(N[2:(xReplicas + 1), 1:(yReplicas + 1)], (1, :))
        NFX = reshape([NFX1; NFX2], (:, 1));
        NFY = reshape([NFY2; NFY1], (:, 1));
        faceNodes = [NFX; NFY]
        #

        # Face areas
        areaX = (ySize/yReplicas)
        areaY = (xSize/xReplicas)
        faceAreas = [ones(numberOfFacesX,1)*areaX; ones(numberOfFacesY,1)*areaY]
        #

        # Face normals, not clear
        faceNormals = zeros(numberOfFaces, 2)
        faceNormals[1:numberOfFacesX, 1] = ones(numberOfFacesX,1)*areaX
        faceNormals[(numberOfFacesX + 1):(numberOfFacesX + numberOfFacesY), 2] = ones(numberOfFacesY,1)*areaY
        #

        # Face centers
        faceCenters = []

        xCenters = unique(cellCenters[:,1])
        yCenters = unique(cellCenters[:,2])

        for j in yCenters
            for i in 0:(xSize/xReplicas):xSize
                faceCenters = vcat(faceCenters, [i j])
            end
        end


        for j in 0:(ySize/yReplicas):ySize
            for i in xCenters
                faceCenters = vcat(faceCenters, [i j])
            end
        end

        # Faces Constructor
        faces = Faces(numberOfFaces, nodePos, faceNeighbors, faceTag, faceNodes, faceAreas, faceNormals, faceCenters)
        #=
        println(faces.numberOf)
        println(faces.nodePos)
        println(faces.neighbors)
        println(faces.tags)
        println(faces.nodes)
        println(faces.areas)
        println(faces.normals)
        println(faces.centers)
        =#

        ############# Constructor #############

        new(cells, faces, nodes, dimensions, type, griddim)

    end
    function Geometry(xReplicas::Int, yReplicas::Int, zReplicas::Int, xSize::Float64, ySize::Float64, zSize::Float64)
        ########## Basic Definitions ##########

        griddim = 3
        type = ["tensorGrid" "cartGrid" "computeGeometry"]
        dimensions = [xReplicas yReplicas zReplicas]

        ################ Nodes ################
        
        # Number of nodes
        numberOfNodes = (xReplicas + 1)*(yReplicas + 1)*(zReplicas + 1)

        # Node coordinates
        nodeCoordinates = []
        for k in 0:(zSize/zReplicas):zSize
            for j in 0:(ySize/yReplicas):ySize
                for i in 0:(xSize/xReplicas):xSize
                    nodeCoordinates = vcat(nodeCoordinates, [i j k])
                end
            end
        end

        # Nodes Constructor
        nodes = Nodes(numberOfNodes, nodeCoordinates)
        #=
        println(nodes.numberOf)
        println(nodes.coords)
        =#

        ################ Cells ################

        # Number of cells
        numberOfCells = xReplicas*yReplicas*zReplicas

        # Cell index
        cellIndex = 1:numberOfCells

        # facePos (Indirection map of size [num+1,1] into the ‘cells.faces’ array)
        facePos = 1:6:(numberOfCells + 1)*6

        # Number of faces
        numberOfFacesX = (xReplicas + 1)*(yReplicas)*(zReplicas)
        numberOfFacesY = (xReplicas)*(yReplicas + 1)*(zReplicas)
        numberOfFacesZ = (xReplicas)*(yReplicas)*(zReplicas + 1)
        numberOfFaces = numberOfFacesX + numberOfFacesY + numberOfFacesZ

        FX = reshape(1:numberOfFacesX, (xReplicas + 1), (yReplicas), (zReplicas))
        FY = reshape((numberOfFacesX + 1):(numberOfFacesX + numberOfFacesY), (xReplicas), (yReplicas + 1), (zReplicas))
        FZ = reshape((numberOfFacesX + numberOfFacesY + 1):(numberOfFacesX + numberOfFacesY + numberOfFacesZ), (xReplicas), (yReplicas), (zReplicas + 1))
        F1 = reshape(FX[1:(xReplicas), :, :], (1, :)) # W == 1
        F2 = reshape(FX[2:(xReplicas + 1), :, :], (1, :)) # E == 2
        F3 = reshape(FY[:, 1:(yReplicas), :], (1, :)) # S == 3
        F4 = reshape(FY[:, 2:(yReplicas + 1), :], (1, :)) # N == 4
        F5 = reshape(FZ[:, :, 1:(zReplicas)], (1, :)) # T == 5
        F6 = reshape(FZ[:, :, 2:(zReplicas + 1)], (1, :)) # B == 6
        cellFaces = hcat(reshape([F1; F2; F3; F4; F5; F6], (1,:))', kron(ones(1, numberOfCells), [1 2 3 4 5 6])')

        # Cell volume
        cellVolume = ones(numberOfCells, 1)*(xSize/xReplicas)*(ySize/yReplicas)*(zSize/zReplicas)

        # Cell centers' coordinates
        cellCenters = []
        for k in 0:(zSize/zReplicas):(zSize - zSize/zReplicas)
            for j in 0:(ySize/yReplicas):(ySize - ySize/yReplicas)
                for i in 0:(xSize/xReplicas):(xSize - xSize/xReplicas)
                    cellCenters = vcat(cellCenters, [(i + xSize/2xReplicas) (j + ySize/2yReplicas) (k + zSize/2zReplicas)])
                end
            end
        end

        # Cells Constructor
        cells = Cells(numberOfCells, facePos, cellIndex, cellFaces, cellVolume, cellCenters)
        #=
        println(cells.numberOf)
        println(cells.facePos)
        println(cells.index)
        println(cells.faces)
        println(cells.volumes)
        println(cells.centers)
        =#

        ################ Faces ################

        # nodePos? not clear
        nodePos = 1:4:(numberOfFaces + 1)*4

        # Neighbors array, not clear
        C = zeros((xReplicas + 2), (yReplicas + 2), (zReplicas + 2))
        C[2:(xReplicas + 1), 2:(yReplicas + 1), 2:(zReplicas + 1)] = reshape(1:(xReplicas*yReplicas*zReplicas), (xReplicas, yReplicas, zReplicas))
        NX1 = reshape(C[1:(xReplicas + 1), 2:(yReplicas + 1), 2:(zReplicas + 1)], (:,1));
        NX2 = reshape(C[2:(xReplicas + 2), 2:(yReplicas + 1), 2:(zReplicas + 1)], (:,1));
        NY1 = reshape(C[2:(xReplicas + 1), 1:(yReplicas + 1), 2:(zReplicas + 1)], (:,1));
        NY2 = reshape(C[2:(xReplicas + 1), 2:(yReplicas + 2), 2:(zReplicas + 1)], (:,1));
        NZ1 = reshape(C[2:(xReplicas + 1), 2:(yReplicas + 1), 1:(zReplicas + 1)], (:,1));
        NZ2 = reshape(C[2:(xReplicas + 1), 2:(yReplicas + 1), 2:(zReplicas + 2)], (:,1));
        faceNeighbors = [NX1 NX2; NY1 NY2; NZ1 NZ2]
        #

        # tag vector
        faceTag = zeros(numberOfFaces, 1)
        #

        # Nodes, not clear
        N = reshape(1:(xReplicas + 1)*(yReplicas + 1)*(zReplicas + 1), (xReplicas + 1), (yReplicas + 1), (zReplicas + 1))
        NFX1 = reshape(N[1:(xReplicas + 1), 1:(yReplicas), 1:(zReplicas)], (1, :))
        NFX2 = reshape(N[1:(xReplicas + 1), 2:(yReplicas + 1), 1:(zReplicas)], (1, :))
        NFX3 = reshape(N[1:(xReplicas + 1), 2:(yReplicas + 1), 2:(zReplicas + 1)], (1, :))
        NFX4 = reshape(N[1:(xReplicas + 1), 1:(yReplicas), 2:(zReplicas + 1)], (1, :))
        NFY1 = reshape(N[1:(xReplicas), 1:(yReplicas + 1), 1:(zReplicas)], (1, :))
        NFY2 = reshape(N[1:(xReplicas), 1:(yReplicas + 1), 2:(zReplicas + 1)], (1, :))
        NFY3 = reshape(N[2:(xReplicas + 1), 1:(yReplicas + 1), 2:(zReplicas + 1)], (1, :))
        NFY4 = reshape(N[2:(xReplicas + 1), 1:(yReplicas + 1), 1:(zReplicas)], (1, :))
        NFZ1 = reshape(N[1:(xReplicas), 1:(yReplicas), 1:(zReplicas + 1)], (1, :))
        NFZ2 = reshape(N[2:(xReplicas + 1), 1:(yReplicas), 1:(zReplicas + 1)], (1, :))
        NFZ3 = reshape(N[2:(xReplicas + 1), 2:(yReplicas + 1), 1:(zReplicas + 1)], (1, :))
        NFZ4 = reshape(N[1:(xReplicas), 2:(yReplicas + 1), 1:(zReplicas + 1)], (1, :))
        NFX = reshape([NFX1; NFX2; NFX3; NFX4], (:, 1));
        NFY = reshape([NFY1; NFY2; NFY3; NFY4], (:, 1));
        NFZ = reshape([NFZ1; NFZ2; NFZ3; NFZ4], (:, 1));
        faceNodes = [NFX; NFY; NFZ]
        #

        # Face areas
        areaX = (ySize/yReplicas)*(zSize/zReplicas)
        areaY = (xSize/xReplicas)*(zSize/zReplicas)
        areaZ = (xSize/xReplicas)*(ySize/yReplicas)
        faceAreas = [ones(numberOfFacesX,1)*areaX; ones(numberOfFacesY,1)*areaY; ones(numberOfFacesZ,1)*areaZ]
        #

        # Face normals, not clear
        faceNormals = zeros(numberOfFaces, 3)
        faceNormals[1:numberOfFacesX, 1] = ones(numberOfFacesX,1)*areaX
        faceNormals[(numberOfFacesX + 1):(numberOfFacesX + numberOfFacesY), 2] = ones(numberOfFacesY,1)*areaY
        faceNormals[(numberOfFacesX + numberOfFacesY + 1):(numberOfFacesX + numberOfFacesY + numberOfFacesZ), 3] = ones(numberOfFacesZ,1)*areaZ
        #

        # Face centers
        faceCenters = []

        xCenters = unique(cellCenters[:,1])
        yCenters = unique(cellCenters[:,2])
        zCenters = unique(cellCenters[:,3])

        for k in zCenters
            for j in yCenters
                for i in 0:(xSize/xReplicas):xSize
                    faceCenters = vcat(faceCenters, [i j k])
                end
            end
        end

        for k in zCenters
            for j in 0:(ySize/yReplicas):ySize
                for i in xCenters
                    faceCenters = vcat(faceCenters, [i j k])
                end
            end
        end

        for k in 0:(zSize/zReplicas):zSize
            for j in yCenters
                for i in xCenters
                    faceCenters = vcat(faceCenters, [i j k])
                end
            end
        end

        # Faces Constructor
        faces = Faces(numberOfFaces, nodePos, faceNeighbors, faceTag, faceNodes, faceAreas, faceNormals, faceCenters)
        #=
        println(faces.numberOf)
        println(faces.nodePos)
        println(faces.neighbors)
        println(faces.tags)
        println(faces.nodes)
        println(faces.areas)
        println(faces.normals)
        println(faces.centers)
        =#

        ############# Constructor #############

        new(cells, faces, nodes, dimensions, type, griddim)

    end
    function Geometry(xReplicas::Int)
        Geometry(xReplicas, Float64(xReplicas))
    end
    function Geometry(xReplicas::Int, yReplicas::Int)
        Geometry(xReplicas, yReplicas, Float64(xReplicas), Float64(yReplicas))
    end
    function Geometry(xReplicas::Int, yReplicas::Int, zReplicas::Int)
        Geometry(xReplicas, yReplicas, zReplicas, Float64(xReplicas), Float64(yReplicas), Float64(zReplicas))
    end
end