from flask import Flask, request, jsonify
import pandas as pd
import joblib

# Initialize Flask app
app = Flask(__name__)

# Load the pre-trained model, label encoder, and model columns from disk
model = joblib.load('C:\\Users\\tulli\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\model.joblib')
label_encoder = joblib.load('C:\\Users\\tulli\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\label_encoder.joblib')
model_columns = joblib.load('C:\\Users\\tulli\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\model_columns.joblib')


@app.route('/predict', methods=['POST'])
def predict():
    """
    Endpoint to predict the job title based on the user input.
    Expects a JSON payload with user input data.
    """

    # Receive JSON data from user input
    user_input = request.json

    # Convert user input into a DataFrame
    user_input_df = pd.DataFrame([user_input])

    # Create an empty DataFrame with the same columns as the training data
    input_df_template = pd.DataFrame(columns=model_columns)  # Ensure to have the correct list of columns here

    # Fill the template with user input
    for col in input_df_template.columns:
        if col in user_input_df.columns:
            input_df_template[col] = user_input_df[col]
        else:
            input_df_template[col] = 0

    # Ensure the user input has the same shape as the training DataFrame
    input_df_template = input_df_template.reindex(columns=model_columns).fillna(0)

    # Use the model to make a prediction
    predicted_job_code = model.predict(input_df_template)

    # Decode the predicted job title
    decoded_job_title = label_encoder.inverse_transform(predicted_job_code)

    # Return the decoded job title
    return jsonify({'predicted_job_title': decoded_job_title[0]})


# Run the Flask app
if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
