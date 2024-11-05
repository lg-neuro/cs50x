-- 1. Keep a log of any SQL queries you execute as you solve the mystery.
.schema

-- 2. Check the crime description, catch other information about that day and the crime id.
SELECT *
  FROM crime_scene_reports
 WHERE day = 26
   AND month = 07
   AND year = 2023;

/*
    Theft of the CS50 duck took place at 10:15am at the Humphrey Street
    bakery. Interviews were conducted today with three witnesses who were
    present at the time – each of their interview transcripts mentions
    the bakery.
    CRIME ID = 295
*/

-- 3. Check criminal activities in the past month in the same street.
SELECT id, year, month, day, description
  FROM crime_scene_reports
 WHERE street = 'Humphrey Street'
   AND month = 07
   AND year = 2023;

/*
    Nothing special.
*/

-- 4. Check the interviews made to the wintesses.
SELECT id, name, transcript
  FROM interviews
 WHERE year = 2023
   AND month = 07
   AND day = 28;
/*
+-----+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | id  |  name   |                                                                                                                                                     transcript                                                                                                                                                      |
    +-----+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+
    | 158 | Jose    | “Ah,” said he, “I forgot that I had not seen you for some weeks. It is a little souvenir from the King of Bohemia in return for my assistance in the case of the Irene Adler papers.”                                                                                                                               |
    | 159 | Eugene  | “I suppose,” said Holmes, “that when Mr. Windibank came back from France he was very annoyed at your having gone to the ball.”                                                                                                                                                                                      |
    | 160 | Barbara | “You had my note?” he asked with a deep harsh voice and a strongly marked German accent. “I told you that I would call.” He looked from one to the other of us, as if uncertain which to address.                                                                                                                   |
    | 161 | Ruth    | Sometime within ten minutes of the theft, I saw the thief get into a car in the bakery parking lot and drive away. If you have security footage from the bakery parking lot, you might want to look for cars that left the parking lot in that time frame.                                                          |
    | 162 | Eugene  | I don't know the thief's name, but it was someone I recognized. Earlier this morning, before I arrived at Emma's bakery, I was walking by the ATM on Leggett Street and saw the thief there withdrawing some money.                                                                                                 |
    | 163 | Raymond | As the thief was leaving the bakery, they called someone who talked to them for less than a minute. In the call, I heard the thief say that they were planning to take the earliest flight out of Fiftyville tomorrow. The thief then asked the person on the other end of the phone to purchase the flight ticket. |
    | 191 | Lily    | Our neighboring courthouse has a very annoying rooster that crows loudly at 6am every day. My sons Robert and Patrick took the rooster to a city far, far away, so it may never bother us again. My sons have successfully arrived in Paris.                                                                        |
    +-----+---------+---------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------+

    The interesting interviews for our case are id = 161, 162, and 163.
*/

-- 5. Check the bakery parking lot security tapes.
SELECT *
  FROM bakery_security_logs
 WHERE year = 2023
   AND month = 07
   AND day = 28;

/*
    Fom what has been said in the inteview id 161 the potential car
    licenses plates of the car tansporting the thief are the following:
    +-----+------+-------+-----+------+--------+----------+---------------+
    | id  | year | month | day | hour | minute | activity | license_plate |
    +-----+------+-------+-----+------+--------+----------+---------------+
    | 260 | 2023 | 7     | 28  | 10   | 16     | exit     | 5P2BI95       |
    | 261 | 2023 | 7     | 28  | 10   | 18     | exit     | 94KL13X       |
    | 262 | 2023 | 7     | 28  | 10   | 18     | exit     | 6P58WS2       |
    | 263 | 2023 | 7     | 28  | 10   | 19     | exit     | 4328GD8       |
    | 264 | 2023 | 7     | 28  | 10   | 20     | exit     | G412CB7       |
    | 265 | 2023 | 7     | 28  | 10   | 21     | exit     | L93JTIZ       |
    | 266 | 2023 | 7     | 28  | 10   | 23     | exit     | 322W7JE       |
    | 267 | 2023 | 7     | 28  | 10   | 23     | exit     | 0NTHK55       |
    +-----+------+-------+-----+------+--------+----------+---------------+
    I was able to discover them using the query below, I would maintain
    the last license plate because the testimony might be wrong:
*/

