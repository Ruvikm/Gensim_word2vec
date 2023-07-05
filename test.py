import codecs

f = codecs.open('wiki.zh.text', 'r', encoding="utf8")
line = f.readline()
print(line)
