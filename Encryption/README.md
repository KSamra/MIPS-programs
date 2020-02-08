# Encryption via Vigenère cipher

## Description

Performs simple text encryption by performing a [Caeser cipher](https://en.wikipedia.org/wiki/Vigen%C3%A8re_cipher).
The program takes two arguments, the first is the encryption *key* and the second is the *text* you wish to encrypt.

## Methods

The algorithm for encoding a single character is:

encodedText[i] = (clearText [i] + key[i%lengthKey]) % 128

and to decode a single character it’s

clearText[i] = (encodedText[i] - key[i%lengthKey]) % 128

