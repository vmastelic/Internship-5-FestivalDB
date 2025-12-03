CREATE TABLE Festivals(
	FestivalId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	City VARCHAR(30) NOT NULL,
	Capacity INT CHECK (Capacity > 0),
	StartDate DATE NOT NULL,
	EndDate DATE NOT NULL CHECK(StartDate <= EndDate),
	Status VARCHAR(20) NOT NULL CHECK(Status IN('planned', 'active', 'finished')),
	HasCamp BOOLEAN DEFAULT FALSE
);

CREATE TABLE Stages (
    StageId SERIAL PRIMARY KEY,
    FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
    Name VARCHAR(30) NOT NULL,
    Location VARCHAR(20) NOT NULL CHECK (Location IN ('main', 'forest', 'beach')),
    MaxCapacity INT CHECK (MaxCapacity > 0),
    Covered BOOLEAN DEFAULT FALSE,
    UNIQUE (FestivalId, Name)
);

CREATE TABLE Artists(
	ArtistId SERIAL PRIMARY KEY,
	Name VARCHAR(30) NOT NULL,
	Country VARCHAR(30) NOT NULL,
	Genre VARCHAR(30) NOT NULL,
	MembersCount INT CHECK(MembersCount > 0),
	IsActive BOOLEAN DEFAULT TRUE
);

CREATE TABLE Performances(
	PerformanceId SERIAL PRIMARY KEY,
	FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
	StageId INT NOT NULL REFERENCES Stages(StageId),
	ArtistId INT NOT NULL REFERENCES Artists(ArtistId),
 	StartTime TIMESTAMP NOT NULL,
	EndTime TIMESTAMP NOT NULL CHECK(StartTime < EndTime),
	ExpectedVisitors INT CHECK(ExpectedVisitors > 0)
);

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE Performances
ADD CONSTRAINT no_overlapping_performance
EXCLUDE USING gist (
    StageId WITH =,
    tstzrange(StartTime, EndTime) WITH &&
);

CREATE TABLE Visitors(
	VisitorId SERIAL PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	City VARCHAR (30) NOT NULL,
	Email VARCHAR(50) NOT NULL UNIQUE CHECK (Email LIKE '%@%'),
	Country VARCHAR(50) NOT NULL
);

CREATE TABLE Tickets(
	TicketId SERIAL PRIMARY KEY,
	Type VARCHAR(20) NOT NULL CHECK(Type IN ('oneDay', 'festival', 'VIP', 'camp')),
	Price NUMERIC(10, 2) NOT NULL CHECK (Price > 0),
	Description TEXT,
	Validity VARCHAR(20) NOT NULL CHECK(Validity IN ('day', 'festival'))
);

CREATE TABLE Orders(
	OrderId SERIAL PRIMARY KEY,
	VisitorId INT NOT NULL REFERENCES Visitors(VisitorId),
	FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
	OrderDateTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	TotalPrice NUMERIC(10,2) NOT NULL CHECK (TotalPrice >= 0)
);

CREATE TABLE OrderItems(
	OrderItemId SERIAL PRIMARY KEY,
	OrderId INT NOT NULL REFERENCES Orders(OrderId),
	TicketId INT NOT NULL REFERENCES Tickets(TicketId),
	Quantity INT NOT NULL CHECK (Quantity > 0)
);




