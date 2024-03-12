from flask import Flask, request
import sqlite3

app = Flask(__name__)

# Database setup
conn = sqlite3.connect('database.db')
c = conn.cursor()
c.execute('''CREATE TABLE IF NOT EXISTS users
                 (email TEXT, address TEXT, notes TEXT)''')
conn.commit()

@app.route('/submit', methods=['POST'])
def submit():
    email = request.form['email']
    address = request.form['address']
    notes = request.form['notes']

    # Save data to the database
    c.execute("INSERT INTO users (email, address, notes) VALUES (?, ?, ?)", (email, address, notes))
    conn.commit()

    return "Form data saved successfully"

if __name__ == '__main__':
    app.run(debug=True)
