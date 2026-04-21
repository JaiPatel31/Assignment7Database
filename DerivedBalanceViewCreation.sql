CREATE VIEW v_account_current_balance AS
SELECT
    a.account_id,
    a.customer_id,
    COALESCE(b.total_billing, 0.00)
    - COALESCE(p.total_payment, 0.00)
    + COALESCE(f.total_fee, 0.00)
    - COALESCE(c.total_credit, 0.00) AS current_balance
FROM Account a
LEFT JOIN (
    SELECT account_id, SUM(billing_amount) AS total_billing
    FROM Billing
    GROUP BY account_id
) b ON a.account_id = b.account_id
LEFT JOIN (
    SELECT account_id, SUM(payment_amount) AS total_payment
    FROM Payment
    GROUP BY account_id
) p ON a.account_id = p.account_id
LEFT JOIN (
    SELECT ad.account_id, SUM(ad.amount) AS total_fee
    FROM Adjustment ad
    JOIN Fee f ON ad.adjustment_id = f.adjustment_id
    GROUP BY ad.account_id
) f ON a.account_id = f.account_id
LEFT JOIN (
    SELECT ad.account_id, SUM(ad.amount) AS total_credit
    FROM Adjustment ad
    JOIN Credit c ON ad.adjustment_id = c.adjustment_id
    GROUP BY ad.account_id
) c ON a.account_id = c.account_id;