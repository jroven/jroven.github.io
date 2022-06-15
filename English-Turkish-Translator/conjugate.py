# -*- coding: utf-8 -*-
import letters
import grammar

def presprog(word):
    copy = word
    if copy == u"et" or copy == u"git" or (len(copy) > 2 and copy[-3:] == " et"):
        copy = copy[:-1]
        copy = copy + u"d"
    elif copy[-1] in letters.vowels:
        copy = copy[:-1]
    if copy == u"d" or copy == u"y":
        harmony = u'i'
    else:
        harmony = grammar.fourHarmony(copy)
    return copy + harmony + u"yor"

def simppast(word):
    if word[-1] in letters.voiceless:
        d = u't'
    else:
        d = u'd'
    return word + d + grammar.fourHarmony(word)

def future(word):
    copy = word
    if copy == u"et" or copy == u"git" or (len(copy) > 2 and copy[-3:] == " et"):
        copy = copy[:-1]
        copy = copy + u"d"
    elif copy == u"ye":
        copy = u"yiy"
    elif copy == u"de":
        copy = u"diy"
    elif copy[-1] in letters.vowels:
        copy = copy + u'y'

    return copy + grammar.twoHarmony(copy) + u'c' + grammar.twoHarmony(copy) + u'k'

def neg(word):
    return word + u'm' + grammar.twoHarmony(word)

def personal(word, person):
    if word[-1] in letters.vowels:
        y =  u'y'
    else:
        y = u''
    if person == grammar.Pronoun.ben:
        suffix = y + grammar.fourHarmony(word) + u'm'
    elif person == grammar.Pronoun.sen:
        suffix = u's' + grammar.fourHarmony(word) + u'n'
    elif person == grammar.Pronoun.biz:
        suffix = y + grammar.fourHarmony(word) + u'z'
    elif person == grammar.Pronoun.siz:
        suffix = u's' + grammar.fourHarmony(word) + u'n' + grammar.fourHarmony(word) + u'z'
    elif person == grammar.Pronoun.onlar:
        suffix = u'l' + grammar.twoHarmony(word) + u'r'
    else:
        suffix = u''
    return word + suffix

def personalpast(word, person):
    if person == grammar.Pronoun.ben:
        suffix = u'm'
    elif person == grammar.Pronoun.sen:
        suffix = u'n'
    elif person == grammar.Pronoun.biz:
        suffix = u'k'
    elif person == grammar.Pronoun.siz:
        suffix = u'n' + grammar.fourHarmony(word) + u'z'
    elif person == grammar.Pronoun.onlar:
        suffix = u'l' + grammar.twoHarmony(word) + u'r'
    else:
        suffix = u''
    return word + suffix

def conjugate(verb, tense, person):
    if tense == grammar.Tense.presprog:
        return personal(presprog(verb), person)
    elif tense == grammar.Tense.simppast:
        return personalpast(simppast(verb), person)
    elif tense == grammar.Tense.future:
        fut = future(verb)
        if person == grammar.Pronoun.ben or person == grammar.Pronoun.biz:
            fut = fut[:-1]
            fut = fut + u'ğ'
        return personal(fut, person)