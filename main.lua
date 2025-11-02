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
SMODS.Sound{key='levelUp', path = 'VegasLevelUp.ogg'}
SMODS.Sound{key='nuka', path = 'nuka.ogg'}
SMODS.Sound{key='burp', path = 'burp.ogg'}
SMODS.Sound{key='nukaburp', path = 'nukaburp.ogg'}
SMODS.Sound{key='case', path = 'case.ogg'}

--JOKERS ATLAS--
SMODS.Atlas{
    key = 'Jokers',
    path = 'Joker.png',
    px = 71,
    py = 95
}

--SMODS OPTIONS--
SMODS.current_mod.optional_features = function()
    return {
        retrigger_joker = true,
    }
end

SMODS.current_mod.optional_features = { retrigger_joker = true }

--dictionary--
v_dictionary = {
    pipActive = "ACTIVE!",
    pipInactive = "#3# Hands Remaining"
}

--JOKERS DOWN HERE BRUV--

--Pipe Joker 1 in 5 chance for x10 mult
SMODS.Joker{
    key = 'pipeJoker',
    loc_txt = {
        name = 'PIPE',
        text = {
            "{C:green, E:1}1 in 5{} chance for",
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
            if pseudorandom('pipeJoker') < G.GAME.probabilities.normal/card.ability.extra.odds then
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

--fart joker 1 in 5 chance +200 chips
SMODS.Joker{
    key = 'fartJoker',
    loc_txt = {
        name = 'Reverberation',
        text = {
            "{C:green, E:1}1 in 5{} chance for",
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
            if pseudorandom('fartJoker') < G.GAME.probabilities.normal/card.ability.extra.odds then
                return{
                    chip_mod = card.ability.extra.chips,
                    message = '+' .. card.ability.extra.chips,
                    sound = 'TYN_fart',
                    colour = G.C.CHIPS,
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
            "{C:green, E:1} #4# in #2#{} chance for Joker to {C:red, E:2}EXPLODE{}",
            "{C:inactive}(Currently{} {C:chips}+#3#{} {C:inactive}Chips){}"
        }
    },
    
    atlas = 'Jokers',
    rarity = 2,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
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
            return{
                message = '+'.. card.ability.extra.chips,
                colour = G.C.CHIPS,
                card = card,
                chip_mod = card.ability.extra.chips
            }
        end

        if context.before then 
            if pseudorandom('watermelon') < card.ability.extra.numerator/card.ability.extra.odds then
                G.E_MANAGER:add_event(Event({
                    func = function()
                        play_sound("TYN_BOOM")
                        card.T.r = -0.2
                        card:juice_up(0.3,0.4)
                        card.states.drag.is = true
                        card.children.center.pinch.x = true

                        for _, played_card in ipairs(context.full_hand or {}) do
                            if played_card and played_card.set_seal then
                                played_card:set_seal('Red')
                            end
                        end

                        G.E_MANAGER:add_event(Event({
                            trigger = 'after',
                            delay = 0.3,
                            blockable = false,
                            func = function()
                                G.jokers:remove_card(card)
                                card:remove()
                                card = nil 

                                local card = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_TYN_explodedJoker')
                                --SMODS.Stickers['eternal']:apply(card, true)
                                
                                card:add_to_deck()
                                G.jokers:emplace(card)
                                card:set_cost()
                                return true;
                            end
                        }))
                        return true 
                    end

                }))
                return true
                
            end

            card.ability.extra.numerator = card.ability.extra.numerator + card.ability.extra.numerator_mod
            card.ability.extra.chips = card.ability.extra.chips + card.ability.extra.mod

            return{
                message = 'Upgraded!',
                colour = G.C.CHIPS,
                delay = 0.45,
                card = card,
                --chip_mod = card.ability.extra.chips
            }
        end
    end
}


local setcost = Card.set_cost
function Card:set_cost()
    setcost(self)
    if self.config.center.key == 'explodedJoker' then
        self.sell_cost = -10 
    end 
end

local setcost = Card.set_cost
function Card:set_cost()
    setcost(self)
    if self.config.center.key == 'j_TYN_explodedJoker' then
        self.sell_cost = -40 
    end 
end

--EXPLODED JOKER :3
SMODS.Joker{
    key = 'explodedJoker',
    loc_txt = {
        name = 'Aftermath',
        text = {
            "Chunks of Watermelon now litter the room",
            "Pay someone to clean this shit up",
            "PepePoint"
        }
    },
    
    atlas = 'Jokers',
    rarity = 3,
    cost = 100,
    unlocked = true,
    discovered = false,
    blueprint_compat = false,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 3, y = 0},
    config = { 
        extra = {
            taystinks = 1
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.taystinks}
        } 
    end,

    in_pool = function(self,wawa,wawa2)
        --whether or not this card is in the pool, return true if it is, return false if its not
        return false
    end,
    


}

-- Yoshi Joker, gives $7 when Three of a Kind 7s are played -- 
SMODS.Joker{
    key = 'yoshiJoker',
    loc_txt = {
        name = 'Angel Numbers',
        text = {
            "When a {C:attention}Three of a Kind{} is played containing {C:attention}#1#s{}",
            "Gives {C:attention}$#1#{}",
            "Adds {C:attention}Lucky{} Enhancement to scored {C:attention}#1#s{}"
        }
    },
    
    atlas = 'Jokers',
    rarity = 1,
    cost = 4,
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
        if  context.cardarea == G.jokers and context.after and context.full_hand then
            
            local has_7 = false
            for i = 1, #context.full_hand do 
                if context.full_hand[i]:get_id() == 7 then
                    has_7 = true
                end
            end

            if context.scoring_name == 'Three of a Kind' and has_7 then
                
                for _, scored_card in ipairs(context.scoring_hand) do    
                    scored_card:set_ability(G.P_CENTERS.m_lucky, nil, true)
                end

                return{
                    delay = 0.45,
                    sound = 'TYN_mlem',
                    message = "$" .. number_format(card.ability.extra.money), 
                    dollars = card.ability.extra.money,
                    colour = G.C.MONEY
                    
                }
            end
        end
    end
}

-- Fallout Joker, gives a planet card of your most played hand, but only every x hands played. Hands needed increases every "level up"
SMODS.Joker{
    key = 'PipJoker',
    loc_txt = {
        name = 'Crawl Out From the Fallout',
        text = {
            "{C:planet}LEVELED UP!{}",
            "Gives {C:planet}Planet Card{} of most played {C:attention}Poker Hand{}",
            "for every {C:attention} #1#{} hands played",
            "{C:inactive} #4# {}"
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
    pos = {x = 5, y = 0},
    config = { 
        extra = {
            handsNeed = 3,
            handsCurrent = 0,
            handsLeft = 2,
            active = false
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.handsNeed, card.ability.extra.handsCurrent, card.ability.extra.handsLeft, localize{type = 'variable', key = (card.ability.extra.handsLeft == 0 and 'loyalty_active' or 'loyalty_inactive'),  vars = {card.ability.extra.handsLeft}}}} 
    end,
    
    calculate = function(self,card,context)
        if context.before and context.cardarea == G.jokers and not context.blueprint and not context.retrigger then
            
            card.ability.extra.handsCurrent = card.ability.extra.handsCurrent + 1
            card.ability.extra.handsLeft = card.ability.extra.handsLeft - 1

            if context.before and card.ability.extra.handsCurrent >= card.ability.extra.handsNeed then
                local temp = 0
                local hand = nil
                local planetKey = nil 

                for k, v in pairs(G.GAME.hands) do
                    if v.played > temp and v.visible then
                        temp = v.played
                        hand = k  
                    end
                end

                if hand then
                    for k, v in pairs(G.P_CENTER_POOLS.Planet) do
                        if v.config.hand_type == hand then
                            planetKey = v.key
                        end
                    end 
                end
                
                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    blockable = false,
                    delay = 0.3,
                    func = function()
                        local planet = create_card("Planet", G.consumeables, nil, nil, nil, nil, planetKey)
                        G.consumeables:emplace(planet)
                        return true;
                    end
                }))
                
                card.ability.extra.handsCurrent = 0

                if (card.ability.extra.handsNeed < 3) then
                    card.ability.extra.handsNeed = card.ability.extra.handsNeed + 1
                end
                
                card.ability.extra.handsLeft = card.ability.extra.handsNeed - 1
                card.ability.extra.active = false


                return{
                    
                    sound = 'TYN_levelUp',
                    message = 'Leveled Up!',
                    colour = G.C.PLANET

                }

            end

            if card.ability.extra.handsLeft == 0 then
                card.ability.extra.active = true 
                local eval = function(card) 
                    return(card.ability.extra.active == true)
                end
                juice_card_until(card, eval, true)
            end

        end
    end
}

--NUKA COLA BASE COMPLETE  -- TEST TEST TEST 
SMODS.Joker{
    
    key = 'nukaJoker',
    loc_txt = {
        name = 'Nuka Cola',
        text = {
            "{X:red,C:white} X2 {} Mult for every Nuka Cola Joker in possession", 
            "{C:green, E:1} 1 in #1#{} chance to add {C:red}CAPS{} (red seals) to random scored card",
            "{C:inactive}(Currently #4# Nuka Colas){}"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 1, y = 1},
    config = { 
        extra = {
            odds = 4,
            xmult = 2,
            nuka = 1
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.odds, card.ability.extra.nuka * GetNukaCount(), card.ability.extra.xmult, card.ability.extra.nuka}
        } 
    end,
    
    calculate = function(self,card,context)

        if context.cardarea == G.jokers and context.joker_main then

            local nukaCount = GetNukaCount()
            card.ability.extra.nuka = nukaCount
            if card.ability.extra.nuka >= 1 then
                return{
                    Xmult_mod = nukaCount * card.ability.extra.xmult,
                    message =  "X" .. card.ability.extra.xmult * nukaCount,
                    sound = "TYN_nukaburp",
                    colour = G.C.MULT 
                }
            else 
                return{true}
            end
        end

        if context.after and context.cardarea == G.jokers and not context.blueprint then
            
            if pseudorandom('cola') < G.GAME.probabilities.normal/card.ability.extra.odds then
                
                local target = pseudorandom_element(context.scoring_hand)
                

                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        target:set_seal("Red")
                        return true
                    end
                }))

                return{
                    message = "Upgraded",  
                }
            end

            return true

        end
    end
}

