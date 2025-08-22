import os
from flask import Flask, jsonify, request
import stripe
from dotenv import load_dotenv

load_dotenv()
app = Flask(__name__)

# Asegúrate de que la clave secreta de Stripe esté en tu archivo .env
stripe.api_key = os.getenv('STRIPE_SECRET_KEY')

@app.route('/create-payment-intent', methods=['POST'])
def create_payment():
    try:
        data = request.get_json()
        # Stripe maneja los montos en la unidad más pequeña de la moneda (centavos),
        # por lo que el monto se multiplica por 100 y se convierte a entero.
        amount = int(data.get('amount') * 100)
        
        # Crea un PaymentIntent con Stripe
        intent = stripe.PaymentIntent.create(
            amount=amount,
            currency='usd', # O la moneda que desees, por ejemplo, 'mxn', 'eur'
            automatic_payment_methods={
                'enabled': True,
            },
        )
        return jsonify({
            'clientSecret': intent.client_secret,
        })
    except Exception as e:
        return jsonify(error=str(e)), 403

if __name__ == '__main__':
    # La aplicación se ejecutará en el puerto 4242
    # El debug=True recarga el servidor automáticamente al guardar cambios
    app.run(port=4242, debug=True)