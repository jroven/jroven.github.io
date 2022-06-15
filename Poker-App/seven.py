import structs
import readhand

class HandSeven:
    def __init__(self, c1, c2, c3, c4, c5, c6, c7):
        self.c1 = c1
        self.c2 = c2
        self.c3 = c3
        self.c4 = c4
        self.c5 = c5
        self.c6 = c6
        self.c7 = c7
    
    def org(self):
        for i in range(6):
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
            if self.c5.rank.value < self.c6.rank.value:
                temp = self.c5
                self.c5 = self.c6
                self.c6 = temp
            if self.c6.rank.value < self.c7.rank.value:
                temp = self.c6
                self.c6 = self.c7
                self.c7 = temp

def orgSeven(hand):
    for i in range(6):
        if hand.c1.rank.value < hand.c2.rank.value:
            temp = hand.c1
            hand.c1 = hand.c2
            hand.c2 = temp
        if hand.c2.rank.value < hand.c3.rank.value:
            temp = hand.c2
            hand.c2 = hand.c3
            hand.c3 = temp
        if hand.c3.rank.value < hand.c4.rank.value:
            temp = hand.c3
            hand.c3 = hand.c4
            hand.c4 = temp
        if hand.c4.rank.value < hand.c5.rank.value:
            temp = hand.c4
            hand.c4 = hand.c5
            hand.c5 = temp
        if hand.c5.rank.value < hand.c6.rank.value:
            temp = hand.c5
            hand.c5 = hand.c6
            hand.c6 = temp
        if hand.c6.rank.value < hand.c7.rank.value:
            temp = hand.c6
            hand.c6 = hand.c7
            hand.c7 = temp