-- NUKA QUANTUM COMPLETE
SMODS.Joker{
    key = 'quantumJoker',
    loc_txt = {
        name = 'Nuka Quantum',
        text = {
            "{X:red,C:white} +5 {} Mult ",
            "{C:green, E:1} 1 in #1# {} chance to add Purple seal to random scored card",
            "Gain {X:red,C:white} X0.5 {} Mult for every Purple seal added",
            "{C:inactive}(Currently{} {X:red,C:white}X#3#{} {C:inactive}Mult){}"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 0, y = 1},
    config = { 
        extra = {
            odds = 5,
            mult = 5,
            x_mult = 1,
            x_multMod = 0.5
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.odds, G.GAME.probabilities.normal, card.ability.extra.x_mult, card.ability.extra.x_multMod}
        } 
    end,
    
    calculate = function(self,card,context)
        if context.joker_main then
            return{
                mult_mod = card.ability.extra.mult,
                message = '+' .. card.ability.extra.mult .. "  X" .. card.ability.extra.x_mult,
                Xmult_mod = card.ability.extra.x_mult,
                sound = 'TYN_nukaburp',
                colour = G.C.MULT,
            }
        end

        if context.after and context.cardarea == G.jokers and not context.blueprint then
            
            if pseudorandom('quantum') < G.GAME.probabilities.normal/card.ability.extra.odds then
                
                local target = pseudorandom_element(context.scoring_hand)
                

                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        target:set_seal("Purple")
                        return true
                    end
                }))

                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.x_multMod

                return{
                    message = "Upgraded",  
                    colour = G.C.MULT,
                }
            end

            return{
                sound = 'TYN_nukaburp',
            }

        end
    end
}

