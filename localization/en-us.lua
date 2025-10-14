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
                    "destroy selected card instead.}"
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
                name = "Mary-Kate and Ashley Olsen",
                text = {
                    "{X:mult,C:white}x#1#{} mult if hand contains",
                    "a pair of {C:attention}Queens{}."
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
            }
        }
    },

    misc = {
        dictionary = {
            -- scoring stuff
            a_chips = "+#1#",
            a_chips_minus = "-#1#",
            a_hands = "+#1# Hands",
            a_handsize = "+#1# Hand Size",
            a_handsize_minus = "-#1# Hand Size",
            a_mult = "+#1# Mult",
            a_mult_minus = "-#1# Mult",
            a_remaining = "#1# Remaining",
            a_sold_tally = "#1#/#2# Sold",
            a_xmult = "X#1# Mult",
            a_xmult_minus = "-X#1# Mult",
            a_xchips = "X#1# Chips",
            a_xchips_minus = "-X#1# Chips",

            -- misc
            k_hiatus = "On Hiatus!",
            k_left_ex = "Left the band!",
            k_trance = "Put in a trance",
            k_zirconium = "Zirconium!"
        },

        labels = {
            tb_zirconium = "Zirconium"
        }
    }
}