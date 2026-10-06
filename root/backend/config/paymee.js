// Paymee payment adapter (Tunisia).
// The adapter remains disabled until the Paymee credentials are configured.

const isConfigured = () => Boolean(
  process.env.PAYMEE_API_KEY && process.env.PAYMEE_BASE_URL
);

const createPayment = async ({
  amount,
  currency = 'TND',
  orderId,
  customer = {},
  returnUrl,
}) => {
  if (!isConfigured()) {
    throw new Error('Paymee is not configured');
  }

  const paymentId = `paymee_${orderId}_${Date.now()}`;
  const baseUrl = process.env.PAYMEE_BASE_URL.replace(/\/$/, '');
  const redirectUrl = `${baseUrl}/pay?amount=${encodeURIComponent(
    Number(amount).toFixed(3)
  )}&currency=${encodeURIComponent(currency)}&payment_id=${encodeURIComponent(
    paymentId
  )}&order_id=${encodeURIComponent(orderId)}&email=${encodeURIComponent(
    customer.email || ''
  )}&return_url=${encodeURIComponent(returnUrl || '')}`;

  return { success: true, paymentId, redirectUrl };
};

const verifyPayment = async (paymentId) => {
  if (!isConfigured()) {
    throw new Error('Paymee is not configured');
  }

  return { success: true, paymentId };
};

module.exports = {
  isConfigured,
  createPayment,
  verifyPayment,
};
