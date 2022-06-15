import structs
import seven

def odds_one(players, board, deck):
    wins = [0 for i in range(len(players) + 1)]
    total = len(deck)
    for element in deck:
        river = element
        hands = []
        for i in range(len(players)):
            hands.append(seven.HandSeven(players[i][0], players[i][1], board[0], board[1], board[2], board[3], river))
            hands[i].org()

        max = 0
        winner = []
        for i in range(len(players)):
            v = seven.val(hands[i])
            if v == max:
                winner.append(i)
            if v > max:
                max = v
                winner = [i]
        
        if len(winner) > 1:
            wins[-1] += 1
        else:
            wins[winner[0]] += 1
    
    return [element/total for element in wins]

def odds_two(players, board, deck):
    out = [0 for i in range(len(players) + 1)]
    for element in deck:
        newdeck = deck.copy()
        newdeck.remove(element)
        newboard = board.copy()
        newboard.append(element)
        od = odds_one(players, newboard, newdeck)
        for i in range(len(out)):
            out[i] += od[i]
    
    total = len(deck)

    return [element/total for element in out]

def odds_three(players, board, deck):
    out = [0 for i in range(len(players) + 1)]
    for element in deck:
        newdeck = deck.copy()
        newdeck.remove(element)
        newboard = board.copy()
        newboard.append(element)
        od = odds_two(players, newboard, newdeck)
        for i in range(len(out)):
            out[i] += od[i]
    
    total = len(deck)

    return [element/total for element in out]