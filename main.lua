--- STEAMODDED HEADER
--- MOD_NAME: Taylatro
--- MOD_ID: Taylatro
--- MOD_AUTHOR: [Kevin & Dom]
--- MOD_DESCRIPTION: Complete Balatro overhaul... TAYLATRO. Inspired by Twitch.tv/Taylien (Game now emits strong odor)
--- PREFIX: TYN
----------------------------------------------
------------MOD CODE -------------------------

--LOGO--
local logo = "logo.png"

SMODS.Atlas{
    key="balatro",
    path= logo,
    px=333,
    py=216,
    prefix_config = {key = false}
}

--SKINS--

SMODS.Atlas{key = "cards_1", path="8BitDeck.png", px=71, py=95, prefix_config = {key = false} }
SMODS.Atlas{key = "cards_2", path="8BitDeck_opt2.png", px=71, py=95, prefix_config = {key = false} }
SMODS.Atlas{key = "centers", path="Enhancers.png", px=71, py=95, prefix_config = {key = false}}
SMODS.Atlas{key = "Joker", path= "Jokers.png", px=71, py=95, prefix_config = {key = false}}
SMODS.Atlas{key = "shop_sign", path = "ShopSignAnimation.png", px=113, py= 57, prefix_config = {key= false}, atlas_table = 'ANIMATION_ATLAS', frames = 4 }

--SOUNDS--
SMODS.Sound{key='metalPipe', path = 'metalpipe.ogg'}
SMODS.Sound{key='fart', path = 'fart.ogg'}
SMODS.Sound{key='BOOM', path = 'BOOM.ogg'}
SMODS.Sound{key= 'mlem', path = 'MLEM.ogg'}


--JOKERS--
SMODS.Atlas{
    key = 'Jokers',
    path = 'Joker.png',
    px = 71,
    py = 95
}




SMODS.Joker{
    key = 'pipeJoker',
    loc_txt = {
        name = 'PIPE',
        text = {
            "{C:green}1 in 5{} chance for",
            "{X:red,C:white} X10 {} Mult"
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            X_mult = 10,
            odds = 5
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {G.GAME.probabilities.normal, card.ability.extra.odds}
        } 
    end,
    
    calculate = function(self,card,context)
 

        if context.joker_main then 
            if pseudorandom('pipeJoker') < G.GAME.probabilities.normal/card.ability.extra.X_mult then
                return{
                    Xmult_mod = card.ability.extra.X_mult,
                    message = 'X' .. card.ability.extra.X_mult,
                    sound = 'TYN_metalPipe',
                    colour = G.C.MULT,
                }
            end
        end
    end
}

SMODS.Joker{
    key = 'fartJoker',
    loc_txt = {
        name = 'Toilet Seat',
        text = {
            "{C:green}1 in 5{} chance for",
            "{C:chips}+200{C:inavtive} Chips"
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 0, y = 0},
    config = { 
        extra = {
            chips = 200,
            odds = 5
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {G.GAME.probabilities.normal, card.ability.extra.odds}
        } 
    end,
    
    calculate = function(self,card,context)
 

        if context.joker_main then 
            if pseudorandom('fartJoker') < G.GAME.probabilities.normal/card.ability.extra.X_mult then
                return{
                    chip_mod = card.ability.extra.chips,
                    message = '+' .. card.ability.extra.chips,
                    sound = 'TYN_fart',
                    colour = G.C.MULT,
                }
            end
        end
    end
}

--Watermelon Joker 1 in X chance to explode, +10 cumulative chips every hand--
SMODS.Joker{
    key = 'waterMelonJoker',
    loc_txt = {
        name = 'Ticking Time Bomb',
        text = {
            "Gains {C:chips}+10{} chips for every hand played",
            "{C:green} #4# in #2# {} chance for Joker to explode",
            "Currently {C:chips}+#3#{C:inavtive} Chips"
        }
    },
    atlas = 'Jokers',
    rarity = 2,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 2, y = 0},
    config = { 
        extra = {
            odds = 100,
            chips = 0,
            mod = 10,
            numerator = 1,
            numerator_mod = 1
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.chips, card.ability.extra.numerator}
        } 
    end,
    
    calculate = function(self,card,context)
 
        if context.joker_main then 
            if pseudorandom('watermelon') < card.ability.extra.numerator/card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("TYN_BOOM")
                        card.T.r = -0.2
                        card:juice_up(0.3,0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true
                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil 

                                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_TYN_explodedJoker')
                                SMODS.Stickers['eternal']:apply(card, true)
                                card:add_to_deck()
                                G.jokers:emplace(card)
                                return true;
                            end
                        }))
                        return true 
                    end
                    --IGNORE THIS OLD CODE :P --
                    
                    --trigger = 'after',
                    --delay = 0.3,
                    --blockable = false,
                    --func = function()
                        --G.jokers:remove_card(card)
                        --card:remove()
                        --card = nil
                    
                        --local card = SMODS.add_card({key = 'j_TYN_explodedJoker', stickers = {"eternal"}})
                        --local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_TYN_explodedJoker')
                        --SMODS.Stickers['eternal']:apply(card, true)
                        --card:add_to_deck()
                        --G.jokers:emplace(card)
                        --return true;
                    --end
                }))
                return true
                --return {remove = true}
            end

            card.ability.extra.numerator = card.ability.extra.numerator + card.ability.extra.numerator_mod
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.mod

            return{
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                delay = 0.45,
                card = card,
                chip_mod = card.ability.extra.chips
            }
        end
    end
}


