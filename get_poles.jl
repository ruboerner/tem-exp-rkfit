function get_poles(; scaling=1e-3, w="52", n="38")
    
    fn = "rat" * n * "w" * w * ".jld2"
    
    ratw = load(fn)
    res = ratw["res"]
    xi = ratw["xi"]

    res = res[1:2:end, :]
    xi = xi[1:2:end]

    # Rescaling
    scl = scaling
    xi ./= scl
    res ./= scl

    return xi, res
end