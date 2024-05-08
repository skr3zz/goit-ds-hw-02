import sqlite3
from contextlib import contextmanager

database = './test.db'

@contextmanager
def create_connection(db_file):
    conn = None
    try:
        conn = sqlite3.connect(db_file)
        yield conn
    finally:
        if conn:
            conn.close()

def create_tables(conn):
    sql_create_users_table = """
    CREATE TABLE IF NOT EXISTS users (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        fullname VARCHAR(100),
        email VARCHAR(100) UNIQUE
    );
    """

    sql_create_status_table = """
    CREATE TABLE IF NOT EXISTS status (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        name VARCHAR(50) UNIQUE
    );
    """

    sql_create_tasks_table = """
    CREATE TABLE IF NOT EXISTS tasks (
        id INTEGER PRIMARY KEY AUTOINCREMENT,
        title VARCHAR(100),
        description TEXT,
        status_id INTEGER,
        user_id INTEGER,
        FOREIGN KEY (status_id) REFERENCES status(id),
        FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
    );
    """

    try:
        cursor = conn.cursor()
        cursor.execute(sql_create_users_table)
        cursor.execute(sql_create_status_table)
        cursor.execute(sql_create_tasks_table)
        conn.commit()
    except Error as e:
        print(e)

def main():
    with create_connection(database) as conn:
        if conn is not None:
            create_tables(conn)
            print("Tables created successfully.")
        else:
            print("Error! cannot create the database connection.")

if __name__ == '__main__':
    main()