SELECT *
  FROM bakery_security_logs
 WHERE year = 2023
   AND month = 07
   AND day = 28
   AND hour = 10
   AND activity = 'exit'
   AND minute BETWEEN 15 AND 25;

-- 6. Check who is the owner of these cars, we might find the theif or the person who helped him.

SELECT *
  FROM people
 WHERE license_plate IN
       (SELECT license_plate
          FROM bakery_security_logs
         WHERE year = 2023
           AND month = 07
           AND day = 28
           AND hour = 10
           AND activity = 'exit');

/*
    The following is the list of people owing the cars:
    +--------+---------+----------------+-----------------+---------------+
    |   id   |  name   |  phone_number  | passport_number | license_plate |
    +--------+---------+----------------+-----------------+---------------+
    | 221103 | Vanessa | (725) 555-4692 | 2963008352      | 5P2BI95       |
    | 243696 | Barry   | (301) 555-4174 | 7526138472      | 6P58WS2       |
    | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       |
    | 398010 | Sofia   | (130) 555-0289 | 1695452385      | G412CB7       |
    | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       |
    | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       |
    | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       |
    | 560886 | Kelsey  | (499) 555-9472 | 8294398571      | 0NTHK55       |
    | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       |
    +--------+---------+----------------+-----------------+---------------+
*/

-- 7. Check also the identity of Emma, the baker.
SELECT *
  FROM people
 WHERE name = 'Emma';

/*
    +--------+------+----------------+-----------------+---------------+
    |   id   | name |  phone_number  | passport_number | license_plate |
    +--------+------+----------------+-----------------+---------------+
    | 832111 | Emma | (329) 555-5870 | 7968707324      | 1628C65       |
    +--------+------+----------------+-----------------+---------------+
*/

-- 8. Check also the licence plate of the witnesses.

SELECT *
  FROM people
 WHERE name IN
       (SELECT name
          FROM interviews
         WHERE id = 161
            OR id = 162
            OR id = 163
           AND year = 2023
           AND month = 07
           AND day = 28);

/*
    These are the personal data from the witnesses:
    +--------+---------+----------------+-----------------+---------------+
    |   id   |  name   |  phone_number  | passport_number | license_plate |
    +--------+---------+----------------+-----------------+---------------+
    | 280744 | Eugene  | (666) 555-5774 | 9584465633      | 47592FJ       |
    | 430845 | Ruth    | (772) 555-5770 | NULL            | HZB4129       |
    | 937274 | Raymond | (125) 555-8030 | NULL            | Y18DLY3       |
    +--------+---------+----------------+-----------------+---------------+
    None of their car was found in the parking lot that day, so they could
    be perhaps the theif themselves but not the driver of the car. I checked
    it with the following code that gave no result:
*/
SELECT id
  FROM bakery_security_logs
 WHERE year = 2023
   AND month = 07
   AND day = 28
   AND hour = 10
   AND activity = 'exit'
   AND minute BETWEEN 15 AND 25
   AND license_plate IN
       (SELECT license_plate
          FROM people
         WHERE name IN
               (SELECT name
                  FROM interviews
                 WHERE id = 161
                    OR id = 162
                    OR id = 163
                   AND year = 2023
                   AND month = 07
                   AND day = 28));

-- 9. Check the money withdrawals from Leggett Street ATM on the crime day.
SELECT *
  FROM atm_transactions
 WHERE year = 2023
   AND month = 07
   AND day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw';

/*
    Here are all the withdrawals from that day:
    +-----+----------------+------+-------+-----+----------------+------------------+--------+
    | id  | account_number | year | month | day |  atm_location  | transaction_type | amount |
    +-----+----------------+------+-------+-----+----------------+------------------+--------+
    | 246 | 28500762       | 2023 | 7     | 28  | Leggett Street | withdraw         | 48     |
    | 264 | 28296815       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
    | 266 | 76054385       | 2023 | 7     | 28  | Leggett Street | withdraw         | 60     |
    | 267 | 49610011       | 2023 | 7     | 28  | Leggett Street | withdraw         | 50     |
    | 269 | 16153065       | 2023 | 7     | 28  | Leggett Street | withdraw         | 80     |
    | 288 | 25506511       | 2023 | 7     | 28  | Leggett Street | withdraw         | 20     |
    | 313 | 81061156       | 2023 | 7     | 28  | Leggett Street | withdraw         | 30     |
    | 336 | 26013199       | 2023 | 7     | 28  | Leggett Street | withdraw         | 35     |
    +-----+----------------+------+-------+-----+----------------+------------------+--------+
    Unfortunately no hour is available so I'll have to look for every
    account number present in the set.
*/

