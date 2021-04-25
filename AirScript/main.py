from flask import Flask
from flask import  send_file
from handwriting import Hand
from cairosvg import svg2png
from flask_cors import CORS


import  pyrebase

config =  {
    "apiKey": "AIzaSyAEHfpon6bfL_IPuxjt9zO6bYutf9EJzIM",
    "authDomain": "airscript-87512.firebaseapp.com",
    "projectId": "airscript-87512",
    "databaseURL":"airscript-87512.firebaseio.com",
    "storageBucket": "airscript-87512.appspot.com",
    "messagingSenderId": "614123896410",
    "appId": "1:614123896410:web:795a7f94bd9ade9598e263",
    "measurementId": "G-QG0KX09G7F"
  }

firebase = pyrebase.initialize_app(config)
db = firebase.database()
storage = firebase.storage()


def splitStr(string,arr):
    if(len(string)==0):
        return arr
    else:
        if(len(string)>75):
            arr.append(string[:74]+"-")
        else:
            arr.append(string[:75])
        return splitStr(string[74:],arr)

app = Flask(__name__)
CORS(app)

@app.route("/")
def index():
    return "<h2>AirScript-DEV-API</h2>"

@app.route('/<lines>/<biases>/<styles>',methods=['POST'])
def handwrite(lines,biases,styles):
    hand = Hand()
    line = []
    splitStr(lines,line)
    bias = [biases for i in line]
    style = [styles for i in line]
    try:
        hand.write(
            filename='img/server.svg',
            lines=line,
            biases=bias,
            styles=style,
        )
        svg2png(url="img/server.svg",write_to="img/server1.png")
        storage.child("images/server.png").put("img/server1.png")
        return "<h2>Success</h2>"
    except:
        return "<h2>Fail</h2>"

@app.route('/get_last_image_svg')
def getLastSvg():
   return send_file('img/server.svg', mimetype='image/svg')

@app.route("/png")
def png():
    return send_file('img/server1.png', mimetype='image/png')

@app.route("/get_last_image_png")
def getLastPng():
    # return "<img src='https://127.0.0.1:5000/png'></img>"
    url = storage.child("images/server.png").get_url(token=None)
    return url



app.run(debug=True,)


