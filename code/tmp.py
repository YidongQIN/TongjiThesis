# this is a Morse Code Translator
"""
Function Planned:
1. encoding string into morse code,
2. decoding morse code into string,
3. replace . OR - with different singals.
"""
# Dictionary of encoding and decoding
encodedict={
	'A':'.-',
	'B':'-...',
	'C':'-.-.',
	'D':'-..',
	'E':'.',
	'F':'..-.',
	'G':'--.',
	'H':'....',
	'I':'..',
	'J':'.---',
	'K':'-.-',
	'L':'.-..',
	'M':'--',
	'N':'-.',
	'O':'---',
	'P':'.--.',
	'Q':'--.-',
	'R':'.-.',
	'S':'...',
	'T':'-',
	'U':'..-',
	'V':'...-',
	'W':'.--',
	'X':'-..-',
	'Y':'-.--',
	'Z':'--..',
	'0':'-----',
	'1':'.----',
	'2':'..---',
	'3':'...--',
	'4':'....-',
	'5':'.....',
	'6':'-....',
	'7':'--...',
	'8':'---..',
	'9':'----.',
	' ':' '
}
decodedict={
	'.-':'A',
	'-...':'B',
	'-.-.':'C',
	'-..':'D',
	'.':'E',
	'..-.':'F',
	'--.':'G',
	'....':'H',
	'..':'I',
	'.---':'J',
	'-.-':'K',
	'.-..':'L',
	'--':'M',
	'-.':'N',
	'---':'O',
	'.--.':'P',
	'--.-':'Q',
	'.-.':'R',
	'...':'S',
	'-':'T',
	'..-':'U',
	'...-':'V',
	'.--':'W',
	'-..-':'X',
	'-.--':'Y',
	'--..':'Z',
	'-----':'0',
	'.----':'1',
	'..---':'2',
	'...--':'3',
	'....-':'4',
	'.....':'5',
	'-....':'6',
	'--...':'7',
	'---..':'8',
	'----.':'9',
	'':' ',
	' ':' ',
}
# Context includes alpha 'A' to 'Z' adn number 0 to 9
# Code includes '.' for DIT, and '-' for DAH

### encoding function to translate normal text to morse code
def encoding(etext):
	encode = ''
	for i in etext:
		encode = encode + encodedict[i.upper()] + '/'
	return encode
###decoding function to translate morse code to mormal text
def decoding(dtext):
	decode = ''
	dtext = dtext.split('/')
	for i in dtext:
		decode = decode + decodedict[i]
	return decode

print('Please choose which function would you need:')
print('1. Encoding -- from normal text to morse code')
print('2. Decoding -- from morse code to normal text')
print('Please type in 1 OR 2 and press Enter')
fc=input()
if fc=='1':
	print('Please in put your text')
	msg1=input()
	print(encoding(msg1))
elif fc=='2':
	print('Please in put your code')
	print('NOTICE: Use only "." and "-" and "/" in code')
	msg2 = input()
	print(decoding(msg2))
else:
	print('Please check your input')
print('Translation work done')

