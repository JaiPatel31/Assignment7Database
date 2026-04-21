-- Insert Hotels (includes Kansas City, Olathe, Lenexa)
INSERT INTO Hotel (hotelNo, hotelName, city) VALUES
(1, 'KC Grand Hotel', 'Kansas City'),
(2, 'Olathe Inn', 'Olathe'),
(3, 'Lenexa Suites', 'Lenexa'),
(4, 'Plaza Stay', 'Kansas City'),
(5, 'Sunflower Lodge', 'Topeka');

-- Insert Guests
INSERT INTO Guest (guestNo, guestName, guestAddress) VALUES
(101, 'Ava Thompson', '123 Main St, Kansas City, MO'),
(102, 'Liam Carter', '890 Oak Ave, Olathe, KS'),
(103, 'Noah Reed', '45 Pine Dr, Lenexa, KS'),
(104, 'Emma Brooks', '77 River Rd, Overland Park, KS'),
(105, 'Mia Foster', '12 Hill St, Topeka, KS');

-- Insert Rooms
INSERT INTO Room (roomNo, hotelNo, type, price) VALUES
(101, 1, 'Single', 129.99),
(102, 1, 'Double', 159.99),
(201, 2, 'Single', 119.99),
(301, 3, 'Suite', 199.99),
(401, 4, 'Double', 149.99);

-- Insert Bookings
INSERT INTO Booking (hotelNo, guestNo, dateFrom, dateTo, roomNo) VALUES
(1, 101, '2026-05-01', '2026-05-04', 101),
(2, 102, '2026-05-03', '2026-05-05', 201),
(3, 103, '2026-05-10', '2026-05-12', 301),
(1, 104, '2026-06-01', '2026-06-03', 102),
(4, 105, '2026-05-20', '2026-05-22', 401);
