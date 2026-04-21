CREATE TABLE Customer (
    customer_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    first_name       VARCHAR(50) NOT NULL,
    last_name        VARCHAR(50) NOT NULL,
    street           VARCHAR(100),
    city             VARCHAR(50),
    state            CHAR(2),
    zip_code         VARCHAR(10),
    CONSTRAINT chk_customer_state
        CHECK (state IS NULL OR state ~ '^[A-Z]{2}$'),
    CONSTRAINT chk_customer_zip
        CHECK (zip_code IS NULL OR zip_code ~ '^[0-9]{5}(-[0-9]{4})?$')
);

CREATE TABLE CustomerPhone (
    customer_id      INTEGER NOT NULL,
    phone_number     VARCHAR(15) NOT NULL,
    PRIMARY KEY (customer_id, phone_number),
    CONSTRAINT fk_customerphone_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_customerphone_format
        CHECK (phone_number ~ '^[0-9]{3}-[0-9]{3}-[0-9]{4}$')
);

CREATE TABLE Account (
    account_id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    customer_id      INTEGER NOT NULL,
    CONSTRAINT fk_account_customer
        FOREIGN KEY (customer_id)
        REFERENCES Customer(customer_id)
        ON DELETE CASCADE
);

CREATE TABLE StandardService (
    service_id       INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    service_name     VARCHAR(100) NOT NULL UNIQUE,
    current_price    NUMERIC(8,2) NOT NULL,
    CONSTRAINT chk_standardservice_price
        CHECK (current_price >= 0)
);

CREATE TABLE AccountServiceSubscription (
    subscription_id      INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    subscription_date    DATE NOT NULL,
    termination_date     DATE NULL,
    service_id           INTEGER NOT NULL,
    account_id           INTEGER NOT NULL,
    CONSTRAINT fk_subscription_service
        FOREIGN KEY (service_id)
        REFERENCES StandardService(service_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_subscription_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_subscription_dates
        CHECK (termination_date IS NULL OR termination_date >= subscription_date)
);

CREATE TABLE PayPerViewEvent (
    event_id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    event_name        VARCHAR(100) NOT NULL UNIQUE,
    event_price       NUMERIC(8,2) NOT NULL,
    CONSTRAINT chk_ppv_event_price
        CHECK (event_price >= 0)
);

CREATE TABLE PayPerViewOrder (
    order_id          INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    order_date        DATE NOT NULL,
    event_id          INTEGER NOT NULL,
    account_id        INTEGER NOT NULL,
    CONSTRAINT fk_ppvorder_event
        FOREIGN KEY (event_id)
        REFERENCES PayPerViewEvent(event_id)
        ON DELETE RESTRICT,
    CONSTRAINT fk_ppvorder_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE
);

CREATE TABLE Billing (
    billing_id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    billing_date      DATE NOT NULL,
    billing_amount    NUMERIC(10,2) NOT NULL,
    due_date          DATE NOT NULL,
    account_id        INTEGER NOT NULL,
    CONSTRAINT fk_billing_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_billing_amount
        CHECK (billing_amount > 0),
    CONSTRAINT chk_billing_due_date
        CHECK (due_date >= billing_date)
);

CREATE TABLE Payment (
    payment_id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    payment_date      DATE NOT NULL,
    payment_amount    NUMERIC(10,2) NOT NULL,
    payment_method    VARCHAR(30) NOT NULL,
    account_id        INTEGER NOT NULL,
    CONSTRAINT fk_payment_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_payment_amount
        CHECK (payment_amount > 0),
    CONSTRAINT chk_payment_method
        CHECK (
            payment_method IN ('Cash', 'Check', 'Credit Card', 'Debit Card', 'Online')
        )
);

CREATE TABLE AccountComment (
    comment_id        INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    comment_text      VARCHAR(500) NOT NULL,
    comment_date      DATE NOT NULL,
    account_id        INTEGER NOT NULL,
    CONSTRAINT fk_comment_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE
);

CREATE TABLE Adjustment (
    adjustment_id     INTEGER GENERATED ALWAYS AS IDENTITY PRIMARY KEY,
    adjustment_type   VARCHAR(10) NOT NULL,
    amount            NUMERIC(8,2) NOT NULL,
    account_id        INTEGER NOT NULL,
    CONSTRAINT fk_adjustment_account
        FOREIGN KEY (account_id)
        REFERENCES Account(account_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_adjustment_type
        CHECK (adjustment_type IN ('Fee', 'Credit')),
    CONSTRAINT chk_adjustment_amount
        CHECK (amount > 0)
);

CREATE TABLE Fee (
    adjustment_id     INTEGER PRIMARY KEY,
    fee_type          VARCHAR(50) NOT NULL,
    CONSTRAINT fk_fee_adjustment
        FOREIGN KEY (adjustment_id)
        REFERENCES Adjustment(adjustment_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_fee_type
        CHECK (
            fee_type IN ('Installation', 'Hardware Rental', 'Late Fee', 'Other')
        )
);

CREATE TABLE Credit (
    adjustment_id     INTEGER PRIMARY KEY,
    credit_type       VARCHAR(50) NOT NULL,
    CONSTRAINT fk_credit_adjustment
        FOREIGN KEY (adjustment_id)
        REFERENCES Adjustment(adjustment_id)
        ON DELETE CASCADE,
    CONSTRAINT chk_credit_type
        CHECK (
            credit_type IN ('Promotion', 'Service Interruption', 'Adjustment', 'Other')
        )
);
