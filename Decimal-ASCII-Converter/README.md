# Decimal <--> ASCII Converter

## Approach Used

1. Converting from ASCII to Decimal involved using a while loop and an if-else statement. It went as follows…

  * Check if negative or NULL char
  * Take first digit and multiply by 10
  * Add to permanent register which keeps the total
  * Take the next number and add it to total
  * Multiply total by 10
  * continue until null character is reached
  * At the end, divide total by 10 to get the right value
  * If a negative value was found, use the NEG pseudo op to negate the total

2. Converting from Decimal to Binary went as follows…

  * Use the bitmask 32768 (1000000000000000) and the SRL command to look bit by bit

  * Use bitwise AND to get a value of either 0, or any value greater than 0.

  * If the value received was 0, print 0. For everything else, print 1

  * Continue until there are no more bits to look at.