def ranksSeven(hand):
    lst = [0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    lst[hand.c1.rank.value] += 1
    lst[hand.c2.rank.value] += 1
    lst[hand.c3.rank.value] += 1
    lst[hand.c4.rank.value] += 1
    lst[hand.c5.rank.value] += 1
    lst[hand.c6.rank.value] += 1
    lst[hand.c7.rank.value] += 1

    return lst

def pairSeven(hand):
    lst = ranksSeven(hand)
    i = 12
    while i >= 0:
        if lst[i] > 1:
            return i
        i -= 1
    
    return -1

def twopairSeven(hand):
    lst = ranksSeven(hand)
    out = [-1, -1]
    i = 12
    count = 0
    while i >= 0:
        if lst[i] > 1:
            out[count] = i
            count += 1
            if count > 1:
                return out
        i -= 1
    
    return out

def setSeven(hand):
    lst = ranksSeven(hand)
    i = 12
    while i >= 0:
        if lst[i] > 2:
            return i
        i -= 1
    
    return -1

def straightSeven(hand):
    lst = ranksSeven(hand)
    i = 12
    while i > 3:
        if lst[i] > 0 and lst[i-1] > 0 and lst[i-2] > 0 and lst[i-3] > 0 and lst[i-4] > 0:
            return i
        i -= 1
    if lst[0] > 0 and lst[1] > 0 and lst[2] > 0 and lst[3] > 0 and lst[12] > 0:
        return 3
    
    return -1

def flushSeven(hand):
    lst = [0, 0, 0, 0]
    lst[hand.c1.suit.value] += 1
    lst[hand.c2.suit.value] += 1
    lst[hand.c3.suit.value] += 1
    lst[hand.c4.suit.value] += 1
    lst[hand.c5.suit.value] += 1
    lst[hand.c6.suit.value] += 1
    lst[hand.c7.suit.value] += 1

    i = 0
    while i < 4:
        if lst[i] >= 5:
            return i
        i += 1

    return -1

def boatSeven(hand):
    lst = ranksSeven(hand)
    out = [-1, -1]

    i = 12
    while i >= 0:
        if lst[i] > 2:
            out[0] = i
            break
        i -= 1
    
    if out[0] == -1:
        return out

    i = 12
    while i >= 0:
        if i == out[0]:
            i -= 1
            continue
        if lst[i] > 1:
            out[1] = i
            return out
        i -= 1

    return out

def quadSeven(hand):
    lst = ranksSeven(hand)
    i = 12
    while i >= 0:
        if lst[i] > 3:
            return i
        i -= 1
    
    return -1

def straightflushSeven(hand):
    out = straightSeven(hand)
    suit = flushSeven(hand)
    if out != -1 and suit != -1:
        return out
    
    return -1

"""
RANKING
Straight flush: high card
Quad: rank, kicker
Boat: three, two
Flush: all five cards
Straight: high card
Set: rank, kicker, kicker
Two pair: rank, rank, kicker
Pair: rank, kicker, kicker, kicker
High: all five cards

Values are compressed into a 24 bit integer
    0:3     item
    4:7     most important rank
    so on
"""
def val(hand):
    # straight flush
    f = flushSeven(hand)
    st = straightSeven(hand)
    if f != -1 and st != -1:
        return (8 << 20) + (st << 16)
    
    # quad
    q = quadSeven(hand)
    if q != -1:
        if hand.c1.rank.value == q:
            k = hand.c5.rank.value
        else:
            k = hand.c1.rank.value
        return (7 << 20) + (q << 16) + (k << 12)
    
    # boat
    b = boatSeven(hand)
    if b[1] != -1:
        return (6 << 20) + (b[0] << 16) + (b[1] << 12)
    
    # flush
    if f != -1:
        k = [0, 0, 0, 0, 0]
        i = 0
        if hand.c1.suit.value == f:
            k[i] = hand.c1.rank.value
            i += 1
        if hand.c2.suit.value == f:
            k[i] = hand.c2.rank.value
            i += 1
        if hand.c3.suit.value == f:
            k[i] = hand.c3.rank.value
            i += 1
        if hand.c4.suit.value == f:
            k[i] = hand.c4.rank.value
            i += 1
        if hand.c5.suit.value == f:
            k[i] = hand.c5.rank.value
            i += 1
        if i < 5:
            if hand.c6.suit.value == f:
                k[i] = hand.c6.rank.value
                i += 1
            if i < 5:
                if hand.c7.suit.value == f:
                    k[i] = hand.c7.rank.value
        return (5 << 20) + (k[0] << 16) + (k[1] << 12) + (k[2] << 8) + (k[3] << 4) + k[4]
    
    # straight
    if st != -1:
        return (4 << 20) + (st << 16)
    
    # set
    s = setSeven(hand)
    if s != -1:
        k = [0, 0]
        if hand.c1.rank.value == s:
            k[0] = hand.c4.rank.value
            k[1] = hand.c5.rank.value
        else:
            k[0] = hand.c1.rank.value
            if hand.c2.rank.value == 2:
                k[1] = hand.c5.rank.value
            else:
                k[1] = hand.c2.rank.value
        return (3 << 20) + (s << 16) + (k[0] << 12) + (k[1] << 8)

    # two pair
    t = twopairSeven(hand)
    if t[1] != 1:
        if hand.c1.rank.value in t:
            if hand.c3.rank.value in t:
                k = hand.c5.rank.value
            else:
                k = hand.c3.rank.value
        else:
            k = hand.c1.rank.value
        return (2 << 20) + (t[0] << 16) + (t[1] << 12) + (k << 8)
    
    # pair
    p = pairSeven(hand)
    if p != -1:
        k = [0, 0, 0]
        if hand.c1.rank.value == p:
            k[0] = hand.c3.rank.value
            k[1] = hand.c4.rank.value
            k[2] = hand.c5.rank.value
        else:
            k[0] = hand.c1.rank.value
            if hand.c2.rank.value == p:
                k[1] = hand.c4.rank.value
                k[2] = hand.c5.rank.value
            else:
                k[1] = hand.c2.rank.value
                if hand.c3.rank.value == p:
                    k[2] = hand.c5.rank.value
                else:
                    k[2] = hand.c3.rank.value
        return (1 << 20) + (k[0] << 16) + (k[1] << 12) + (k[2] << 8)
    
    # high card
    k = []
    k.append(hand.c1.rank.value)
    k.append(hand.c2.rank.value)
    k.append(hand.c3.rank.value)
    k.append(hand.c4.rank.value)
    k.append(hand.c5.rank.value)
    return (k[0] << 16) + (k[1] << 12) + (k[2] << 8) + (k[3] << 4) + k[4]

"""
Returns 1 if h1 beats h2, -1 if h2 beats h1, and 0 if there is a tie
"""
def compare(h1, h2):
    diff = val(h1) - val(h2)
    if diff > 0:
        return 1
    if diff < 0:
        return -1
    return 0