--NUKA TWIST COMPLETE!!!!!!
SMODS.Joker{
    
    key = 'twistJoker',
    loc_txt = {
        name = 'Nuka Twist',
        text = {
            "{C:chips}+777{} Chips",
            "{C:green, E:1}1 in #2#{} chance to retrigger all Jokers"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 3,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 3, y = 1},
    config = { 
        extra = {
            chips = 777,
            odds = 7,
            reps = 1
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.chips, card.ability.extra.odds, G.GAME.probabilities.normal}
        } 
    end,
    
    calculate = function(self,card,context)
        if context.retrigger_joker_check and context.other_card and not context.retrigger_joker and context.other_card ~= self and context.other_card.config and context.other_card.config.key ~= self.key then
            if pseudorandom('twist') < G.GAME.probabilities.normal/card.ability.extra.odds then
                return{
                    message = 'AGAIN!',
                    sound = 'TYN_nukaburp',
                    repetitions = 1,
        
                }
            end
        end

        if context.joker_main then 
            return{
                chip_mod = card.ability.extra.chips,
                message = '+' .. card.ability.extra.chips,
                sound = 'TYN_nukaburp',
                colour = G.C.CHIPS,
            }
        end
    end
}

--NUKA VICTORY COMPLETE 
SMODS.Joker{
    
    key = 'victoryJoker',
    loc_txt = {
        name = 'Nuka Victory',
        text = {
            "All non face cards become {C:gold}GOLD{} cards when scored",
            "{C:green, E:1}1 in #1#{} chance to gain {X:red,C:white} X0.1 {} Mult", 
            "for every scored card turned {C:gold}GOLD{} that hand",
            "{C:inactive}(Currently{}  {X:red,C:white}X#2#{} {C:inactive}Mult){}"

        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 2,
    cost = 8,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 5, y = 1},
    config = { 
        extra = {
            odds = 5,
            xmult = 1,
            multMod = 0.1
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.odds, card.ability.extra.xmult, G.GAME.probabilities.normal}
        } 
    end,
    
    calculate = function(self,card,context)
        if context.before and not context.blueprint then
            local goldCount = 0
            for k, v in ipairs(context.scoring_hand) do
                if not v:is_face() then
                    if not (SMODS.has_enhancement(v, m_gold )) then
                        v:set_ability(G.P_CENTERS.m_gold, nil, true)
                        G.E_MANAGER:add_event(Event({
                            func = function()
                                v:juice_up()
                                return true
                            end
                        })) 
                        goldCount = goldCount + 0.1
                    end
                end
            end
            
            if pseudorandom('victory') < G.GAME.probabilities.normal/card.ability.extra.odds then 
                card.ability.extra.xmult = card.ability.extra.xmult + goldCount
                return{
                    message = 'UPGRADED!',
                    sound = 'TYN_nuka'
                }
            end

            if goldCount > 0 then
                return{
                    message = 'ENHANCED!',
                    sound = 'TYN_nuka'
                }
            end

        end


        if context.cardarea == G.jokers and context.joker_main and not context.blueprint then
            
            return{
                message = "X" .. card.ability.extra.xmult,
                Xmult_mod = card.ability.extra.xmult,
                sound = 'TYN_nukaburp',
                colour = G.C.MULT 
            }
            
        end
    end
}

--NUKA CHERRY COMPLETE
SMODS.Joker{
    
    key = 'cherryJoker',
    loc_txt = {
        name = 'Nuka Cherry',
        text = {
            "{X:red,C:white}X2{} Mult for every",
            "{C:red}Diamonds{} or {C:red}Hearts{} card scored",
            "{C:green, E:1}1 in #2#{} chance to retrigger",
            "{C:red}Diamonds{} or {C:red}Hearts{} cards"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 4, y = 1},
    config = { 
        extra = {
            xmult = 2,
            odds = 3,
            repetitions = 0
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.xmult, card.ability.extra.odds, G.GAME.probabilities.normal, card.ability.extra.repetitions}
        } 
    end,
    
    calculate = function(self,card,context)


        if context.before then
            if (pseudorandom("cherry") < G.GAME.probabilities.normal/card.ability.extra.odds) then
                card.ability.extra.repetitions = card.ability.extra.repetitions + 1
                
                return{
                    message = "AGAIN!"
                }
            end
        end

        if context.repetition then 
            if context.cardarea == G.play then
                if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
                    return{
                        --message = "AGAIN!",
                        repetitions = card.ability.extra.repetitions,
                        card = card
                    }
                end
            end
        end

        if context.individual then 
            if context.cardarea == G.play then
                if context.other_card:is_suit("Hearts") or context.other_card:is_suit("Diamonds") then
                    return{
                        Xmult_mod = card.ability.extra.xmult,
                        message = 'X' .. card.ability.extra.xmult,
                        sound = 'TYN_nukaburp',
                        colour = G.C.MULT,
                    }
                end
            end
        end

        if context.after then
            card.ability.extra.repetitions = card.ability.extra.repetitions - card.ability.extra.repetitions
        end
    end
}

--NUKA GRAPE COMPLETE
SMODS.Joker{
    
    key = 'grapeJoker',
    loc_txt = {
        name = 'Nuka Grape',
        text = {
            "{X:red,C:white} X2 {} Mult for every",
            "{C:blue}Spades{} or {C:blue}Clubs{} card scored",
            "{C:green, E:1}1 in #2#{} chance to retrigger",
            "{C:blue}Spades{} or {C:blue}Clubs{} cards"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 3,
    cost = 6,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 6, y = 1},
    config = { 
        extra = {
            xmult = 2,
            odds = 3
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.xmult, card.ability.extra.odds, G.GAME.probabilities.normal}
        } 
    end,
    
    calculate = function(self,card,context)


        if context.before then
            
            if (pseudorandom("grape") < G.GAME.probabilities.normal/card.ability.extra.odds) then
                card.ability.extra.repetitions = card.ability.extra.repetitions + 1
                
                
                return{
                    message = "AGAIN!"
                }
            end
        end

        if context.repetition then 
            if context.cardarea == G.play then
                if context.other_card:is_suit("Clubs") or context.other_card:is_suit("Spades") then
                    return{
                        message = "AGAIN!",
                        repetitions = card.ability.extra.repetitions,
                        card = card
                    }
                end
            end
        end

        if context.individual then 
            if context.cardarea == G.play then
                if context.other_card:is_suit("Clubs") or context.other_card:is_suit("Spades") then
                    return{
                        Xmult_mod = card.ability.extra.xmult,
                        message = 'X' .. card.ability.extra.xmult,
                        sound = 'TYN_nuka',
                        colour = G.C.MULT,
                    }
                end
            end
        end

        if context.after then
            card.ability.extra.repetitions = card.ability.extra.repetitions - card.ability.extra.repetitions
            --local reps = card.ability.extra.repetitions
            --print(reps)
        end

    end
}

--NUKA QUARTZ COMPLETE
SMODS.Joker{
    
    key = 'quartzJoker',
    loc_txt = {
        name = 'Nuka Quartz',
        text = {
            "{C:green, E:1} 1 in #1# {} chance to enhance a random",
            "scored card into a {C:attention}Glass Card{}"
        }
    },

    atlas = 'Jokers',
    pools = { nuka = true},
    rarity = 1,
    cost = 4,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 2, y = 1},
    config = { 
        extra = {
            odds = 5
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.odds, G.GAME.probabilities.normal}
        } 
    end,
    
    calculate = function(self,card,context)
        if context.after and context.cardarea == G.jokers and not context.blueprint then
            
            if pseudorandom('quartz') < G.GAME.probabilities.normal/card.ability.extra.odds then 
                
                local target = pseudorandom_element(context.scoring_hand)

                G.E_MANAGER:add_event(Event({
                    func = function()
                        target:juice_up()
                        target:set_ability(G.P_CENTERS.m_glass)
                        return true
                    end
                }))

                return{
                    message = "ENHANCE!",
                    sound = 'TYN_nukaburp'
                }
            end 
        end
    end
}

-- Case Joker
SMODS.Joker{
    
    key = 'caseJoker',
    loc_txt = {
        name = 'Gambling Addiction',
        text = {
            "When holding both {C:attention}Gambling Addiction{}",
            "and {C:attention}Dingles Keys{} gain a random Joker",
            "{C:attention}Gambling Addiction{} and {C:attention}Dingles Keys{} are destroyed",
            "{C:chips}+50{} Chips when held alone"

        }
    },

    atlas = 'Jokers',
    pools = { case = true},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 6, y = 0},
    config = { 
        extra = {
            chips = 50,
            denOdds = 100,
            comOdds = 40,
            uncomOdds = 35,
            rareOdds = 15, 
            legOdds = 10,
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = card.ability.extra.chips, G.GAME.probabilities.normal, card.ability.extra.comOdds, card.ability.extra.uncomOdds, card.ability.extra.rareOdds, card.ability.extra.legOdds, card.ability.extra.denOdds} 
    end,
    
    --set_ability = function(self, card, initial, delay_sprites) card:set_edition('e_TYN_caseEdition', false, true) end,
    
    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                card:set_edition({ TYN_caseEdition = true }, true)
                return true
            end
        }))
    end,

    calculate = function(self,card,context)
        if context.buying_card and context.cardarea == G.jokers then
            
            local hasCase = confirmCase()
            local hasKey = confirmKey()
            card:set_edition('e_TYN_caseEdition', false, true)
            local rarity = 0
            local pull = pseudorandom('roll')
            

            if pull < (card.ability.extra.legOdds / card.ability.extra.denOdds) then
                rarity = 4
            elseif pull < ((card.ability.extra.legOdds / card.ability.extra.denOdds)+(card.ability.extra.rareOdds / card.ability.extra.denOdds)) then
                rarity = 1
            elseif pull < (((card.ability.extra.legOdds / card.ability.extra.denOdds)+(card.ability.extra.rareOdds / card.ability.extra.denOdds))+(card.ability.extra.uncomOdds / card.ability.extra.denOdds)) then
                rarity = 0.8
            else
                rarity = 0.7
            end
            
            

            if hasCase == 1 and hasKey == 1 then

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil 
                        play_sound('TYN_case')

                        local openedJoker = nil
                        delay = 3
                        if rarity == 4 then
                            openedJoker = create_card('Joker', G.jokers, true, nil, nil, nil, nil, nil) 
                        else 
                            openedJoker = create_card('Joker', G.jokers, nil, rarity, nil, nil, nil, nil)
                        end
                                            
                        openedJoker:add_to_deck()
                        openedJoker:start_materialize()      
                        G.jokers:emplace(openedJoker)
                
                        return true;
                    end
                }))

                --G.jokers:remove_card('TYN_caseJoker')
                
                --local openedJoker = create_card('Joker', G.jokers, nil, nil, nil, nil, 'j_TYN_explodedJoker')
                --G.jokers:emplace(openedJoker)
                return{
                    message = "Case Opened",
                    --sound = "TYN_case",
                    color = G.C.MULT
                }
            end
        end
        
        if context.joker_main then 
            return{
                message = '+'.. card.ability.extra.chips,
                colour = G.C.CHIPS,
                card = card,
                chip_mod = card.ability.extra.chips
            }
        end
    end
}

