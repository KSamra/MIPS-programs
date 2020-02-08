# Prime Finder

Written November 12th, 2017

## Description
Given a positive number X, return all prime numbers leading up to (and possibly including) X.

# Algorithm

To accomplish this I used the [Sieve of Eratosthenes algorithm](https://en.wikipedia.org/wiki/Sieve_of_Eratosthenes).

I dynamically allocate an array of size *n*, where *n* is the user’s input. I then multiplied this value  *n* by 4 to get each element of the array to be 1 word in length. Another approach would be to have each element in the array be 1 byte in size

The sieve works as it should. I select a value p which is prime and then start at p^2, moving in increments of p and replacing each value with a 0. When p^2 > n, I stop. The remaining values that != 0 are all prime and are printed out.