SELECT p.id, p.name, p.phone_number, p.passport_number, p.license_plate, ba.account_number
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
 WHERE year = 2023
   AND month = 07
   AND day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw';

/*
    Here are the identities of all the people withdrawing money that day:
    +--------+---------+----------------+-----------------+---------------+----------------+
    |   id   |  name   |  phone_number  | passport_number | license_plate | account_number |
    +--------+---------+----------------+-----------------+---------------+----------------+
    | 686048 | Bruce   | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
    | 514354 | Diana   | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       |
    | 458378 | Brooke  | (122) 555-4581 | 4408372428      | QX4YZN3       | 16153065       |
    | 395717 | Kenny   | (826) 555-1652 | 9878712108      | 30G67EN       | 28296815       |
    | 396669 | Iman    | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       |
    | 467400 | Luca    | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       |
    | 449774 | Taylor  | (286) 555-6063 | 1988161715      | 1106N58       | 76054385       |
    | 438727 | Benista | (338) 555-6650 | 9586786673      | 8X428L0       | 81061156       |
    +--------+---------+----------------+-----------------+---------------+----------------+
*/

-- 10. Cross-check the people exiting from the bakey that day from 10.15am to 10.25am with the people withdrawing money from the Leggett Street ATM on the morining of the same day

SELECT DISTINCT(p.id), p.name, p.phone_number, p.passport_number, p.license_plate, ba.account_number
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
 WHERE bsl.year = 2023
   AND bsl.month = 07
   AND bsl.day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw'
   AND activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25;

/*
    Here are the result from the last search:
    +--------+-------+----------------+-----------------+---------------+----------------+
    |   id   | name  |  phone_number  | passport_number | license_plate | account_number |
    +--------+-------+----------------+-----------------+---------------+----------------+
    | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
    | 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       |
    | 396669 | Iman  | (829) 555-5269 | 7049073643      | L93JTIZ       | 25506511       |
    | 467400 | Luca  | (389) 555-5198 | 8496433585      | 4328GD8       | 28500762       |
    +--------+-------+----------------+-----------------+---------------+----------------+
    These are the potential theifs, if the theif itself owns the veicle at
    the bakery, otherwise the list of the potential thiefs extends back to
    those who withdrew money the day of the crime (see name list at (9) ).
*/

-- 11. Check the phone calls in the minutes following the crime.
SELECT *
  FROM phone_calls
 WHERE year = 2023
   AND month = 07
   AND day = 28
   AND duration < 60;

/*
    Here are all the calls from the day of the crime that lasted less than
    a minute:
    +-----+----------------+----------------+------+-------+-----+----------+
    | id  |     caller     |    receiver    | year | month | day | duration |
    +-----+----------------+----------------+------+-------+-----+----------+
    | 221 | (130) 555-0289 | (996) 555-8899 | 2023 | 7     | 28  | 51       |
    | 224 | (499) 555-9472 | (892) 555-8872 | 2023 | 7     | 28  | 36       |
    | 233 | (367) 555-5533 | (375) 555-8161 | 2023 | 7     | 28  | 45       |
    | 251 | (499) 555-9472 | (717) 555-1342 | 2023 | 7     | 28  | 50       |
    | 254 | (286) 555-6063 | (676) 555-6554 | 2023 | 7     | 28  | 43       |
    | 255 | (770) 555-1861 | (725) 555-3243 | 2023 | 7     | 28  | 49       |
    | 261 | (031) 555-6622 | (910) 555-3251 | 2023 | 7     | 28  | 38       |
    | 279 | (826) 555-1652 | (066) 555-9701 | 2023 | 7     | 28  | 55       |
    | 281 | (338) 555-6650 | (704) 555-2131 | 2023 | 7     | 28  | 54       |
    +-----+----------------+----------------+------+-------+-----+----------+
    The next step would be to fine the common names out of the query (10) and
    (11), and, if there is not any to try to go back to query (9).
*/

-- 12. Triple-cross-check the query from (10) with the people from query (11).

SELECT DISTINCT(p.id), p.name, p.phone_number, p.passport_number, p.license_plate, ba.account_number
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
 WHERE bsl.year = 2023
   AND bsl.month = 07
   AND bsl.day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw'
   AND activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25
   AND pc.duration < 60;

