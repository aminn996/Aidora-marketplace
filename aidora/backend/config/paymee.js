// Paymee Tunisia adapter (redirect-based)
// Uses native fetch (Node >=18). Configure sandbox or live via env.
// Env required:
// PAYMEE_MERCHANT
// PAYMEE_API_KEY
// PAYMEE_BASE_URL (optional, defaults to sandbox https://sandbox.paymee.tn/api)

const BASE_URL = process.env.PAYMEE_BASE_URL || 'https://sandbox.paymee.tn/api';

const isConfigured = () => {
  return !!(process.env.PAYMEE_MERCHANT && process.env.PAYMEE_API_KEY);
};

const headers = () => ({
  'Content-Type': 'application/json',
  Accept: 'application/json',
  Authorization: `Token ${process.env.PAYMEE_API_KEY}`,
});

/**
 * Create a Paymee payment session (hosted page)
 * @param {Object} params
 * @param {number} params.amount - amount in TND
 * @param {string} params.currency - 'TND'
 * @param {string} params.orderId - internal reference
 * @param {string} params.returnUrl - where Paymee redirects after payment
 * @param {string} params.note - description
 */
const createPayment = async ({ amount, currency = 'TND', orderId, returnUrl, note }) => {
  if (!isConfigured()) {
    return { success: false, error: 'Paymee is not configured' };
  }

  try {
    const payload = {
      amount,
      currency,
      vendor_id: process.env.PAYMEE_MERCHANT,
      note: note || 'Payment',
      order_id: orderId,
      webhook_url: returnUrl, // Paymee uses the same as return if webhook not set separately
      return_url: returnUrl,
    };

    const res = await fetch(`${BASE_URL}/v2/payments/create`, {
      method: 'POST',
      headers: headers(),
      body: JSON.stringify(payload),
    });

    const data = await res.json();
    if (!res.ok || !data?.data?.payment_url) {
      return { success: false, error: data?.message || 'Failed to create Paymee session' };
    }

    return {
      success: true,
      redirectUrl: data.data.payment_url,
      paymentId: data.data.payment_id,
    };
  } catch (err) {
    console.error('Paymee createPayment error:', err);
    return { success: false, error: 'Paymee request failed' };
  }
};

/**
 * Verify Paymee payment status
 * @param {string} paymentId
 */
const verifyPayment = async (paymentId) => {
  if (!isConfigured()) {
    return { success: false, error: 'Paymee is not configured' };
  }

  try {
    const res = await fetch(`${BASE_URL}/v2/payments/${paymentId}/check`, {
      method: 'GET',
      headers: headers(),
    });
    const data = await res.json();
    if (!res.ok || !data?.data) {
      return { success: false, error: data?.message || 'Verification failed' };
    }

    const paid = data.data.status === 'paid';
    return {
      success: paid,
      status: data.data.status,
      amount: data.data.amount,
      currency: data.data.currency,
      card: data.data.card || null,
    };
  } catch (err) {
    console.error('Paymee verifyPayment error:', err);
    return { success: false, error: 'Paymee verification failed' };
  }
};

module.exports = {
  isConfigured,
  createPayment,
  verifyPayment,
};
