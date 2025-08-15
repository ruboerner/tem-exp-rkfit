# tem-exp-rkfit: Fast Parallel Transient Electromagnetic Modelling using a Uniform-in-Time Approximation to the Exponential

This repository contains all code, data, and instructions necessary to reproduce the results presented in the *Geophysical Journal International* article:

**"Fast parallel transient electromagnetic modelling using a uniform-in-time approximation to the exponential"**  
Authors: Ralph-Uwe Börner, Stefan Güttel 
accepted for publication in GJI (as of August 2025)

---

## Overview

We propose a novel method for computing transient electromagnetic (TEM) responses using a uniform-in-time rational approximation to the matrix exponential. The method is based on RKFIT and allows for efficient parallel computation.

---


## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/ruboerner/tem-exp-rkfit.git
cd tem-exp-rkfit
```

Setup the Julia environment:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

### 2. Rn the example
In a shell, run
```shell
julia -p 40 run_RKFIT.jl
```

---

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

We thank the Geophysical Journal International reviewers and editor for their valuable feedback, and gratefully acknowledge the open-source Julia ecosystem that made this work possible.