/*
    Here are the people that, the day of the crime, left the bakery within
    10 minutes after the crime, withdrew money from the ATM in Leggett Street
    and called someone for less than a minute:
    +--------+-------+----------------+-----------------+---------------+----------------+
    |   id   | name  |  phone_number  | passport_number | license_plate | account_number |
    +--------+-------+----------------+-----------------+---------------+----------------+
    | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
    | 514354 | Diana | (770) 555-1861 | 3592750733      | 322W7JE       | 26013199       |
    +--------+-------+----------------+-----------------+---------------+----------------+
*/

-- 13. Check which is the first flight departing from whichever the airports of Fiftyville on July, 29th 2023.

  SELECT *
    FROM flights AS f
    JOIN airports AS a ON f.origin_airport_id = a.id
   WHERE f.year = 2023
     AND f.month = 07
     AND f.day = 29
ORDER BY hour, minute
   LIMIT 1;

/*
    Here is the first flight departing from Fiftyville on July, 29th 2023:
    +----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-----------------------------+------------+
    | id | origin_airport_id | destination_airport_id | year | month | day | hour | minute | id | abbreviation |          full_name          |    city    |
    +----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-----------------------------+------------+
    | 36 | 8                 | 4                      | 2023 | 7     | 29  | 8    | 20     | 8  | CSF          | Fiftyville Regional Airport | Fiftyville |
    +----+-------------------+------------------------+------+-------+-----+------+--------+----+--------------+-----------------------------+------------+
*/

-- 14. Check who is the thief and the helper by cross-checking the passengers of the flight in query (13) and the people found in query (12).

SELECT DISTINCT(p.id), p.name, p.phone_number, p.passport_number, p.license_plate, ba.account_number
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
  JOIN passengers AS pas ON p.passport_number = pas.passport_number
  JOIN flights AS f ON pas.flight_id = f.id
 WHERE bsl.year = 2023
   AND bsl.month = 07
   AND bsl.day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw'
   AND activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25
   AND pc.duration < 60
   AND f.id = 36;

/*
    Here is the only person that: 1) left the bakery parking lot with
    its car within 10 minutes after the crime was commmitted, 2) withdrew
    money from the ATM in Leggett Street the day of the crime, and 3) was
    on the first flight departing from Fiftyville the morning after the
    crime was committed:
    +--------+-------+----------------+-----------------+---------------+----------------+
    |   id   | name  |  phone_number  | passport_number | license_plate | account_number |
    +--------+-------+----------------+-----------------+---------------+----------------+
    | 686048 | Bruce | (367) 555-5533 | 5773159633      | 94KL13X       | 49610011       |
    +--------+-------+----------------+-----------------+---------------+----------------+
*/

-- 15. Check if the person that Bruce called the morning of the crime is flying with him.

SELECT DISTINCT(p.id), p.name, p.phone_number, p.passport_number, p.license_plate
  FROM people AS p
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
  JOIN passengers AS pas ON p.passport_number = pas.passport_number
  JOIN flights AS f ON pas.flight_id = f.id
 WHERE pc.year = 2023
   AND pc.month = 07
   AND pc.day = 28
   AND pc.duration < 60
   AND p.phone_number = '(375) 555-8161'
   AND f.id = 36;
/*
    No the person is not flying with him.
*/

-- 16. Check who is the person that helped him.

SELECT *
  FROM people
 WHERE phone_number = '(375) 555-8161';

/*
    +--------+-------+----------------+-----------------+---------------+
    |   id   | name  |  phone_number  | passport_number | license_plate |
    +--------+-------+----------------+-----------------+---------------+
    | 864400 | Robin | (375) 555-8161 | NULL            | 4V16VO0       |
    +--------+-------+----------------+-----------------+---------------+
*/

-- 17. Check where the flight was destined to:

SELECT city, full_name
  FROM airports AS a
  JOIN flights AS f ON a.id = f.destination_airport_id
 WHERE f.id = 36;

 /*
    The flight was destined to:
    +---------------+-------------------+
    |     city      |     full_name     |
    +---------------+-------------------+
    | New York City | LaGuardia Airport |
    +---------------+-------------------+
 */

-- 18. Query with all the answers: who is the thief ('name'), where did he go ('full_name', 'city') and the cell number of the guy helping him ('receiver').

