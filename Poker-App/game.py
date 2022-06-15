import random
import seven
import odds
import time

def pause():
    time.sleep(0.5)

class Player:
    def __init__(self, name, money, hand, moneyinpot, ingame, allin):
        self.name = name
        self.money = money
        self.hand = hand
        self.moneyinpot = moneyinpot
        self.ingame = ingame
        self.allin = allin
    
    def clear(self):
        self.hand = []
        self.moneyinpot = 0
        self.ingame = True
    
    def call(self, game):
        diff = game.tocall - self.moneyinpot
        self.money -= diff
        below = 0
        if self.money <= 0:
            below = self.money * -1
            self.money = 0
            self.allin = True
        game.pot += diff - below
        self.moneyinpot = game.tocall - below

    def bet(self, game, amount):
        # If the player has not yet called, the amount is
        # on top of the amount that they need to call
        diff = game.tocall - self.moneyinpot
        self.money -= diff + amount
        game.pot += diff + amount
        game.tocall += amount
        self.moneyinpot = game.tocall
        if self.money == 0:
            self.allin = True
    
    def fold(self):
        self.ingame = False
    
    def canbet(self, amount):
        if self.money < amount:
            return False
        return True

def parseaction():
    while 1:
        action = input()
        parse = action.split()
        if len(parse) == 0:
            continue
        if parse[0] == "call" or parse[0] == "check" or parse[0] == "all":
            return "call"
        if parse[0] == "raise" or parse[0] == "bet":
            if len(parse) > 1:
                return int(parse[1])
            else:
                return int(input("How much would you like to raise by? "))
        if parse[0] == "fold":
            return "fold"


