import enum
import letters
import words

class Pronoun(enum.Enum):
    ben = 0
    sen = 1
    o = 2
    biz = 3
    siz = 4
    onlar = 5

class Tense(enum.Enum):
    presprog = 0
    simppast = 1
    future = 2

def fourHarmony(word):
    i = -1
    while (i * -1 <= len(word)):
        if word[i] == u'i' or word[i] == u'e':
            return u'i'
        if word[i] == u'ı' or word[i] == u'a':
            return u'ı'
        if word[i] == u'ü' or word[i] == u'ö':
            return u'ü'
        if word[i] == u'u' or word[i] == u'o':
            return u'u'
        i -= 1
    return None

def twoHarmony(word):
    i = -1
    while (i * -1 <= len(word)):
        if word[i] == u'i' or word[i] == u'e' or word[i] == u'ü' or word[i] == u'ö':
            return u'e'
        if word[i] == u'ı' or word[i] == u'a' or word[i] == u'u' or word[i] == u'o':
            return u'a'
        i -= 1
    return None

def accusative(noun, n):
    # n is a boolean to see if the buffer should be n (True) or y (False)
    if noun in words.mutations:
        noun = words.mutations.get(noun)
    if noun[-1] in letters.vowels:
        if noun[-1] == "'":
            if noun[-2] in letters.vowels:
                y = u'y'
            else:
                y = u""
        else:
            if n:
                y = u'n'
            else:
                y = u'y'
    else:
        y = u''
    return noun + y + fourHarmony(noun)

def plural(noun):
    return noun + u'l' + twoHarmony(noun) + u'r'

def possessive(noun, gen):
    if noun in words.mutations and gen != u"their":
        noun = words.mutations.get(noun)
    if noun[-1] in letters.vowels:
        v = u""
    else:
        v = fourHarmony(noun)
    if gen == u"my":
        return noun + v + u"m"
    if gen == u"your":
        return noun + v + u"n"
    if gen == u"his" or gen == u"her" or gen == u"its":
        if v == u"":
            return noun + u"s" + fourHarmony(noun)
        else:
            return noun + v
    if gen == u"our":
        return noun + v + u"m" + fourHarmony(noun) + u"z"
    if gen == u"y'all's":
        return noun + v + u"n" + fourHarmony(noun) + u"z"
    if gen == u"their":
        if noun[-3] == u"l" and noun[-1] == u"r":
            return noun + fourHarmony(noun)
        else:
            return noun + u"l" + twoHarmony(noun) + u"r" + fourHarmony(twoHarmony(noun))