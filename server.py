#!/usr/bin/env python2.7

import subprocess
from flask import Flask
from flask import request
from flask import render_template
app = Flask(__name__, static_url_path='/')

@app.route("/")
def root():
    return render_template('index.html')

@app.route("/post", methods=['POST'])
def result():
    name   = request.form['name']
    job    = request.form['job']
    email  = request.form['email']
    phone1 = request.form['phone1']
    phone2 = request.form['phone2']

    file = open("./in/" + job + " - " + name + ".txt","w") 

    file.write(email) 
    file.write("\n") 
    file.write(phone1) 
    file.write("\n") 
    file.write(phone2) 
    file.write("\n") 

    file.close() 

    subprocess.call("./build.sh")

    f = open("out/" + job + " - " + name + ".htm", "r") 

    return f.read()


if __name__ == "__main__":
    app.run(host='0.0.0.0', port=4567, debug=True)
