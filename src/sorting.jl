export bubble_sort!, bubble_sort_perm

function bubble_sort_pass!(v::AbstractVector)
    issorted = true
    for i in 1:(length(v)-1)
        if v[i] > v[i+1]
            v[i],v[i+1]=v[i+1],v[i]
            issorted = false
        end
    end
    return issorted
end

function bubble_sort!(v::AbstractVector)
    issorted = false
    while !issorted
        issorted = bubble_sort_pass!(v)
    end
    v
end

function bubble_sort_pass!(v::AbstractVector, fixed::AbstractVector)
    length(fixed) == length(v) || error("v and fixed must be the same length")
    issorted = true
    for i in 1:(length(v)-1)
        x,nxt = i,i+1
        ready = false
        while !ready
            nxt > length(v) && break
            if v[x] > v[nxt]
                if fixed[x] | fixed[nxt]
                    nxt = nxt+=1
                    continue
                end
                v[x],v[nxt]  = v[nxt],v[x]
                issorted = false
                ready = true
            else
                ready = true
            end
        end
    end
    return issorted
end

function bubble_sort_perm_pass!(v::AbstractVector, fixed::AbstractVector, by::AbstractVector)
    length(fixed) == length(v) || error("v and fixed must be the same length")
    issorted = true
    for i in 1:(length(v)-1)
        x,nxt = i,i+1
        ready = false
        while !ready
            nxt > length(v) && break            
            if by[x] > by[nxt]
                if fixed[x] | fixed[nxt]
                    nxt = fixed[nxt] ? nxt+=1 : nxt
                    x   = fixed[x]   ? x+=1   : x
                    continue
                end
                v[x],v[nxt]  = v[nxt],v[x]
                by[x],by[nxt]= by[nxt],by[x]
                issorted = false
                ready = true
            else
                ready = true
            end
        end
    end
    return issorted
end

function bubble_sort!(v::AbstractVector, fixed::AbstractVector)
    issorted = false
    while !issorted
        issorted = bubble_sort_pass!(v,fixed)
    end
    v
end

function bubble_sort_perm(v::AbstractVector, fixed::AbstractVector,perm = collect(1:length(v)))
    issorted = false
    v2 = copy(v)
    while !issorted
        issorted = bubble_sort_perm_pass!(perm,fixed,v2)
    end
    perm
end