SELECT DISTINCT p.name,
                a.full_name,
                a.city ,
                pc.receiver
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
  JOIN passengers AS pas ON p.passport_number = pas.passport_number
  JOIN flights AS f ON pas.flight_id = f.id
  JOIN airports AS a ON f.destination_airport_id = a.id
 WHERE bsl.year = 2023
   AND bsl.month = 07
   AND bsl.day = 28
   AND atm_location = 'Leggett Street'
   AND transaction_type = 'withdraw'
   AND activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25
   AND pc.year = 2023
   AND pc.month = 07
   AND pc.day = 28
   AND pc.duration < 60
   AND f.id =
       (SELECT id
          FROM flights AS f
         WHERE f.year = 2023
           AND f.month = 07
           AND f.day = 29
      ORDER BY f.hour
         LIMIT 1);

/*
    Here are the final answers: the thief is called Bruce, his flight landed in LaGuardia Airport, New York City and the phone number of his helper is (375) 555-8161 (Robin).
    +-------+-------------------+---------------+----------------+
    | name  |     full_name     |     city      |    receiver    |
    +-------+-------------------+---------------+----------------+
    | Bruce | LaGuardia Airport | New York City | (375) 555-8161 |
    +-------+-------------------+---------------+----------------+
*/


-- This one by ChatGPT works as well, but maybe is better.
SELECT DISTINCT p.name AS thief_name,
                a.full_name AS destination_airport,
                a.city AS destination_city,
                pc.receiver AS accomplice_phone_number
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
  JOIN passengers AS pas ON p.passport_number = pas.passport_number
  JOIN flights AS f ON pas.flight_id = f.id
  JOIN airports AS a ON f.destination_airport_id = a.id
 WHERE bsl.year = 2023
   AND bsl.month = 7
   AND bsl.day = 28
   AND atmt.atm_location = 'Leggett Street'
   AND atmt.transaction_type = 'withdraw'
   AND bsl.activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25
   AND pc.duration < 60
   AND f.id =
       (SELECT id
          FROM flights AS f
         WHERE f.year = 2023
           AND f.month = 07
           AND f.day = 29
      ORDER BY hour
         LIMIT 1)
   AND pc.receiver IN
       (SELECT DISTINCT pc2.receiver
          FROM phone_calls AS pc2
         WHERE pc2.year = 2023
           AND pc2.month = 7
           AND pc2.day = 28
           AND pc2.caller = p.phone_number
           AND pc2.duration < 60);

-- Since I did not know how to print the name of the thief and his accomplice in one single query I asked ChatGPT how to do that.

SELECT DISTINCT p.name AS thief_name,
                a.full_name AS destination_airport,
                a.city AS destination_city,
                accomplice.name AS accomplice_name
  FROM people AS p
  JOIN bank_accounts AS ba ON p.id = ba.person_id
  JOIN atm_transactions AS atmt ON ba.account_number = atmt.account_number
  JOIN bakery_security_logs AS bsl ON p.license_plate = bsl.license_plate
  JOIN phone_calls AS pc ON p.phone_number = pc.caller
  JOIN people AS accomplice ON pc.receiver = accomplice.phone_number  -- Join again to find the accomplice's name
  JOIN passengers AS pas ON p.passport_number = pas.passport_number
  JOIN flights AS f ON pas.flight_id = f.id
  JOIN airports AS a ON f.destination_airport_id = a.id
 WHERE bsl.year = 2023
   AND bsl.month = 7
   AND bsl.day = 28
   AND atmt.atm_location = 'Leggett Street'
   AND atmt.transaction_type = 'withdraw'
   AND bsl.activity = 'exit'
   AND bsl.hour = 10
   AND bsl.minute BETWEEN 15 AND 25
   AND pc.duration < 60
   AND pc.month = 07
   AND pc.day = 28
   AND f.id =
       (SELECT id
          FROM flights AS f
         WHERE f.year = 2023
           AND f.month = 07
           AND f.day = 29
      ORDER BY f.hour
         LIMIT 1);
/*
    Here is the complete answer:
    +------------+---------------------+------------------+-----------------+
    | thief_name | destination_airport | destination_city | accomplice_name |
    +------------+---------------------+------------------+-----------------+
    | Bruce      | LaGuardia Airport   | New York City    | Robin           |
    +------------+---------------------+------------------+-----------------+
*/
