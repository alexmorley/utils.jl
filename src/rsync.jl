function rrsync(source, destination)
    run(`rsync $source $destination`)
end

function mnfsrsync(source::String, destination, user="data")
    rrsync(mnfs2rsync(source, destination, user)...)
end

function mnfsrsync{T}(source::Array{T,1}, destination, user="data")
	files = cat(2,mnfs2rsync.(source, [destination])...)
	tname = tempname()
	writedlm(tname,files[1,:])
	run(`rsync --progress --no-R --files-from $tname / $(files[2,1])`)
end	

function mnfs2rsync(source::String, destination, user="data")
    ssource = split(source, '/')
    sdest = split(destination, '/')
    if (ssource[2] == "mnfs") & (sdest[2] == "mnfs")
        error("Both source & destination paths cannot be remote")
    elseif ssource[2] == "mnfs"
        mnfspath = ssource; rev=true
    elseif sdest[2] == "mnfs"
        mnfspath = sdest; rev=false
    else
        warn("Both local paths")
        return [source, destination]
    end
    if isfile("/etc/auto.nfs")
        autonfs = readdlm("/etc/auto.nfs", use_mmap=false)
        server = split(autonfs[autonfs[:,1].==mnfspath[3],3][1],':')[1]
        server = split(server, '.')[1]
    else
        error("Need /etc/auto.nfs to resolve server location")
    end
    localpath = "/$(join(mnfspath[3:end], '/'))"
    rsyncpath = "$user@$server:/$localpath" 
    if rev
        return [rsyncpath, destination]
    else
        return [source, rsyncpath]
    end
end
