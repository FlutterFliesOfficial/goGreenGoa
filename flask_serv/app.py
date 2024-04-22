# import pickle
# import sklearn
import pickle
from flask import Flask, render_template, request, jsonify,  redirect, flash, url_for
# import pandas as pd
# from pyngrok import ngrok
import pandas as pd
from pandas.tseries.offsets import DateOffset
import statsmodels.api as sm


import firebase_admin
# import firestore
from firebase_admin import credentials, firestore

messages = [{'reader_id': '1',
             'UID': 'AAABACAD'},
            {'reader_id': '1',
             'UID': '0A5FE7B3'}
            ]

cred = credentials.Certificate("C:/Users/Anuya/manthan/flutterProjects/LOGITHON/airhouse_psk.json")
default_app = firebase_admin.initialize_app(cred)
db = firestore.client()
some_ref = db.collection('env1')
pred_db = db.collection('pred1')
some_ref_o = db.collection('env2')
rfid_ref = db.collection('rfid')

app = Flask(__name__)

app.secret_key = 'your_secret_key'  # Required for flashing messages

# Load the SARIMAX model from the pickle file
with open(r"C:\Users\Anuya\manthan\flutterProjects\LOGITHON\models\sarimax_model.pkl", 'rb') as file:
    sarimax_model = pickle.load(file)

model1 = pickle.load(open('.\models\model1 (1).pkl', 'rb'))
model1 = model1.fit()

model2 = pickle.load(open('.\models\model2 (1).pkl', 'rb'))
model2 = model2.fit()

model3 = pickle.load(open('.\models\model3.pkl', 'rb'))
model3 = model3.fit()

model4 = pickle.load(open('.\models\model4.pkl', 'rb'))
model4 = model4.fit()


# Define a function to update the model with new data
def update_model(model, new_data):
    # Convert existing endogenous data to a pandas Series
    existing_data = pd.Series(model.endog.flatten(), index=model.data.row_labels)
    
    # Concatenate existing data with new data
    updated_data = pd.concat([existing_data, new_data])
    
    # Train a new model with the updated data
    updated_model = sm.tsa.statespace.SARIMAX(
        updated_data,
        order=model.order,
        seasonal_order=model.seasonal_order,
        enforce_stationarity=False,
        enforce_invertibility=False
    ).fit()
    return updated_model


df = pd.read_csv(r"C:\Users\Anuya\Downloads\perrin-freres-monthly-champagne-.csv")



# Define new data (example)
new_data = pd.Series([150], index=pd.date_range(start='2024-05-01', periods=1, freq='M'))
print(new_data)
# Update the model with new data
updated_model = update_model(sarimax_model, new_data)



@app.route('/spredict', methods=['POST'])
def spredict():
    forecast = updated_model.forecast(steps=1)  # Example: forecast next 3 months
     # Return the prediction as a JSON object
    try:
        id = request.json['id']
        request.json['prediction'] = forecast.tolist()
        pred_db.document(id).set(request.json)
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occurred: {e}"

@app.route('/predict', methods=['GET'])
def predict():
    if model1 is None:
        return jsonify({'error': 'Model not found'}), 500

    # json_ = request.json
    # if json_ is None:
    #     return jsonify({'error': 'Invalid JSON data received'}), 400

    # query = pd.DataFrame([json_])
    # query = query.drop(columns=['id'])
    # query = 
    prediction1 = model1.predict(start=100, end=109, dynamic=True)
    prediction2 = model2.predict(start=100, end=109, dynamic=True)
    prediction3 = model3.predict(start=100, end=109, dynamic=True)
    prediction4 = model4.predict(start=100, end=109, dynamic=True)
    
    # Return the prediction as a JSON object
    try:
        id = request.json['id']
        request.json['prediction'] = prediction1.tolist()
        request.json['prediction2'] = prediction2.tolist()
        request.json['prediction3'] = prediction3.tolist()
        request.json['prediction4'] = prediction4.tolist()
        pred_db.document(id).set(request.json)
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occurred: {e}"
    # return jsonify({'prediction': prediction.tolist()})

@app.route('/')
def home():
    return 'Hello World'

@app.route('/add', methods=['POST'])
def create():
    try:
        id = request.json['id']
        some_ref.document(id).set(request.json)
        return jsonify({"success": True}), 200
    except Exception as e:
        return f"An Error Occurred: {e}"

@app.route('/helloesp')
def helloHandler():
    return 'Hello ESP8266, from Flask'

@app.route('/list', methods=['GET'])
def read():
    """
        read() : Fetches documents from Firestore collection as JSON
        todo : Return document that matches query ID
        all_todos : Return all documents
    """
    try:
        # Check if ID was passed to URL query
        todo_id = request.args.get('id')    
        if todo_id:
            todo = some_ref.document(todo_id).get()
            return jsonify(todo.to_dict()), 200
        else:
            all_todos = [doc.to_dict() for doc in some_ref.stream()]
            return jsonify(all_todos), 200
    except Exception as e:
        return f"An Error Occured: {e}"



@app.route('/message', methods=['GET', 'POST'])
def msg():
    if request.method == 'POST':
        title = request.json['device']
        content = request.json['uid']
        # Check if the new UID is already present in messages
        if not any(msg['UID'] == content for msg in messages):
            # Append the new UID to messages
            messages.append({'reader_id': title, 'UID': content})
            try:
        # Check if ID was passed to URL query
                todo_id = request.json['uid']  
                if todo_id:
                    todo = rfid_ref.document(todo_id).set(request.json)
                    return jsonify(todo_id), 200
                else:
                    all_todos = [doc.to_dict() for doc in rfid_ref.stream()]
                    return jsonify(all_todos), 300
            except Exception as e:
                return f"An Error Occured: {e}"
       
        return f"success: True"  # for esp debuging
    else:
        # return render_template('message.html', messages=messages)
        return render_template('index.html', messages=messages)
# configure post req to show up the id and reader no of each care thus we can 
# show the data of available rifs cards on the web page


@app.route('/form', methods=['GET', 'POST'])
def form():
    if request.method == 'POST':
        first_name = request.form['first_name']
        last_name = request.form['last_name']
        email = request.form['email']
        password = request.form['pwd']
        stor = request.form['loc']
        qty = request.form['qty']
        print(password)
    
        packed_data = {"Product": first_name, "Category": last_name, "Dimention": email, "RFID_UID": password, "location": stor, "quantity": qty, "Timestamp": pd.Timestamp.now()}

        
        try:
            id = '69'
            some_ref_o.add(packed_data)
            flash('Data added successfully!', 'success')  # Flash success message
            return redirect('/form')  # Redirect to GET request to show form again
        except Exception as e:
            flash(f'An error occurred: {e}', 'error')  # Flash error message
            return redirect('/form')  # Redirect to GET request to show form again
    
    return render_template('manysite.html')


if __name__ == '__main__':
    app.run(debug=True,host='0.0.0.0', port= 8090)