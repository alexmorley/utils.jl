# Base
import Base.nextpow
function nextpow2(bins::T) where T<:AbstractRange
    eT = eltype(bins)
    newend = eT(bins.step)*(Base.nextpow(2,length(bins)))

    return bins[1]:eT(bins.step):newend
end
function nextpow(power::Int, bins::T) where T<:AbstractRange
    eT = eltype(bins)
    newend = eT(bins.step)*(Base.nextpow(power,length(bins)))
    return bins[1]:eT(bins.step):newend
end
@deprecate nextpow2 nextpow

## Base - Arrays & Iterators
function slicedimview(A::AbstractArray, d::Integer, i)
    d >= 1 || throw(ArgumentError("dimension must be ≥ 1"))
    nd = ndims(A)
    d > nd && (i == 1 || throw_boundserror(A, (ntuple(k->Colon(),nd)..., ntuple(k->1,d-1-nd)..., i)))
    view(A,Base.setindex(axes(A), i, d)...)
end

unzip(a) = map(x->getfield.(a, x), fieldnames(eltype(a)))
function flatten(X::Array{A,1}) where A <: Array{Z} where Z
    V = Array{Z}(undef, sum(length.(X)))
    st = 1
    for x in X
        lx = length(x)
        V[st:st+lx-1] .= x
        st += lx
    end
    return V
end  

@inline function allequal(x::AbstractArray)
    isempty(x) && error("Equality Undefined for empty arrays")
	length(x)  < 2 && return true
    e1 = x[1]
    i = 2
    @inbounds for i=2:length(x)
        x[i] == e1 || return false
    end
    return true
end

using LinearAlgebra
"""
	offdiagind(M::AbstractArray, k::Int=0)
Get indicies not on k-th diagonal of an array.
"""
offdiagind(M::AbstractArray, k::Int=0) = setdiff(LinearIndices(M),diagind(M,k))

"""
	offdiag(x::AbstractArray)
Get all values in array not on the main diagonal.
"""
offdiag(x::AbstractArray) = Base.unsafe_getindex(x,utils.offdiagind(x))

"""
	function rotatexy(x::AbstractVector,y::AbstractVector,θ::Real)	
Rotate a set of x and y co-ordinationes by θ degrees.
"""		
function rotatexy(x::AbstractVector,y::AbstractVector,θ::Real)
    θ = deg2rad(θ)
    rot = [cos(θ) -sin(θ);
           sin(θ) cos(θ)]
    x2,y2 = (rot*[x y]') |> x->(x[1,:],x[2,:])
    return x2,y2
end

function rotatexy(xy::AbstractArray,θ::Real)
    θ = deg2rad(θ)
    rot = [cos(θ) -sin(θ);
           sin(θ) cos(θ)]
    return rot*xy
end

### find
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
    _check_length(n, length(X)) && return collect(LinearIndices(X))
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
    _check_length(n, length(X)) && return collect(LinearIndices(X))
	x = copy(X)
    inds = zeros(Int64,n)
    min = typemax(eltype(X))
    for i in 1:n
        _,inds[i] = findmin(x)
        x[inds[i]] = min
    end
    return inds
end
