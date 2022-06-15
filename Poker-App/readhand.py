import enum
import structs

class Item(enum.Enum):
    high = 0
    pair = 1
    twopair = 2
    set = 3
    straight = 4
    flush = 5
    boat = 6
    quad = 7
    straightflush = 8

def pair(hand):
    out = []
    if hand.c1.rank == hand.c2.rank:
        out.append(hand.c1.rank)
    if hand.c2.rank == hand.c3.rank:
        out.append(hand.c2.rank)
    if hand.c3.rank == hand.c4.rank:
        out.append(hand.c3.rank)
    if hand.c4.rank == hand.c5.rank:
        out.append(hand.c4.rank)
    return out

def set(hand):
    if hand.c1.rank == hand.c2.rank and hand.c1.rank == hand.c3.rank:
        return hand.c1.rank
    if hand.c2.rank == hand.c3.rank and hand.c2.rank == hand.c4.rank:
        return hand.c2.rank
    if hand.c3.rank == hand.c4.rank and hand.c3.rank == hand.c5.rank:
        return hand.c3.rank
    else:
        return structs.Rank.none

def straight(hand):
    if hand.c2.rank.value == hand.c3.rank.value + 1:
        if hand.c3.rank.value == hand.c4.rank.value + 1:
            if hand.c4.rank.value == hand.c5.rank.value + 1:
                if hand.c1.rank.value == hand.c2.rank.value + 1:
                    return hand.c1.rank
                elif hand.c1.rank.name == "ace" and hand.c2.rank.name == "five":
                    return structs.Rank.five
    return structs.Rank.none

def flush(hand):
    if hand.c1.suit == hand.c2.suit:
        if hand.c2.suit == hand.c3.suit:
            if hand.c3.suit == hand.c4.suit:
                if hand.c4.suit == hand.c5.suit:
                    return hand.c1.suit
    return structs.Suit.none

def boat(hand):
    out = []
    s = set(hand)
    if s != structs.Rank.none:
        if hand.c2.rank == hand.c3.rank:
            if hand.c4.rank == hand.c5.rank:
                out.append(set)
                out.append(hand.c4.rank)
                return out
        elif hand.c1.rank == hand.c2.rank and hand.c2.rank > hand.c3.rank:
            out.append(set)
            out.append(hand.c1.rank)
    return out

def quad(hand):
    if hand.c1.rank == hand.c2.rank and hand.c2.rank == hand.c3.rank and hand.c3.rank == hand.c4.rank:
        return hand.c1.rank
    if hand.c2.rank == hand.c3.rank and hand.c3.rank == hand.c4.rank and hand.c4.rank == hand.c5.rank:
        return hand.c2.rank
    return structs.Rank.none

def straightflush(hand):
    r = straight(hand)
    s = flush(hand)
    if r != structs.Rank.none and s != structs.Suit.none:
        return r
    return structs.Rank.none

def readhand(hand):
    if straightflush(hand) != structs.Rank.none:
        return Item.straightflush
    if quad(hand) != structs.Rank.none:
        return Item.quad
    if len(boat(hand)) > 0:
        return Item.boat
    if flush(hand) != structs.Suit.none:
        return Item.flush
    if straight(hand) != structs.Rank.none:
        return Item.straight
    if set(hand) != structs.Rank.none:
        return Item.set
    if len(pair(hand)) == 2:
        return Item.twopair
    if len(pair(hand)) == 1:
        return Item.pair
    return Item.high

def readhandPrint(hand):
    item = readhand(hand)
    if item == Item.straightflush:
        end = "a " + hand.c1.suit.name + " straight flush of rank " + straightflush(hand).name
    elif item == Item.quad:
        end = "four " + structs.rankPlural(quad(hand))
    elif item == Item.boat:
        b = boat(hand)
        end = "a full house with three " + structs.rankPlural(b[0]) + " and two " + structs.rankPlural(b[1])
    elif item == Item.flush:
        end = "a " + hand.c1.suit.name + " flush of rank " + hand.c1.rank.name
    elif item == Item.straight:
        end = "a straight of rank " + straight(hand).name
    elif item == Item.set:
        end = "a set of " + structs.rankPlural(set(hand))
    elif item == Item.twopair:
        t = pair(hand)
        end = "a pair of " + structs.rankPlural(t[0]) + " and a pair of " + structs.rankPlural(t[1])
    elif item == Item.pair:
        end = "a pair of " + structs.rankPlural(pair(hand)[0])
    else:
        end = hand.c1.rank.name + " high"
    print("The hand " + hand.getHandShort() + " contains " + end + ".")
