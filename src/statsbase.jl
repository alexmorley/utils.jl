using StatsBase

import StatsBase.zscore!
zscore!(X,dim::Tuple{Int64}) = begin
    d = dim[1]
    for i in indices(X,d)
        t = slicedimview(X, 2, i)
        t .= (t.-mean(t))./std(t)
    end
    X
end

zscore(X,dim::Tuple{Int64}) = begin
    Y = Float64.(X)
    zscore!(Y,dim)
    return Y
end

function zscore_base(X::Vector{T},inds) where T<:Real
    (X - mean(X[inds]))/std(X[inds])
end

function zscore_base(X::Array{T,N},inds,dim::Tuple{Int64}) where {T<:Real,N}
    Y = Float64.(X)
    zscore_base!(Y,inds,dim)
    return Y
end

function zscore_base!(X::Array{T,N},inds,dim::Tuple{Int64}) where {T<:Real,N}
    d = dim[1]
    for i in indices(X,d)
        t = slicedimview(X, 2, i)
        t .= (t.-mean(t[inds]))./std(t[inds])
    end
    X
end

function _bootstrap(f::Function, args...; nreps=100)
    μ   = f(args...)
    res = typeof(μ)[]
    lena = length(args[1])
    @assert all(lena .== length.(args))
    for _ in 1:nreps
        samples = sample(1:lena, lena; replace=true)
        args_bootstrap = [a[samples] for a in args]
        push!(res, f(args_bootstrap...))
    end
    return μ, res
end

"""
     bootstrap_confint(f::Function, args...; nreps=100, perc=95)
Bootstrap a function over multiple arguements *with the same length*.
Returns a three-tuple:
- mean (result of function on complete args)
- hi (\$perc'th percentile of results of function applied on re-sampled arguments)
- lo (1-\$perc'th percetile of results of function applied on re-sampled arguments)
"""
function bootstrap_confint(f::Function, args...; nreps=100, perc=95)
    μ,res = _bootstrap(f, args..., nreps=nreps)
    return μ, percentile(res,perc), percentile(res,100-perc)
end
