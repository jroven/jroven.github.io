import conjugate
import words
import grammar

def parsesubject(split):
    pronoun = grammar.Pronoun.o
    parsecount = 0

    det = u""
    number = False
    if split[0] in words.determiners:
        parsecount += 1
        if split[0] != u"the":
            det = words.determiners.get(split[0]) + u" "
    elif split[0] in words.numbers:
        parsecount += 1
        det = words.numbers.get(split[0]) + u" "
        number = True
    else:
        try:
            det = words.num(int(split[0])) + u" "
            parsecount += 1
        except:
            pass
    
    subject = split[parsecount]

    if subject in words.pronouns.keys():
        p = words.pronouns.get(subject)
        pronoun = grammar.Pronoun[p]
        tsubject = pronoun.name
        if tsubject == grammar.Pronoun.o:
            subpl = False
    else:
        if subject in words.irregular_plurals.values():
            subpl = True
            subject = words.inverted_irregular_plurals.get(subject)
        elif subject[-1] == u's':
            subpl = True
            subject = subject[:-1]
        else:
            subpl = False
        tsubject = words.nouns.get(subject)
        fake = False
        if tsubject == None:
            tsubject = subject
            fake = True
        if subpl and number == False:
            tsubject = grammar.plural(tsubject)
    
    if split[0] in words.possessors:
        if fake:
            tsubject = subject + "'"
        tsubject = grammar.possessive(tsubject, split[0])
    
    parsecount += 1

    if det == u"":
        return [tsubject, parsecount, pronoun]
    else:
        return [det + tsubject, parsecount, pronoun]

def parseverb(split, parsecount, pronoun):
    # parsecount is left off from parsesubject
    # pronoun is from parsesubject
    try:
        verb = split[parsecount]
    except:
        return [None, parsecount]

    if verb == u"will":
        tense = grammar.Tense.future
        parsecount += 1
        verb = split[parsecount]
        if verb == u"not":
            parsecount += 1
            verb = split[parsecount]
            neg = True
        else:
            neg = False
    elif verb == u"won't" or verb == u"wont":
        tense = grammar.Tense.future
        parsecount += 1
        verb = split[parsecount]
        neg = True
    elif verb == u"do" or verb == u"does":
        tense = grammar.Tense.presprog
        parsecount += 1
        verb = split[parsecount]
        if verb == u"not":
            parsecount += 1
            verb = split[parsecount]
            neg = True
        else:
            neg = False
    elif verb == u"did" and (split[parsecount+1] in words.verbs.keys() or split[parsecount+1] == u"not"):
        tense = grammar.Tense.simppast
        parsecount += 1
        verb = split[parsecount]
        if verb == u"not":
            parsecount += 1
            verb = split[parsecount]
            neg = True
        else:
            neg = False
    elif verb == u"don't" or verb == u"dont" or verb == u"doesn't" or verb == u"doesnt":
        tense = grammar.Tense.presprog
        parsecount += 1
        verb = split[parsecount]
        neg = True
    elif verb == u"didn't" or verb == u"didnt":
        tense = grammar.Tense.simppast
        parsecount += 1
        verb = split[parsecount]
        neg = True
    elif verb in words.irregular_verbs.values():
        tense = grammar.Tense.simppast
        verb = words.inverted_irregular_verbs.get(verb)
        neg = False
    elif verb[-2:] == u"ed":
        tense = grammar.Tense.simppast
        verb = verb[:-2]
        neg = False
    else:
        tense = grammar.Tense.presprog
        neg = False

    if pronoun == grammar.Pronoun.o and verb[-1] == u's':
        verb = verb[:-1]
    if verb in words.verbs.keys():
        tverb = words.verbs.get(verb)
    if neg:
        tverb = conjugate.neg(tverb)
    parsecount += 1
    return [conjugate.conjugate(tverb, tense, pronoun), parsecount]

def parseobject(split, parsecount):
    try:
        if split[parsecount]:
            pass
    except:
        return None
    
    og = parsecount
    det = u""
    acc = False
    number = False
    if split[parsecount] in words.determiners:
        parsecount += 1
        if split[og] != u"the":
            det = words.determiners.get(split[og]) + u" "
        if split[og] != u"an" and split[og] != u"a":
            acc = True
    elif split[parsecount] in words.numbers:
        parsecount += 1
        det = words.numbers.get(split[og]) + u" " 
        number = True
    else:
        try:
            det = words.num(int(split[og])) + u" "
            parsecount += 1
        except:
            pass
    
    object = split[parsecount]

    if object in words.objpronouns.keys():
        tobject = words.objpronouns.get(object)
    else:
        if object in words.irregular_plurals.values():
            objpl = True
            object = words.inverted_irregular_plurals.get(object)
        elif object[-1] == u's':
            objpl = True
            object = object[:-1]
        else:
            objpl = False
        tobject = words.nouns.get(object)
        fake = False
        if tobject == None:
            tobject = object
            fake = True
            acc = True
        if objpl and acc:
            if fake:
                tobject = tobject + "'"
            if number == False:
                tobject = grammar.plural(tobject)
    
    if split[og] in words.possessors:
        poss = True
        if fake and objpl == False:
            tobject = tobject + "'"
        tobject = grammar.possessive(tobject, split[og])
    else:
        poss = False

    if acc:
        if fake and poss == False and objpl == False:
            tobject = tobject + "'"
        tobject = grammar.accusative(tobject, poss)
    
    parsecount += 1

    if det == u"":
        return tobject
    else:
        return det + tobject

def et_translate(split):
    ps = parsesubject(split)
    pv = parseverb(split, ps[1], ps[2])
    po = parseobject(split, pv[1])

    out = ps[0]
    if po:
        out = out + " " + po
    if pv[0]:
        out = out + " " + pv[0]

    if out[0] == u'i':
        out = u'İ' + out[1:]
    else:
        out = out.capitalize()
    
    print(out)

def input_lower():
    out = input().replace(u'I', u'ı').lower()
    return out

split = str(input_lower()).split()
et_translate(split)