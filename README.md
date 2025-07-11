# tem-exp-rkfit: Fast Parallel Transient Electromagnetic Modelling using a Uniform-in-Time Approximation to the Exponential

This repository contains all code, data, and instructions necessary to reproduce the results presented in the *Geophysical Journal International* article:

**"Fast parallel transient electromagnetic modelling using a uniform-in-time approximation to the exponential"**  
Authors: Ralph-Uwe Börner, Stefan Güttel 
submitted to GJI, in revision (as of July 2025)

---

## Overview

We propose a novel method for computing transient electromagnetic (TEM) responses using a uniform-in-time rational approximation to the matrix exponential. The method is based on RKFIT and allows for efficient parallel computation.

---

## Repository Structure

- `src/` — Julia source files implementing the forward solver and rational approximation
- `scripts/` — Scripts to reproduce each figure and table in the paper

---

## Getting Started

### 1. Clone the repository

```bash
git clone https://github.com/yourusername/tem-exp-rkfit.git
cd tem-exp-rkfit
```

Setup the Julia environment:
```julia
using Pkg
Pkg.activate(".")
Pkg.instantiate()
```

## License

This project is licensed under the MIT License. See the LICENSE file for details.

## Acknowledgements

We thank the Geophysical Journal International reviewers and editor for their valuable feedback, and gratefully acknowledge the open-source Julia ecosystem that made this work possible.
