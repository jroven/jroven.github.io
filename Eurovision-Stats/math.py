from sqlite3 import TimestampFromTicks
import countries

def average(list):
    out = 0
    for element in list:
        out += element
    out /= len(list)
    return out

def sort_least(list):
    l = len(list)
    for i in range(l-1):
        for i in range(l-1):
            if list[i][1] > list[i+1][1]:
                temp = list[i]
                list[i] = list[i+1]
                list[i+1] = temp

def sort_greatest(list):
    l = len(list)
    for i in range(l-1):
        for i in range(l-1):
            if list[i][1] < list[i+1][1]:
                temp = list[i]
                list[i] = list[i+1]
                list[i+1] = temp

def everything(start, end, min, outof):
    out = []
    for i in range(52):
        c = countries.Country(i)
        l = len(c.record(start, end))
        if l >= min:
            out.append([c.name.replace("_", " "), average(c.normalized(start, end, outof)), l])
    sort_least(out)
    print("\n    Country                  Average         Participations\n")
    for element in out:
        rank = "{0:>3}".format(str(out.index(element)+1) + ".")
        name = "{0:<25}".format(str(element[0]))
        val = "{:5.2f}".format(element[1])
        participations = "{0:<2}".format(str(element[2]))
        print(rank + " " + name + val + "           " + participations)