-- Key Joker
SMODS.Joker{
    
    key = 'keyJoker',
    loc_txt = {
        name = 'Dingles Keys',
        text = {
            "When holding both {C:attention}Gambling Addiction{}",
            "and {C:attention}Dingles Keys{} gain a random Joker",
            "{C:attention}Gambling Addiction{} and {C:attention}Dingles Keys{} are destroyed",
            "{C:chips}+50{} Chips when held alone"

        }
    },

    atlas = 'Jokers',
    pools = { key = true},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 7, y = 0},
    config = { 
        extra = {
            chips = 50     
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = card.ability.extra.chips, G.GAME.probabilities.normal}  
    end,
    
    --set_ability = function(self, card, initial, delay_sprites) card:set_edition('e_TYN_caseEdition', false, true) end,

    set_ability = function(self, card, initial, delay_sprites)
        G.E_MANAGER:add_event(Event({
            func = function()
                card:set_edition({ TYN_caseEdition = true }, true)
                return true
            end
        }))
    end,
    
    calculate = function(self,card,context)
        if context.buying_card and context.cardarea == G.jokers then
            local hasCase = confirmCase()
            local hasKey = confirmKey()
            card:set_edition('e_TYN_caseEdition', false, true)
            if hasCase == 1 and hasKey == 1 then

                G.E_MANAGER:add_event(Event({
                    trigger = 'after',
                    delay = 0.3,
                    blockable = false,
                    func = function()
                        card:start_dissolve({G.C.RED}, nil, 1.6)
                        G.jokers:remove_card(card)
                        card:remove()
                        card = nil 
                        return true;
                    end
                }))
            end
        end

        if context.joker_main then 
            return{
                message = '+'.. card.ability.extra.chips,
                colour = G.C.CHIPS,
                card = card,
                chip_mod = card.ability.extra.chips
            }
        end
    end
}

