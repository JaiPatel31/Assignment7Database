-- Hotel master
CREATE TABLE Hotel (
    hotelNo     INT PRIMARY KEY,
    hotelName   VARCHAR(100) NOT NULL,
    city        VARCHAR(100) NOT NULL
);

-- Guest master
CREATE TABLE Guest (
    guestNo         INT PRIMARY KEY,
    guestName       VARCHAR(100) NOT NULL,
    guestAddress    VARCHAR(255)
);

-- Rooms in each hotel
CREATE TABLE Room (
    roomNo      INT NOT NULL,
    hotelNo     INT NOT NULL,
    type        VARCHAR(30) NOT NULL,
    price       DECIMAL(10,2) NOT NULL,
    PRIMARY KEY (roomNo, hotelNo),
    CONSTRAINT fk_room_hotel
        FOREIGN KEY (hotelNo) REFERENCES Hotel(hotelNo)
);

-- Bookings
CREATE TABLE Booking (
    hotelNo     INT NOT NULL,
    guestNo     INT NOT NULL,
    dateFrom    DATE NOT NULL,
    dateTo      DATE,
    roomNo      INT NOT NULL,
    PRIMARY KEY (hotelNo, guestNo, dateFrom),
    CONSTRAINT fk_booking_guest
        FOREIGN KEY (guestNo) REFERENCES Guest(guestNo),
    CONSTRAINT fk_booking_room
        FOREIGN KEY (roomNo, hotelNo) REFERENCES Room(roomNo, hotelNo),
    CONSTRAINT chk_booking_dates
        CHECK (dateTo IS NULL OR dateTo >= dateFrom)
);
