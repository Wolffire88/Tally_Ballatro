function id_to_rank(rank)
    if rank <= 10 then return rank end
    if rank > 10 and rank < 14 then return 10 end
    if rank == 14 then return 1 end
end

function is_in_table(table, item)
    for _, t in ipairs(table) do
        if item == t then
            return true
        end
    end

    return false
end