-- BLood God
SMODS.Joker{
    
    key = 'bloodJoker',
    loc_txt = {
        name = 'Blood Gods Offering',
        text = {
            "This Joker Gains {X:red,C:white}X0.1{}",
            "for every {C:red}Hearts{} card discarded",
            "Loses {X:red,C:white}X0.1{}",
            "For Every {C:red}Hearts{} card scored",
            "{C:inactive}(Currently{} {X:red,C:white}X#1#{} {C:inactive}Mult){}"
        }
    },

    atlas = 'Jokers',
    pools = { key = true},
    rarity = 1,
    cost = 5,
    unlocked = true,
    discovered = true,
    blueprint_compat = true,
    perishable_compat = true,
    eternal_compat = true,
    pos = {x = 7, y = 1},
    config = { 
        extra = {
            x_mult = 1,
            mod = 0.1    
        }
    },
    
    loc_vars = function(self, info_queue, card)
        return{vars = {card.ability.extra.x_mult, G.GAME.probabilities.normal, card.ability.extra.mod}
        }    
    end,

    
    calculate = function(self,card,context)
        local heartCount = 0
        if context.discard and not context.other_card.debuff then
            if context.other_card:is_suit('Hearts') and not context.blueprint then
                card.ability.extra.x_mult = card.ability.extra.x_mult + card.ability.extra.mod
                heartCount = heartCount + card.ability.extra.mod
            else
                return nil
            end

            if heartCount > 0 then
                return{
                    message = '+' .. heartCount,
                    colour = G.C.MULT
                }
            end
        end

        if context.individual then 
            if context.cardarea == G.play then
                if context.other_card:is_suit("Hearts") then
                    if card.ability.extra.x_mult > 1 then
                        card.ability.extra.x_mult = card.ability.extra.x_mult - card.ability.extra.mod
                        return{
                            message = '-' .. card.ability.extra.mod,
                            colour = G.C.MULT 
                        }
                    end
                end
            end
        end

        if context.joker_main then 
            return{
                Xmult_mod = card.ability.extra.x_mult,
                message = 'X' .. card.ability.extra.x_mult,
                colour = G.C.MULT,
            }
        end
    end
}

