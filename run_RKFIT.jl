using Distributed
using JLD2
using Printf
using SparseArrays
using LinearAlgebra
using Pardiso

do_serial = false
do_warmup = true

# Set up BLAS threading
@everywhere begin
    using SparseArrays, LinearAlgebra, Pardiso
    BLAS.set_num_threads(1)
end

function run_rba(xi, K, M, Q, f_complex; use_pmap=true, batch_size=1)
    # Distribute problem data
    @everywhere f_complex = $f_complex
    @everywhere K = $K
    @everywhere M = $M
    @everywhere Q = $Q

    # Prepare one solver per worker
    @everywhere begin
        ps_worker = MKLPardisoSolver()
        set_matrixtype!(ps_worker, Pardiso.COMPLEX_SYM)
        set_nprocs!(ps_worker, 1)
        Pardiso.pardisoinit(ps_worker)

        function solve_xi_prepared(xi_i)
            u = similar(f_complex)
            u .= Pardiso.solve(ps_worker, (K - xi_i * M), f_complex)
            return Q * u
        end
    end

    if use_pmap
        return pmap(solve_xi_prepared, xi; batch_size=batch_size)
    else
        chunks = collect(Iterators.partition(xi, cld(length(xi), nworkers())))
        futures = [@spawnat w map(solve_xi_prepared, chunks[i]) for (i, w) in enumerate(workers())]
        return reduce(vcat, fetch.(futures))
    end
end

# Load input data
data = load("discretization_3d_10ohmm.jld2")
K, M, f, b, Q = data["K"], data["M"], data["f"], data["b"], data["Q"]
f_complex = complex.(f)

# Load poles and residuals for mhat=38, w=5/2, and t in (1e-6, 1e-3)
res, xi = get_poles(; scaling=1e-3, w="52", m=38)
np = length(xi)

times = 1e-3 .* exp10.(range(-3, 0, 31))

@info "Running RKFIT RBA with $np poles using $(nworkers()) workers."

# Serial baseline
if do_serial
    @info "Running serial reference..."
    t1 = time()
    sol_serial = map(xi_i -> begin
            ps = MKLPardisoSolver()
            set_matrixtype!(ps, Pardiso.COMPLEX_SYM)
            set_nprocs!(ps, 1)
            Pardiso.pardisoinit(ps)
            u = similar(f_complex)
            u .= Pardiso.solve(ps, (K - xi_i * M), f_complex)
            Q * u
        end, xi)
    @info "Serial time: $(time() - t1) sec."
end

if do_warmup
    # Parallel with pmap
    @info "Warmup Running with pmap..."
    t1 = time()
    sol_pmap = run_rba(xi, K, M, Q, f_complex; use_pmap=true, batch_size=2)
    @info "Warmup pmap time: $(time() - t1) sec."
end

# Parallel with pmap
@info "Running with pmap..."
t1 = time()
sol_pmap = run_rba(xi, K, M, Q, f_complex; use_pmap=true, batch_size=2)
@info "pmap time: $(time() - t1) sec."


# Store result
A = 2 * real(hcat(sol_pmap...) * res)
jldsave("transient.jld2"; times, A)
