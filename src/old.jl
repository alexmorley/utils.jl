####### WARNING NONE OF THESE FUNCTIONS ARE TESTED & SOME ARE VERY OLD! ########

nan2zero!(arr) = arr[isnan(arr)] = zero(eltype(arr))

"""
	dict2workspace{S<:Any}(dict::Dict{S, Any})
Pop key,value pairs into the workspace.
"""
function dict2workspace{S<:Any}(dict::Dict{S, Any}, evalmodule::Module=Main)
    for (k,v) in dict
        key2workspace(k,v, evalmodule)
    end
end

function key2workspace(k,v,evalmodule)
     eval(evalmodule,:($(Symbol(k))=$v))
end

function key2workspace(k::Symbol,evalmodule)
    eval(evalmodule,:($k=$v))
end

import Base.DataFmt: readdlm_string, invalid_dlm
"""
	getmeminfo()
Returns (in MB) A tuple of containing:
	- Memory(total, used, buffer, available)
	- Swap(total, used, free)
"""
function getmeminfo()
    memstats = readdlm_string(readstring(`free -m`),invalid_dlm(Char), Int, '\n', true, Dict())
    return Tuple{Array{Int,1},Array{Int,1}}((memstats[2,[2;3;6;7]], memstats[3,[2;3;4]]))
end


"""
Get sliding windows across an axis
"""
sliding_windows(len,wlen,step)= [x:x+wlen for x in 1:step:len-wlen]


### Check for file & return errormessage
function checkforfile(filename, errormessage="$filename not found")
	if !isfile(filename)
		error(errormessage)
		return false
	else
		return true
	end
end

## Get an example key from a dictionary
function getakey(dictionary::Dict)
	a = AbstractString{}
	for i in keys(dictionary); a = i; end
	a
end

###Convert a BitArray to a Integer Array (only 2-d currently)
function bit2intarray(::Type{Array{Int64,2}}, x::BitArray{2})
	xReal = zeros(Int,size(x))
	for (ind,j) in enumerate(x)
		if j
			xReal[ind] = 1
		end
	end
	xReal
end


## These functions generate random numbers fast!
### Borrowed from http://stackoverflow.com/questions/32248918/efficient-way-of-generating-random-integers-within-a-range-in-julia
function lcg(old) 
	a = unsigned(2862933555777941757)
	b = unsigned(3037000493)
	a*old + b
end

function randfast(k, x::UInt)
	x = lcg(x)
	1 + rem(x, k) % Int, x
end

## To generate N random numbers within a range R
function random_generator(N, R)
	state = rand(UInt)
	if N==1
		x,state = randfast(R, state)
	else x = zeros(Int,N)
		for i = 1:N
			x[i], state = randfast(R, state)
		end
	end
	return x
end


# Interpolate around a "value" using a moving average of "width"
## towards the value starting from "around" points either side
## i.e. value is the index where the centre of the interpolation
## will take place
function interpolatearoundvalue!{T<:Real}(vector::Array{T, 1}, value, around, width)
	for i in value-around:value
		vector[i] = mean(vector[i-width:i])
	end
	for i in value:value+around
		vector[i] = mean(vector[i:i+width])
	end
end

function interpolatearoundvalue!{T<:Real}(array::Array{T, 2}, value, around, width)
	for ind in 1:size(array,2)
		for i in value-around:value
			array[i,ind] = mean(array[i-width:i,ind])
		end
		for i in value:value+around
			array[i,ind] = mean(array[:,ind][i:i+width])
		end
	end
end

function dimmeansnan(array)
	otherdim = size(array, 1)
	outarray = zeros(otherdim)
	for i in 1:otherdim
		temp = array[i,:]
		outarray[i] = mean(temp[!isnan(temp)])
	end
	outarray
end


function catamap(temp)
	for i in 1:size(temp,1)-1
		temp[i+1] = vcat(temp[i], temp[i+1])
	end
	temp[end]
end
function mapandcatdict(dict, key2get)
	temp = map(x -> x[key2get], values(dict))
	catamap(temp)
end

# Get mean across a dimension ignoring NaNs
notnanplus(a, b) = isnan(b) ? a : a+b
notnancount(a, b) = a + !isnan(b)
function nanmean(A, region)
	s = reducedim(notnanplus, A, region, zero(eltype(A)))
	n = reducedim(notnancount, A, region, 0)
	s ./ n
end


znorm(x,dims) = (x .- mean(x,dims))./ std(x, dims)
