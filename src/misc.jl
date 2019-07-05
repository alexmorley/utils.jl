# indexing
export setindex, addindex

@generated function setindex(x::NamedTuple,y,v::Val)
    k = first(v.parameters)
    k ∉ x.names ? :x : :( (x..., $k=y) )
end

@generated function addindex(x::NamedTuple,y,v::Val)
    k = first(v.parameters)
    :( (x..., $k=y) )
end

# git
function get_hash(dir::AbstractString)
    read(`git -C $dir rev-parse --short HEAD`, String) |> strip
end

# Conversions
mmtoin(x::Real) = x/25.399986284
intomm(x::Real) = x*25.399986284

# Rounding
roundup(x,n)   = round(x,digits=n) >= x ? round(x,digits=n) : round(x+1/(10^n),digits=n)
rounddown(x,n) = round(x,digits=n) <= x ? round(x,digits=n) : round(x+1/(10^n),digits=n)

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
function wavedec2d(clips::Array{T,2}, wavtype = WT.haar) where T<:AbstractFloat
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

# Math
from_choose(n,k) = factorial(n)/(factorial(k)*factorial(n-k))

# NaN Math
using NaNMath; const nm = NaNMath
nanmaximum(x) = nm.maximum(x)
nanminimum(x) = nm.minimum(x)

nan2zero!(arr) = arr[isnan.(arr)] .= zero(eltype(arr))

nans(x) = (z = similar(x); fill!(z,NaN))

nanmap(f,x,args...;kwargs...) = f(filter(!isnan,x),args...,kwargs...)

function nanmapslices(f,x,args...;dims=1, kwargs...)
    function f2(x_slice)
        x_slice_nonan = filter(!isnan, x_slice)
        f(x_slice_nonan, args..., kwargs...)
    end
    mapslices(f2, x, dims=dims)
end