--nuka check--
function GetNukaCount()
    local nuka_count = 0
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do 
            local card = G.jokers.cards[i]
            local center = (type(card) == "string" and G.P.CENTERS[card]) or (card.config and card.config.center)
            if center and center.pools and center.pools.nuka then
                nuka_count = nuka_count + 1
            end
        end
    end
    return nuka_count
end

-- Key and Cases --
function confirmKey()
    local key = 0
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            local card = G.jokers.cards[i]
            local center = (type(card) == "string" and G.P.CENTERS[card]) or (card.config and card.config.center)
            if center and center.pools and center.pools.key then
                key = key + 1 
            end
        end
    end
    return key
end

function confirmCase()
    local case = 0
    if G.jokers and G.jokers.cards then
        for i = 1, #G.jokers.cards do
            local card = G.jokers.cards[i]
            local center = (type(card) == "string" and G.P.CENTERS[card]) or (card.config and card.config.center)
            if center and center.pools and center.pools.case then
                case = case + 1 
            end
        end
    end
    return case
end

--editions--
SMODS.Edition({
    key = 'caseEdition',
    loc_txt = {
        name = 'Case & Key',
        label = 'Case & Key',
        text = {'+1 Joker Slot'}
    },

    shader = false,
    config = {card_limit = 1},
    discovered = true,
    unlocked = true,
    in_shop = false,
    in_pool = false,
    weight = 0,
    extra_cost = 1,
    apply_to_float = true,
    loc_vars = function(self)
        return {vars = {self.config.card_limit}}
    end
})

-----------------------------------------------------------
-----------------------MOD CODE END------------------------
----------------------Taylien-STINKS-----------------------
