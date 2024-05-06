from faker import Faker
from sqlite3 import connect
from random import randint

from connect import create_connection, database

def seed_users(conn,count):
    fake=Faker()
    cursor=conn.cursor()
    for _ in range(count):
        fullname=fake.name()
        email=fake.email()
        cursor.execute("INSERT INTO users (fullname, email) VALUES (?, ?)", (fullname, email))
    conn.commit()

def seed_status(conn,count):
    fake=Faker()
    cursor=conn.cursor()
    for _ in range(count):
        name=fake.name()
        cursor.execute("INSERT INTO status (name) VALUES (?)", (name))
    conn.commit()

def seed_tasks(conn, count, num_users, num_status):
    fake = Faker()
    cursor = conn.cursor()
    for _ in range(count):
        title = fake.sentence()
        description = fake.text()
        status_id = randint(1, num_status)
        user_id = randint(1, num_users)
        cursor.execute("INSERT INTO tasks (title, description, status_id, user_id) VALUES (?, ?, ?, ?)", (title, description, status_id, user_id))
    conn.commit()

if __name__ == '__main__':
    num_users = 3
    num_status = 3
    num_tasks = 3

    with create_connection(database) as conn:
        if conn is not None:
            seed_users(conn, num_users)
            print("Таблиця users успішно заповнена.")
            
            seed_status(conn, num_status)
            print("Таблиця status успішно заповнена.")
            
            seed_tasks(conn, num_tasks, num_users, num_status)
            print("Таблиця tasks успішно заповнена.")
        else:
            print("Помилка! Неможливо встановити з'єднання з базою даних.")