SMODS.Joker{
    key = 'explodedJoker',
    loc_txt = {
        name = 'Aftermath',
        text = {
            "Chunks of Watermelon now litter the room",
            "Cannot be sold or destroyed",
            "Scored Face cards gain Red Seal"
        }
    },
    atlas = 'Jokers',
    rarity = 3,
    cost = 10,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 3, y = 0},
    config = { 
        extra = {
            odds = 10,
            chips = 0,
            mod = 10
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {G.GAME.probabilities.normal, card.ability.extra.odds, card.ability.extra.chips}
        } 
    end,
    
    calculate = function(self,card,context)
 
        if context.joker_main then 
            
            if 0 < G.GAME.probabilities.normal/card.ability.extra.odds then
                card:juice_up(0.3,0.3)
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil
                        return true;
                    end
                }))
                return {sound = 'TYN_BOOM', remove = true}
            end

            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.mod

            return{
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                delay = 0.45,
                card = card,
                chip_mod = card.ability.extra.chips
            }
        end
    end,

    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return false
    end
}

-- Yoshi Joker, gives $7 when Three of a Kind 7s are played -- 
SMODS.Joker{
    key = 'yoshiJoker',
    loc_txt = {
        name = 'MLEM',
        text = {
            "When a {C:attention} Three of a Kind {} is played containing {C:attention}#1#s{}",
            "Gives {C:attention}$#1#{}"
        }
    },
    atlas = 'Jokers',
    rarity = 1,
    cost = 3,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 4, y = 0},
    config = { 
        extra = {
            money = 7,
            rank = 7
            
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.money, card.ability.extra.rank}
        } 
    end,
    
    calculate = function(self,card,context)
        if context.cardarea == G.jokers and context.before and context.full_hand then
            local has_7 = false
            for i = 1, #context.full_hand do 
                if context.full_hand[i]:get_id() == 7 then
                    has_7 = true
                end
            end

            if context.scoring_name == 'Three of a Kind' and has_7 then
                return{
                    delay = 0.45,
                    sound = 'TYN_mlem',
                    message = "$" .. number_format(card.ability.extra.money), 
                    colour = G.C.MONEY
                }
            end
        end
    end
}


-----------------------------------------------------------
-----------------------MOD CODE END------------------------
----------------------Taylien-STINKS-----------------------
