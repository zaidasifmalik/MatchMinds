from flask import Flask, request, jsonify
import joblib  # Assuming you have joblib installed

app = Flask(__name__)
model = joblib.load('psl_predictor.pkl')  # Load your serialized XGBoost model

@app.route('/predict', methods=['POST'])
def predict():
    if request.method == 'POST':
        data = request.get_json()  # Get data sent from the Flutter app
        wickets = data['wickets']
        balls_left = data['balls_left']
        runs_left = data['runs_left']

        # Preprocess data if necessary (e.g., scaling, one-hot encoding)
        features = [wickets, balls_left, runs_left]

        prediction = model.predict(runs_left)[0]  # Make prediction using the model
        winner = "Team 1 Wins" if prediction > 0.5 else "Team 2 Wins"  # Interpret prediction

        return jsonify({'winner': winner})  # Return prediction as JSON
    else:
        return jsonify({'error': 'Invalid request method'}), 400

if __name__ == '__main__':
    app.run(debug=True)
