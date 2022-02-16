export const TABLE_NAME = 'student'

export const SQL_CREATE_TABLE = 'CREATE TABLE IF NOT EXISTS student(id INTEGER PRIMARY KEY AUTOINCREMENT, name TEXT NOT NULL, age INTEGER, phone TEXT NOT NULL)'

export const COLUMNS = ['id', 'name', 'age', 'phone']

export const STORE_CONFIG = { name: 'student.db', encryptKey: null }