class Game:
    def __init__(self, original_players, players, deck, board, pot, tocall, dealer):
        self.players = players                      # list of players still in the game
        self.original_players = original_players    # list of all players
        self.deck = deck                            # the deck
        self.board = board                          # list of five cards
        self.pot = pot                              # total amount in pot
        self.tocall = tocall                        # total amount each player has in/must put in in total
        self.dealer = dealer                        # which player is dealing (index of self.players)

    def clear(self):
        self.board = []
        self.pot = 0
        self.tocall = 0
        moneys = [element.money for element in self.players]
        self.players = self.original_players
        for i in range(len(self.original_players)):
            self.original_players[i].money = moneys[i]
            self.original_players[i].hand = []
    
    def ante(self, amount):
        self.pot = amount * len(self.players)
        self.tocall = amount
        for element in self.players:
            element.money -= amount
            element.moneyinpot = amount
    
    def playersingame(self):
        out = []
        for element in self.players:
            if element.ingame:
                out.append(element)
        return out
    
    def ready(self):
        for element in self.players:
            if element.ingame:
                if element.moneyinpot < self.tocall:
                    return False
        return True
    
    def dealhand(self, player):
        r1 = random.randint(0, len(self.deck) - 1)
        player.hand.append(self.deck[r1])
        self.deck.remove(self.deck[r1])

        r2 = random.randint(0, len(self.deck) - 1)
        player.hand.append(self.deck[r2])
        self.deck.remove(self.deck[r2])

    def odds_flop(self):
        p = [element.hand for element in self.players]
        return odds.odds_two(p, self.board, self.deck)
    
    def odds_turn(self):
        p = [element.hand for element in self.players]
        return odds.odds_one(p, self.board, self.deck)
    
    def bettinground(self):
        # Returns a boolean representing if the game is over
        i = 0
        newround = True
        while 1:
            turn = i % len(self.players)
            player = self.players[turn]
            if player.ingame:
                if newround:
                    pause()
                    print("Amount in pot: " + str(self.pot))
                    pause()
                    print("Money: " + str(player.money))
                newround = True
                diff = self.tocall - player.moneyinpot
                if player.moneyinpot < self.tocall:
                    if diff >= player.money:
                        c = "all in " + str(player.money)
                    else:
                        c = "call " + str(diff)
                else:
                    c = "check"
                pause()
                print(player.name + "'s turn: " + c + ", raise, or fold")
                action = parseaction()
                if action == "call":
                    player.call(self)
                elif action == "fold":
                    player.fold()
                else:
                    if player.canbet(diff + action) == False:
                        pause()
                        print("You cannot bet " + str(diff + action) + ", you only have " + str(player.money))
                        newround = False
                        continue
                    player.bet(self, action)
                if len(self.playersingame()) == 1:
                    pause()
                    print("\n" + self.playersingame()[0].name + " wins!")
                    self.clear()
                    return True
                print("")
            if i >= len(self.players) - 1 and self.ready():
                for element in self.players:
                    if element.ingame == False:
                        self.players.remove(element)
                return False
            i += 1
    
    def dealboard(self):
        r = random.randint(0, len(self.deck) - 1)
        self.board.append(self.deck[r])
        self.deck.remove(self.deck[r])

    def playgame(self):
        print("Starting game: " + str(len(self.players)) + " players")
        pause()
        print("")
        for element in self.players:
            self.dealhand(element)
            if element.ingame:
                pause()
                print(element.name + ": " + element.hand[0].getCardNameAbbr() + ", " + element.hand[1].getCardNameAbbr())
        pause()
        print("")
        
        if self.bettinground():
            return

        for i in range(3):
            self.dealboard()
        f1 = self.board[0].getCardNameAbbr()
        f2 = self.board[1].getCardNameAbbr()
        f3 = self.board[2].getCardNameAbbr()
        pause()
        print(f1)
        pause()
        print(f2)
        pause()
        print(f3)
        pause()
        print("Flop: " + f1 + ", " + f2 + ", " + f3)
        o = self.odds_flop()
        for element in self.players:
            if element.ingame:
                pause()
                print(element.name + ": " + element.hand[0].getCardNameAbbr() + ", " + element.hand[1].getCardNameAbbr() + "    Odds: " + str(round(o[self.players.index(element)] * 100, 1)) + "%")
        pause()
        print("Split: " + str(round(o[-1] * 100, 1)) + "%\n")

        if self.bettinground():
            return

        self.dealboard()
        f4 = self.board[3].getCardNameAbbr()
        pause()
        print("Turn: " + f4)
        pause()
        print("Board: " + f1 + ", " + f2 + ", " + f3 + ", " + f4)
        o = self.odds_turn()
        for element in self.players:
            if element.ingame:
                pause()
                print(element.name + ": " + element.hand[0].getCardNameAbbr() + ", " + element.hand[1].getCardNameAbbr() + "    Odds: " + str(round(o[self.players.index(element)] * 100, 1)) + "%")
        pause()
        print("Split: " + str(round(o[-1] * 100, 1)) + "%\n")

        if self.bettinground():
            return

        self.dealboard()
        f5 = self.board[4].getCardNameAbbr()
        pause()
        print("River: " + f5)
        pause()
        print("Board: " + f1 + ", " + f2 + ", " + f3 + ", " + f4 + ", " + f5)

        max = 0
        winner = []
        for element in self.players:
            if element.ingame:
                hand = seven.HandSeven(element.hand[0], element.hand[1], self.board[0], self.board[1], self.board[2], self.board[3], self.board[4])
                v = seven.val(hand)
                if v == max:
                    winner.append(element)
                if v > max:
                    max = v
                    winner = [element]

        if len(winner) > 1:
            out = "Split pot between "
            for i in range(len(winner)):
                if i == len(winner) - 1:
                    out = out + "and "
                out = out + winner.name
                if i < len(winner) - 1:
                    out = out + ", "
        else:
            out = winner[0].name + " wins!"

        for element in self.players:
            if element.ingame:
                if len(winner) == 1 and winner[0] == element:
                    percent = "100%"
                else:
                    percent = "0%"
                pause()
                print(element.name + ": " + element.hand[0].getCardNameAbbr() + ", " + element.hand[1].getCardNameAbbr() + "    Odds: " + percent)
        if len(winner) > 1:
            percent = "100%"
        else:
            percent = "0%"
        pause()
        print("Split: " + percent)

        if self.bettinground():
            return

        pause()
        print("Board: " + f1 + ", " + f2 + ", " + f3 + ", " + f4 + ", " + f5)
        for element in self.players:
            if element.ingame:
                pause()
                print(element.name + ": " + element.hand[0].getCardNameAbbr() + ", " + element.hand[1].getCardNameAbbr())
        pause()
        print("\n" + out)