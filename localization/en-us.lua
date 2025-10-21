return {
    descriptions = {
        Edition = {
            e_tb_zirconium = {
                name = "Zirconium",
                text = {
                    "{X:chips,C:white}X#1#{} chips"
                }
            }
        },

        Enhanced = {
            m_tb_mechanical = {
                name = "Mechanical Card",
                text = {
                    "{X:mult,C:white}X#1#{} mult when scored.",
                    "Increases by {X:mult,C:white}X#2#{}",
                    "when held in hand"
                }
            }
        },

        Spectral = {
            c_tb_ego = {
                name = "Ego",
                text = {
                    "Add {C:dark_edition}zirconium{} to",
                    "{C:attention}#1#{} selected card in hand",
                    "{C:green}#2# in #3#{} chance to",
                    "destroy selected card instead."
                }
            },

            c_tb_band = {
                name = "Band",
                text = {
                    "Applies a random {C:attention}Tie{}",
                    "to {C:attention}#1#{} selected card in hand."
                }
            },

            c_tb_hiatus = {
                name = "Hiatus",
                text = {
                    "Perminantly debuffs up to",
                    "{C:attention}#1#{} selected cards.",
                    "Gain {C:money}money{} equal to double the total",
                    "chip value of debuffed cards."
                }
            }
        },

        Tarot = {
            c_tb_cog = {
                name = "Cog",
                text = {
                    "Enhances {C:attention}#1#{} selected card",
                    "to a {C:attention}#2#{}"
                }
            },

            c_tb_doctorate = {
                name = "Doctorate",
                text = {
                    "Gain {C:money}$#1#{} for every",
                    "{C:attention}Tie{} held in hand.",
                    "Gain and additional {C:money}$#1#{}",
                    "if the {C:attention}Tie{} is a {C:blue}Blue Tie{}"
                }
            },

            c_tb_mashup = {
                name = "Mashup",
                text = {
                    "Merge two cards together.",
                    "The new card takes on the {C:spades}suit{} of the",
                    "{C:attention}left card{} and the {C:hearts}rank{} of the {C:attention}right card{}.",
                    "{C:attention}Enhancements/Seals/Editions{} carry",
                    "over on a priority basis."
                }
            }
        },

        Joker = {
            j_tb_joehawleyjoehawley = {
                name = "Joe Hawley Joe Hawley",
                text = {
                    "This joker retriggers cards",
                    "played in the previous {C:attention}round{}."
                }
            },

            j_tb_purpletie = {
                name = "Purple Tie",
                text = {
                    "{C:green}#1# in #2#{} chance to add a {C:tarot}purple seal{}",
                    "to a random scored card in hand.",
                    "{C:green}#1# in #3#{} chance for a {C:tarot}purple seal{}",
                    "to give an extra {C:tarot}tarot{} card."
                }
            },

            j_tb_englishchap = {
                name = "English Chap",
                text = {
                    "Retriggers the first played {C:attention}#1#{}",
                    "three additional times.",
                    "{s:0.8}Rank changes every round{}"
                }
            },

            j_tb_spaghettibathtub = {
                name = "Spaghetti Bathtub",
                text = {
                    "{X:chips,C:white}x#1#{} chips.",
                    "loses {X:chips,C:white}x#2#{} chips",
                    "per card played."
                }
            },

            j_tb_zirconiumpants = {
                name = "Zirconium Pants",
                text = {
                    "{C:green}#1# in #2#{} chance to generate",
                    "the {C:spectral}Trance{} spectral card if played",
                    "hand is a pair of {C:dark_edition}zirconium{} cards",
                    "{C:inactive}(Must have room){}"
                }
            },

            j_tb_naturalketchup = {
                name = "Natural Ketchup",
                text = {
                    "{C:mult}+#1#{} mult.",
                    "This joker loses {C:mult}-#2#{} mult per",
                    "card discarded."
                }
            },

            j_tb_cloudvariations = {
                name = "Variations on a Cloud",
                text = {
                    "This joker gains {X:chips,C:white}x#1#{} chips",
                    "if scored hand contains",
                    "exactly {C:attention}2{} stone cards.",
                    "{C:inactive}(Currently {X:chips,C:white}x#2#{C:inactive}){}"
                }
            },

            j_tb_notatrampoline = {
                name = "Not a Trampoline",
                text = {
                    "{C:mult}+#1#{} mult if full hand contains",
                    "{C:attention}no gaps in rank{}.",
                    "{C:inactive}(i.e. 2, 3, 4, 5, 6 or 5, 5, 6, 6, 7)"
                }
            },

            j_tb_goodandevil = {
                name = "Good and Evil",
                text = {
                    "{C:chips}#1#{} chips and {C:mult}#3#{} mult. This joker",
                    "loses {C:chips}-#2#{} chips for every card played",
                    "hand, and {C:mult}-#4#{} mult for every discard used."
                }
            },

            j_tb_missmelody = {
                name = "Miss Melody",
                text = {
                    "Non-face cards give an",
                    "additional {C:chips}+#1#{} chips."
                }
            },

            j_tb_twowuv = {
                name = "Two Wuv",
                text = {
                    "If {C:attention}played hand{} is exactly a",
                    "{C:attention}pair of queens{} and {C:attention}1 king{},",
                    "score the king and apply a",
                    "{C:attention}random enhancement{} to it."
                }
            },

            j_tb_edu = {
                name = "edu",
                text = {
                    "Scored 8s and 3s give",
                    "{C:mult}+#1#{} mult",
                    "{C:inactive,S:0.8}(Ranks do not change){}"
                }
            },

            j_tb_bananaman = {
                name = "The Banana Man",
                text = {
                    "Reintroduces {C:attention}Gros Michel{} to",
                    "the joker pool. {C:green}#3# in #4#{}",
                    "for all added jokers to turn",
                    "into {C:attention}Gros Michel{}. This joker",
                    "gains {X:mult,C:white}x#1#{} mult per banana",
                    "destroyed this run. {C:inactive}(currently {X:mult,C:white}x#2#{C:inactive})"
                }
            },

            j_tb_mechanicalmuseum = {
                name = "Marvin's Marvelous Mechanical Museum",
                text = {
                    "This joker enhances the {C:attention}highest rank{} in",
                    "scored hand to a {C:inactive}#1#{}."
                }
            },

            j_tb_bora = {
                name = "15 Seconds of Bora",
                text = {
                    "This joker gives {X:mult,C:white}x#1#{} mult if the",
                    "{C:attention}first hand{} is played within the",
                    "first {C:attention}15 seconds{} of the round.",
                    "{C:inactive}(currently #2#)"
                }
            },

            j_tb_muckablucka = {
                name = "Mucka Blucka",
                text = {
                    "Gain {C:money}money{} equal to the",
                    "{C:chips}chips{} value of the", 
                    "{C:attention}lowest{} scored rank"
                }
            },

            j_tb_letskillross = {
                name = "These Are My Last Words",
                text = {
                    "This joker gains {X:chips,C:white}x#2#{}",
                    "chips {C:inactive}(currently {X:chips,C:white}x#3#{C:inactive} chips){}",
                    "per every {V:1}#1#{} suit destroyed.",
                    "{s:0.8}Suit changes every round{}"
                }
            },

            j_tb_hawaiitwo = {
                name = "Hawaii Pt. II",
                text = {
                    "Destroy all played {C:attention}Queens{}.",
                    "This joker gains {X:mult,C:white}x#1#{} mult",
                    "{C:inactive}(Currently {X:mult,C:white}x#2#{C:inactive} mult){} per {C:attention}queen{}",
                    "destroyed in this fashion"
                }
            },

            j_tb_rasins = {
                name = "Rasins",
                text = {
                    "{C:attention}Lowest{} scored rank gives {X:mult,C:white}x#1#{}",
                    "mult for the next {C:attention}#2#{} hands."
                }
            },

            j_tb_hiddeninthesand = {
                name = "Hidden in the Sand",
                text = {
                    "Destroy {C:attention}1{} random card in hand and add its",
                    "{C:attention}rank{} to this joker's mult {C:inactive}(currently {C:mult}+#1#{C:inactive}){}",
                    "{C:inactive}(Aces count as {C:attention}1{C:inactive}, face cards count as {C:attention}10{C:inactive}){}"
                }
            },

            j_tb_shialabeouf = {
                name = "Actual Cannibal Shia LaBeouf!",
                text = {
                    "Destroy {C:attention}rightmost{} card and",
                    "gain {C:money}money{} equal to that card's {C:attention}rank{}",
                    "{C:inactive}(Aces count as {C:attention}1{C:inactive}, face cards count as {C:attention}10{C:inactive}){}"
                }
            },

            j_tb_rulerofeverything = {
                name = "The Ruler of Everything",
                text = {
                    "All unscored cards become {C:dark_edition}zirconium{}."
                }
            },

            j_tb_tallymail = {
                name = "Tally Mail",
                text = {
                    "This card gains {X:mult,C:white}x#2#{} mult",
                    "{C:inactive}(currently {X:mult,C:white}x#1#{C:inactive} mult){} for",
                    "every {C:attention}#3#{} discarded {C:inactive}",
                    "{s:0.8}Rank changes every round{}"
                }
            },

            j_tb_wholeworld = {
                name = "The Whole World and You",
                text = {
                    "This joker gives {X:mult,C:white}x1{} mult, plus",
                    "an additional {X:mult,C:white}x#1#{} mult",
                    "per played {C:spades}Spade{} card. Destroys all",
                    "played {C:spades}Spade{} cards after scoring.",
                    "{C:inactive}(suit does not change){}"
                }
            },

            j_tb_impressions = {
                name = "29 impressions, 1 joker",
                text = {
                    "This joker copies a {C:attention}random",
                    "{C:attention}joker{} in the joker tray.",
                    "{C:inactive}(changes every round)",
                    "{C:inactive}Currently copying #1#"
                }
            },

            j_tb_tapes = {
                name = "Tapes",
                text = {
                    "Destroy all unscored cards",
                    "Apply a random {C:attention}Tie{} to",
                    "a card in hand {C:attention}per{}",
                    "destroyed card.",
                    "{C:inactive,S:0.8}(Will not overwrite other seals/ties){}"
                }
            },

            j_tb_miraclemusical = {
                name = "Miracle Musical",
                text = {
                    "Retrigger all {C:dark_edition}polychrome{} cards. This joker",
                    "gains {X:mult,C:white}x#2#{} mult per cards",
                    "retriggered in this way. {C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} mult){}"
                }
            },

            j_tb_morewishes = {
                name = "More Wishes",
                text = {
                    "This joker gives {X:mult,C:white}xMult{} equal to the number of",
                    "{C:attention}retriggers + 1{} of the most retriggered card."
                }
            },

            j_tb_technicaldifficulties = {
                name = "Technical Difficulties",
                text = {
                    "{C:green}#3# in #4#{} chance for played cards",
                    "to not trigger. This joker gains",
                    "{X:mult,C:white}x#2#{} mult per card that does not",
                    "trigger {C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} mult)."
                }
            },

            j_tb_maryashley = {
                name = "The Ad Twins",
                text = {
                    "{X:mult,C:white}x#1#{} mult if hand contains",
                    "a pair of {C:attention}Queens{}."
                }
            },

            j_tb_boralogue = {
                name = "Boralogue #1#",
                text = {
                    "{X:mult,C:white}x#2#{} mult.",
                    "Increases by {X:mult,C:white}x#3#{} after",
                    "clearing a {C:attention}boss blind{}",
                    "{C:inactive}(Caps at {X:mult,C:white}x#4#{C:inactive})"
                }
            },

            j_tb_dreamjournal = {
                name = "Dream Journal",
                text = {
                    "Cycles between {C:attention}5{} different",
                    "effects.",
                    "{C:inactive}(Changes every round){}"
                }
            },

            j_tb_gallagher = {
                name = "The Drummer?",
                text = {
                    "Copies the effects of the jokers to",
                    "the {C:attention}left{} and {C:attention}right{} of this joker.",
                    "{C:green}#1# in #2#{} chance to be destroyed",
                    "at the end of round."
                }
            },

            j_tb_hawley = {
                name = "The Singer",
                text = {
                    "This joker gains {X:mult,C:white}x#2#{} mult",
                    "whenever a {C:attention}debuffed{} played card",
                    "or joker attempts to trigger.",
                    "{C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} mult){}"
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_horowitz = {
                name = "The Pianist",
                text = {
                    "This joker creates {C:attention}#1#{} random",
                    "{C:dark_edition}negative{} consumables when blind is",
                    "selected. Increases by {C:attention}#2#{} after",
                    "playing {C:attention}#3#{} {C:inactive}[#4#]{} cards.",
                    "{s:0.8}caps at {s:0.8,C:attention}#5#{s:0.8} cards{}"
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_seghisi = {
                name = "The Bassist",
                text = {
                    "When selecting a blind, gain",
                    "that blind's {C:attention}skip tag{}. Skipping a",
                    "blind awards {C:attention}#1#{} double tags.",
                    "{C:inactive}(Increases by {C:attention}#2#{C:inactive} after skipping {C:attention}#3#{C:inactive} [#4#] blinds){}"
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_federman = {
                name = "The Drummer",
                text = {
                    "Copies the effects of the jokers to",
                    "the {C:attention}left{} and {C:attention}right{} of this joker."
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_cantor = {
                name = "The Guitarist",
                text = {
                    "This joker gains {X:mult,C:white}x#2#{} mult per",
                    "played {C:attention}face card{} with the {C:hearts}hearts{} suit.",
                    "{C:inactive}(Currently {X:mult,C:white}x#1#{C:inactive} mult){}"
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_shea = {
                name = "The Stand In",
                text = {
                    "After {C:attention}#1#{} round(s)",
                    "sell this joker to create a",
                    "random {C:legendary}legendary joker{}",
                    "{C:green}#2# in #3#{} chance this joker",
                    "returns to the joker tray after being sold.",
                    "{C:inactive,S:0.8}(Must have room){}"
                },
                unlock = {
                    "?????"
                }
            },

            j_tb_karaca = {
                name = "The Performer",
                text = {
                    "This joker gains {X:mult,C:white}x#1#{} mult if",
                    "the final played hand is a {C:attentinon}High Card{}",
                    "{C:inactive}(Currently {X:mult,C:white}x#2#{C:inactive} mult){}"
                },
                unlock = {
                    "?????"
                }
            }
        },

        Other = {
            tb_redtie_seal = {
                name = "Red Tie",
                text = {
                    "This card cannot be {C:red}debuffed{}."
                }
            },

            tb_bluetie_seal = {
                name = "Blue Tie",
                text = {
                    "{C:green}#1# in #2#{} chance to create",
                    "a random {C:attention}skip tag{} if this card",
                    "is held in hand at {C:attention}end of round{}."
                }
            },

            tb_greentie_seal = {
                name = "Green Tie",
                text = {
                    "{X:mult,C:white}x#1#{} mult per {C:attention}consumable{}",
                    "in the consumables tray"
                }
            },

            tb_yellowtie_seal = {
                name = "Yellow Tie",
                text = {
                    "{C:mult}+#1#{} mult if scored hand",
                    "contains a {C:hearts}heart{}"
                }
            },

            tb_graytie_seal = {
                name = "Gray Tie",
                text = {
                    "Retriggers played cards to the",
                    "{C:attention}left and {C:attention}right{} of this one"
                }
            },

            tb_blacktie_seal = {
                name = "Black Tie",
                text = {
                    "Takes on the effect of a",
                    "random {C:attention}vanilla seal.{}",
                    "{C:inactive}(Currently #1#){}",
                    "{C:inactive}(Changes every round){}"
                }
            },

            tb_orangetie_seal = {
                name = "Orange Tie",
                text = {
                    "{C:green}#1# in #2#{} chance to level up",
                    "{C:attention}High Card{} when discarded."
                }
            },

            --Dream Journal
            tb_d_ross = {
                name = "Current Effect:",
                text = {
                    "Apply a {C:grey}Gray Tie{} to a",
                    "random playing card if",
                    "scored hand is a {C:attention}#1#{}"
                }
            },
            tb_d_andrew = {
                name = "Current Effect:",
                text = {
                    "Retrigger a random playing",
                    "card. That card gains {C:mult}+#1#{} mult"
                }
            },
            tb_d_joe = {
                name = "Current Effect:",
                text = {
                    "{X:edition,C:chips}^#1#{} chips and {X:edition,C:mult}^#2#{} mult"
                }
            },
            tb_d_zubin = {
                name = "Current Effect:",
                text = {
                    "{C:chips}+#1#{} chips"
                }
            },
            tb_d_rob = {
                name = "Current Effect:",
                text = {
                    "Enhanced cards give {X:mult,C:white}x#1#{} mult"
                }
            },
            tb_d_none = {
                name = "Current Effect:",
                text = {
                    "None"
                }
            }
        }
    },

    misc = {
        dictionary = {
            -- scoring stuff
            a_chips         = "+#1#",
            a_chips_minus   = "-#1#",
            a_hands         = "+#1# Hands",
            a_handsize      = "+#1# Hand Size",
            a_handsize_minus= "-#1# Hand Size",
            a_mult          = "+#1# Mult",
            a_mult_minus    = "-#1# Mult",
            a_remaining     = "#1# Remaining",
            a_sold_tally    = "#1#/#2# Sold",
            a_xmult         = "X#1# Mult",
            a_xmult_minus   = "X-#1# Mult",
            a_xchips        = "X#1#",
            a_xchips_minus  = "X-#1#",

            -- misc
            k_hiatus    = "On Hiatus!",
            k_left_ex   = "Left the band!",
            k_trance    = "Put in a trance!",
            k_zirconium = "Zirconium!"
        },

        v_dictionary = {
            a_echips        = "^#1#",
            a_echips_minus  = "^-#1#",
            a_emult         = "^#1# Mult",
            a_emult_minus   = "^-#1# Mult"
        },

        labels = {
            tb_zirconium = "Zirconium",
            tb_redtie_seal = "Red Tie",
            tb_bluetie_seal = "Blue Tie",
            tb_greentie_seal = "Green Tie",
            tb_yellowtie_seal = "Yellow Tie",
            tb_graytie_seal = "Gray Tie",
            tb_blacktie_seal = "Black Tie",
            tb_orangetie_seal = "Orange Tie"
        }
    }
}