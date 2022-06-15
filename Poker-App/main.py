import structs
import readhand
import seven
import odds
import game

deck = structs.fulldeck

def init_game():
    num_players = int(input("How many players? "))
    starting_money = int(input("How much money will each player start with? "))
    players = []
    for i in range(num_players):
        name = input("What is Player " + str(i + 1) + "'s name? ")
        players.append(game.Player(name, starting_money, [], 0, True, False))
    return game.Game(players, players, deck, [], 0, 0, 0)

init_game().playgame()