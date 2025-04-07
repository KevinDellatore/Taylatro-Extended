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

--SOUNDS--
SMODS.Sound{key='metalPipe', path = 'metalpipe.ogg'}
SMODS.Sound{key='fart', path = 'fart.ogg'}


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
            "{X:red,C:white} X5 {} Mult"
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
    pos = {x = 1, y = 0},
    config = { 
        extra = {
            X_mult = 5,
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
            "{X:red,C:white} X5 {} Mult"
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
            X_mult = 5,
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
                    Xmult_mod = card.ability.extra.X_mult,
                    message = 'X' .. card.ability.extra.X_mult,
                    sound = 'TYN_fart',
                    colour = G.C.MULT,
                }
            end
        end
    end
}
-----------------------------------------------------------
-----------------------MOD CODE END------------------------
----------------------Taylien-STINKS-----------------------
