export findnmax, findnmin
export zscore_base
export nanfilt!, nanfilt, nanmaximum, nanminimum, nan2zero!
export twodresample

# Base
import Base.nextpow2
function nextpow2(bins::T) where T<:Range
    eT = eltype(bins)
    newend = eT(bins.step)*(nextpow2(length(bins)))
    return bins[1]:eT(bins.step):newend
end

function slicedimview(A::AbstractArray, d::Integer, i)
    d >= 1 || throw(ArgumentError("dimension must be ≥ 1"))
    nd = ndims(A)
    d > nd && (i == 1 || throw_boundserror(A, (ntuple(k->Colon(),nd)..., ntuple(k->1,d-1-nd)..., i)))
    view(A,Base.setindex(indices(A), i, d)...)
end

## find
function _check_length(n::Int, lX::Int)
	if n > lX
		error("n > length(X)")
	elseif n == lX
		return true
	end
	return false
end


"""
	findnmax(X::AbstractArray, n::Int)
Finds `n`-largest elements in array `X`.
"""
function findnmax(X::AbstractArray, n::Int)
    _check_length(n, length(X)) && return X[:]
	x = copy(X)
    inds = zeros(Int64,n)
    min = typemin(eltype(X))
    for i in 1:n
        _,inds[i] = findmax(x)
        x[inds[i]] = min
    end
    return inds
end

function findnmin(X::AbstractArray, n::Int)
    _check_length(n, length(X)) && return X[:]
	x = copy(X)
    inds = zeros(Int64,n)
    min = typemax(eltype(X))
    for i in 1:n
        _,inds[i] = findmin(x)
        x[inds[i]] = min
    end
    return inds
end

# StatsBase
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

# IMAGES
using Images

function nanfilt!(v::Vector,σ)
    nans = .!(isnan.(v))
    v = view(v,  findfirst(nans):findlast(nans))
    imfilter!(v, v, KernelFactors.IIRGaussian([σ]))
end

function nanfilt(v::Vector,σ)
    t = copy(v)
    nanfilt!(t, σ)
    return t
end

function imfilter_gaussian(img, sigma; kwargs...)
    imfilter(img,
        KernelFactors.IIRGaussian(sigma; kwargs...))
end

# DSP
using DSP

function twodresample(mat, rate, fs=1250)
    out = zeros(floor(Int, size(mat,1)*rate), size(mat,2))
    for i in 1:size(mat,2)
        out[:,i] = resample(mat[:,i],rate)
    end
    floor(Int, fs*rate), out
end

# Wavelets
using Wavelets
function wavedec2d{T<:AbstractFloat}(clips::Array{T,2},
                   wavtype = WT.haar)
    # level of wavelet transform
    wt = wavelet(wavtype)
    N = floor(Int,log2(size(clips,2)))
    # intialise array
    components_all = zeros(clips)
    for i in 1:size(components_all,1)
        components_all[i,:] = dwt(clips[i,:], wt, N)
    end
    return components_all::Array{T,2}
end

# NaN MATH
using NaNMath; const nm = NaNMath
nanmaximum(x) = nm.maximum(x)
nanminimum(x) = nm.minimum(x)

nan2zero!(arr) = arr[isnan.(arr)] .= zero(eltype(arr))

nans(x) = (z = similar(x); fill!(z,NaN))
