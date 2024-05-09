-- Table: users
DROP TABLE IF EXISTS users;
CREATE TABLE users (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    fullname VARCHAR(100),
    email VARCHAR(100) UNIQUE NOT NULL
);

-- Table: status
DROP TABLE IF EXISTS status;
CREATE TABLE status (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    name VARCHAR(50) UNIQUE NOT NULL
);

-- Table: tasks
DROP TABLE IF EXISTS tasks;
CREATE TABLE tasks (
    id INTEGER PRIMARY KEY AUTOINCREMENT,
    title VARCHAR(100),
    description TEXT,
    status_id INTEGER,
    user_id INTEGER,
    FOREIGN KEY (status_id) REFERENCES status(id),
    FOREIGN KEY (user_id) REFERENCES users(id) ON DELETE CASCADE
);

conn = sqlite3.connect('task.db')
cur = conn.cursor()

def get_user_tasks(conn, user_id):
    """Отримати всі завдання певного користувача за його user_id"""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tasks WHERE user_id = ?", (user_id,))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_tasks_by_status(conn, status):
    """Вибрати завдання за певним статусом"""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tasks WHERE status_id = (SELECT id FROM status WHERE name = ?)", (status,))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def update_task_status(conn, status):
    """Оновити статус конкретного завдання."""
    try:
        cursor = conn.cursor()
        cursor.execute("UPDATE tasks SET status_id = (SELECT id FROM status WHERE name = ?) WHERE id = ?", (new_status, task_id))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_users_without_tasks(conn, status):
    """Отримати список користувачів, які не мають жодного завдання. """
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE id NOT IN (SELECT DISTINCT user_id FROM tasks)")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def add_task(conn, status):
    """Додати нове завдання для конкретного користувача."""
    try:
        cursor = conn.cursor()
        cursor.execute("INSERT INTO tasks (title, description, status_id, user_id) VALUES (?, ?, ?, ?)", (title, description, status_id, user_id))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_incomplete_tasks(conn):
    """Отримати всі завдання, які ще не завершено."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tasks WHERE status_id != (SELECT id FROM status WHERE name = 'completed')")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def delete_task(conn, task_id):
    """Видалити конкретне завдання."""
    try:
        cursor = conn.cursor()
        cursor.execute("DELETE FROM tasks WHERE id = ?", (task_id,))
        conn.commit()
    except sqlite3.Error as e:
        print(e)

def find_users_by_email(conn, email):
    """Знайти користувачів з певною електронною поштою."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM users WHERE email LIKE ?", (email,))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)


def update_user_name(conn, user_id, new_name):
     """Оновити ім'я користувача."""
    try:
        cursor = conn.cursor()
        cursor.execute("UPDATE users SET fullname = ? WHERE id = ?", (new_name, user_id))
        conn.commit()
    except sqlite3.Error as e:
        print(e)

def get_task_count_by_status(conn):
    """Отримати кількість завдань для кожного статусу."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT status.name, COUNT(tasks.id) FROM status LEFT JOIN tasks ON status.id = tasks.status_id GROUP BY status.name")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_tasks_by_email_domain(conn, domain):
    """Отримати завдання, які призначені користувачам з певною доменною частиною електронної пошти."""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT tasks.* FROM tasks INNER JOIN users ON tasks.user_id = users.id WHERE users.email LIKE ?", (f'%@{domain}',))
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_tasks_without_description(conn):
    """Отримати список завдань, що не мають опису. """
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT * FROM tasks WHERE description IS NULL OR description = ''")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_users_and_tasks_in_progress(conn):
     """Вибрати користувачів та їхні завдання, які є в статусі 'in progress'"""
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT users.*, tasks.* FROM users INNER JOIN tasks ON users.id = tasks.user_id WHERE tasks.status_id = (SELECT id FROM status WHERE name = 'in progress')")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)

def get_user_task_count(conn):
    """Отримати користувачів та кількість їхніх завдань.""" 
    try:
        cursor = conn.cursor()
        cursor.execute("SELECT users.fullname, COUNT(tasks.id) FROM users LEFT JOIN tasks ON users.id = tasks.user_id GROUP BY users.fullname")
        return cursor.fetchall()
    except sqlite3.Error as e:
        print(e)


conn = connect_to_database('task.db')

user_tasks = get_user_tasks(conn, user_id)
tasks_by_status = get_tasks_by_status(conn, 'new')
update_task_status(conn, task_id, 'in progress')
users_without_tasks = get_users_without_tasks(conn)
add_task(conn, title, description, status_id, user_id)
incomplete_tasks = get_incomplete_tasks(conn)
delete_task(conn, task_id)
users_with_email = find_users_by_email(conn, email)
update_user_name(conn, user_id, new_name)
task_count_by_status = get_task_count_by_status(conn)
tasks_by_email_domain = get_tasks_by_email_domain(conn, domain)
tasks_without_description = get_tasks_without_description(conn)
users_and_tasks_in_progress = get_users_and_tasks_in_progress(conn)
user_task_count = get_user_task_count(conn)

conn.close()