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
