#!/usr/local/bin/python

import psycopg2
from time import sleep

while True:
    try:
        connection = psycopg2.connect(
            database='digitalmarketplace',
            user='dmdev',
            password='dmdevpasswd',
            host='postgres',
            port=5432
        )
        break
    except:
        print('DB connection failed, retrying')
        sleep(1)

while True:
    try:
        cur = connection.cursor()
        cur.execute("SELECT * FROM frameworks")
        number_of_frameworks = cur.rowcount
        if number_of_frameworks:
            print("{} frameworks found, continuing".format(number_of_frameworks))
            break
        else:
            print('No frameworks found, retrying')
            sleep(1)
    except psycopg2.OperationalError as e:
        print('Psycopg2 operational error')
        print(e.message)
        print('Retrying in 1 second')
        sleep(1)

connection.close()
