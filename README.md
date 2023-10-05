# JRSP (Copyright (c) 2023 Julian F. R. V. Silveira)

JRSP is a package of tools for application in reservoir simulation, authored primarily by Dr. Julian F. R. V. Silveira.

**Table of Contents:**
1. [License](#license)
1. [Overview of Contents](#overview-of-contents)
1. [Usage](#usage)
1. [Background References](#background-references)

## License

Permission is hereby granted, free of charge, to any person obtaining a copy
of this software and associated documentation files (the "Software"), to deal
in the Software without restriction, including without limitation the rights
to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
copies of the Software, and to permit persons to whom the Software is
furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all
copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
SOFTWARE.

(MIT License)

## Overview of Contents

## Usage

For general use, clone the repository, enter package mode (press "]") and activate the current environment:

```jl
julia> 
(@vX.X) pkg> activate .
```

For general use, include the JRSP module:

```jl
using JRSP
```

For use during development, it is advised to include the main module alongside "Revise":

```jl
using Revise
using JRSP
```

To deactivate the environment, run the activate command with no arguments:

```jl
julia> 
(@vX.X) pkg> activate
```

## Background References
