import countries
import math

"""arr = [[], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], [], []]

i = 1956
while i <= 2019:
    if i == 2020:
        i += 1
        continue
    add = 0
    if i > 2018:
        add = 1
    j = i+2+add
    while j <= 2022:
        if j == 2020:
            j += 1
            continue
        out = math.everything(i, j, 3, 40)
        arr[out.value].append([i, j])
        j += 1
    print(i)
    i += 1

reigns = []
for i in range(52):
    reigns.append([countries.Country(i).name, len(arr[i])])
math.sort_greatest(reigns)

min = 1000
for i in range(52):
        name = "{0:<25}".format(str(reigns[i][0]))
        val = reigns[i][1]
        if val < min:
            rank = "{0:>3}".format(str(i+1) + ".")
            min = val
        print(rank + " " + name + str(val))"""

start = int(input("Starting year: "))
end = int(input("Ending year: "))
math.everything(start, end, 3, 40)