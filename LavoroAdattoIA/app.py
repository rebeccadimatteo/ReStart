from flask import Flask, request, jsonify
import pandas as pd
import joblib

app = Flask(__name__)

model = joblib.load('C:\\Users\\Gianfranco\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\model.joblib')

label_encoder = joblib.load('C:\\Users\\Gianfranco\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\label_encoder.joblib')

model_columns = joblib.load('C:\\Users\\Gianfranco\\IdeaProjects\\ReStart\\LavoroAdattoIA\\Model\\model_columns.joblib')


@app.route('/predict', methods=['POST'])
def predict():
    # Riceve i dati JSON dall'input dell'utente
    user_input = request.json

    # Converte l'input dell'utente in un DataFrame
    user_input_df = pd.DataFrame([user_input])

    # Crea un DataFrame vuoto con le stesse colonne di X_train
    input_df_template = pd.DataFrame(columns=model_columns)  # Assicurati di avere l'elenco delle colonne corrette qui

    # Inserimento dell'input dell'utente nel template
    for col in input_df_template.columns:
        if col in user_input_df.columns:
            input_df_template[col] = user_input_df[col]
        else:
            input_df_template[col] = 0

    # Assicurarsi che l'input dell'utente abbia la stessa forma del DataFrame di allenamento
    input_df_template = input_df_template.reindex(columns=model_columns).fillna(0)

    # Utilizza il modello per fare una predizione
    predicted_job_code = model.predict(input_df_template)
    decoded_job_title = label_encoder.inverse_transform(predicted_job_code)

    # Restituisce il titolo di lavoro decodificato
    return jsonify({'predicted_job_title': decoded_job_title[0]})


if __name__ == '__main__':
    app.run(debug=True, host='0.0.0.0', port=5000)
