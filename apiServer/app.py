#!/usr/bin/env python3
# -*- coding: utf-8 -*-
"""
Created on Mon Mar 25 21:17:40 2024

@author: kyletrocki
"""

from flask import Flask, jsonify, request

app = Flask(__name__)


todos = [
    {"id": 1, "task": "Finish assignment", "completed": False},
    {"id": 2, "task": "Go grocery shopping", "completed": True},
    {"id": 3, "task": "Call mom", "completed": False}
]
next_todo_id = 4  # Counter for generating unique IDs

@app.route('/api/todos', methods=['GET'])
def get_todos():
    return jsonify(todos)

@app.route('/api/todos', methods=['POST'])
def add_todo():
    global next_todo_id
    new_todo = request.json
    new_todo['id'] = next_todo_id
    next_todo_id += 1
    todos.append(new_todo)
    print(new_todo)
    return jsonify(new_todo), 201

@app.route('/api/todos/<int:todo_id>', methods=['PUT'])
def update_todo(todo_id):
    for todo in todos:
        if todo['id'] == todo_id:
            todo.update(request.json)
            return jsonify(todo)
    return jsonify({"error": "Todo not found"}), 404

@app.route('/api/todos/<int:todo_id>', methods=['DELETE'])
def delete_todo(todo_id):
    global todos
    todos = [todo for todo in todos if todo['id'] != todo_id]
    return jsonify({"message": "Todo deleted successfully"})

if __name__ == "__main__":
    app.run()