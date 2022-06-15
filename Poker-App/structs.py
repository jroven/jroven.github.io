import enum
import math

class Rank(enum.Enum):
    none = -1
    two = 0
    three = 1
    four = 2
    five = 3
    six = 4
    seven = 5
    eight = 6
    nine = 7
    ten = 8
    jack = 9
    queen = 10
    king = 11
    ace = 12

class Suit(enum.Enum):
    none = -1
    spades = 0
    hearts = 1
    clubs = 2
    diamonds = 3

def card_toi(card):
    return card.rank.value + card.suit.value * 13

def ito_card(n):
    return Card(Rank(n%13), Suit(math.floor(n/13)))

def rankAbbr(rank):
    if rank == "two":
        return "2"
    if rank == "three":
        return "3"
    if rank == "four":
        return "4"
    if rank == "five":
        return "5"
    if rank == "six":
        return "6"
    if rank == "seven":
        return "7"
    if rank == "eight":
        return "8"
    if rank == "nine":
        return "9"
    if rank == "ten":
        return "T"
    if rank == "jack":
        return "J"
    if rank == "queen":
        return "Q"
    if rank == "king":
        return "K"
    if rank == "ace":
        return "A"

def rankPlural(rank):
    if rank.value == 4:
        return "sixes"
    return rank.name + "s"

def suitAbbr(suit):
    if suit == "spades":
        return "S"
    if suit == "hearts":
        return "H"
    if suit == "clubs":
        return "C"
    if suit == "diamonds":
        return "D"

class Card:
    def __init__(self, rank, suit):
        self.rank = rank
        self.suit = suit

    def getCardNameLong(self):
        return str(self.rank.name) + " of " + str(self.suit.name)
    
    def getCardNameAbbr(self):
        return rankAbbr(self.rank.name) + suitAbbr(self.suit.name)

x2S = Card(Rank.two, Suit.spades)
x3S = Card(Rank.three, Suit.spades)
x4S = Card(Rank.four, Suit.spades)
x5S = Card(Rank.five, Suit.spades)
x6S = Card(Rank.six, Suit.spades)
x7S = Card(Rank.seven, Suit.spades)
x8S = Card(Rank.eight, Suit.spades)
x9S = Card(Rank.nine, Suit.spades)
xTS = Card(Rank.ten, Suit.spades)
xJS = Card(Rank.jack, Suit.spades)
xQS = Card(Rank.queen, Suit.spades)
xKS = Card(Rank.king, Suit.spades)
xAS = Card(Rank.ace, Suit.spades)
x2H = Card(Rank.two, Suit.hearts)
x3H = Card(Rank.three, Suit.hearts)
x4H = Card(Rank.four, Suit.hearts)
x5H = Card(Rank.five, Suit.hearts)
x6H = Card(Rank.six, Suit.hearts)
x7H = Card(Rank.seven, Suit.hearts)
x8H = Card(Rank.eight, Suit.hearts)
x9H = Card(Rank.nine, Suit.hearts)
xTH = Card(Rank.ten, Suit.hearts)
xJH = Card(Rank.jack, Suit.hearts)
xQH = Card(Rank.queen, Suit.hearts)
xKH = Card(Rank.king, Suit.hearts)
xAH = Card(Rank.ace, Suit.hearts)
x2C = Card(Rank.two, Suit.clubs)
x3C = Card(Rank.three, Suit.clubs)
x4C = Card(Rank.four, Suit.clubs)
x5C = Card(Rank.five, Suit.clubs)
x6C = Card(Rank.six, Suit.clubs)
x7C = Card(Rank.seven, Suit.clubs)
x8C = Card(Rank.eight, Suit.clubs)
x9C = Card(Rank.nine, Suit.clubs)
xTC = Card(Rank.ten, Suit.clubs)
xJC = Card(Rank.jack, Suit.clubs)
xQC = Card(Rank.queen, Suit.clubs)
xKC = Card(Rank.king, Suit.clubs)
xAC = Card(Rank.ace, Suit.clubs)
x2D = Card(Rank.two, Suit.diamonds)
x3D = Card(Rank.three, Suit.diamonds)
x4D = Card(Rank.four, Suit.diamonds)
x5D = Card(Rank.five, Suit.diamonds)
x6D = Card(Rank.six, Suit.diamonds)
x7D = Card(Rank.seven, Suit.diamonds)
x8D = Card(Rank.eight, Suit.diamonds)
x9D = Card(Rank.nine, Suit.diamonds)
xTD = Card(Rank.ten, Suit.diamonds)
xJD = Card(Rank.jack, Suit.diamonds)
xQD = Card(Rank.queen, Suit.diamonds)
xKD = Card(Rank.king, Suit.diamonds)
xAD = Card(Rank.ace, Suit.diamonds)

fulldeck = [x2S, x3S, x4S, x5S, x6S, x7S, x8S, x9S, xTS, xJS, xQS, xKS, xAS,
            x2H, x3H, x4H, x5H, x6H, x7H, x8H, x9H, xTH, xJH, xQH, xKH, xAH,
            x2C, x3C, x4C, x5C, x6C, x7C, x8C, x9C, xTC, xJC, xQC, xKC, xAC,
            x2D, x3D, x4D, x5D, x6D, x7D, x8D, x9D, xTD, xJD, xQD, xKD, xAD]

class Hand:
    def __init__(self, c1, c2, c3, c4, c5):
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
        self.c4 = c4
        self.c5 = c5
    
    def org(self):
        for i in range(4):
            if self.c1.rank.value < self.c2.rank.value:
                temp = self.c1
                self.c1 = self.c2
                self.c2 = temp
            if self.c2.rank.value < self.c3.rank.value:
                temp = self.c2
                self.c2 = self.c3
                self.c3 = temp
            if self.c3.rank.value < self.c4.rank.value:
                temp = self.c3
                self.c3 = self.c4
                self.c4 = temp
            if self.c4.rank.value < self.c5.rank.value:
                temp = self.c4
                self.c4 = self.c5
                self.c5 = temp
    
    def printHandLong(self):
        init = "This hand contains the "
        mid = ", the "
        end = ", and the "
        n1 = self.c1.getCardNameLong()
        n2 = self.c2.getCardNameLong()
        n3 = self.c3.getCardNameLong()
        n4 = self.c4.getCardNameLong()
        n5 = self.c5.getCardNameLong()
        print(init + n1 + mid + n2 + mid + n3 + mid + n4 + end + n5 + ".")
    
    def getHandShort(self):
        c = ", "
        a1 = self.c1.getCardNameAbbr()
        a2 = self.c2.getCardNameAbbr()
        a3 = self.c3.getCardNameAbbr()
        a4 = self.c4.getCardNameAbbr()
        a5 = self.c5.getCardNameAbbr()
        return "(" + a1 + c + a2 + c + a3 + c + a4 + c + a5 + ")"