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

function tb_federman_effect(card, j1, j2, context)
    -- Federman cannot copy itself or it ends the universe
    local ret1 = j1 and j1 ~= card and SMODS.blueprint_effect(card, j1, context)
    local ret2 = j2 and j2 ~= card and SMODS.blueprint_effect(card, j2, context)

    if ret1 then 
        ret1.colour = G.C.GREY 
    end
    if ret2 then 
        ret2.colour = G.C.GREY
    end

    if ret1 then
        if ret2 then
            return SMODS.merge_effects({ ret1, ret2 })      -- i hate merge effects
        else
            return ret1
        end
    elseif ret2 then
        return ret2
    end
end