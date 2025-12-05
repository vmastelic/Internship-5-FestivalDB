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
    tsrange(StartTime, EndTime) WITH &&
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

CREATE TABLE Mentors(
	MentorId SERIAL PRIMARY KEY,
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthYear INT NOT NULL CHECK (BirthYear >= 1925),
	ExpertiseArea VARCHAR(30) NOT NULL,
	YearExperience INT NOT NULL CHECK (YearExperience >= 2),
	CHECK(EXTRACT(YEAR FROM CURRENT_DATE) - BirthYear >= 18)
);

CREATE TABLE Workshops(
	WorkshopId SERIAL PRIMARY KEY,
	MentorId INT NOT NULL REFERENCES Mentors(MentorId),
	FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
	Name VARCHAR(30) NOT NULL,
	Level VARCHAR(20) NOT NULL CHECK(Level IN ('beginner', 'intermediate', 'advanced')),
	MaxParticipants INT NOT NULL CHECK (MaxParticipants > 0),
	DurationHours INT NOT NULL CHECK (DurationHours > 0),
	RequiresKnowledge BOOLEAN DEFAULT FALSE
);

CREATE TABLE WorkshopRegistrations(
	RegistrationId SERIAL PRIMARY KEY,
	VisitorId INT NOT NULL REFERENCES Visitors(VisitorId),
	WorkshopId INT NOT NULL REFERENCES Workshops(WorkshopId),
	RegistrationStatus VARCHAR(20) NOT NULL CHECK(RegistrationStatus IN ('registered', 'canceled', 'attended')),
	RegistrationTime TIMESTAMP NOT NULL DEFAULT CURRENT_TIMESTAMP,
	UNIQUE (VisitorId, WorkshopId)
);

CREATE TABLE Staff(
	StaffId SERIAL PRIMARY KEY,
	FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
	FirstName VARCHAR(30) NOT NULL,
	LastName VARCHAR(30) NOT NULL,
	BirthDate DATE NOT NULL,
	Role VARCHAR(50) NOT NULL CHECK (Role IN ('organizer','technician','security','volunteer')),
	Concact VARCHAR(100),
	HasSecurityTraining BOOLEAN DEFAULT FALSE,
	CHECK(Role <> 'security' OR EXTRACT (YEAR FROM AGE(BirthDate)) >= 21)
);

CREATE TABLE MembershipCards(
	MembershipCardId SERIAL PRIMARY KEY,
	VisitorId INT NOT NULL UNIQUE REFERENCES Visitors(VisitorId),
	ActivationDate DATE NOT NULL DEFAULT CURRENT_DATE,
	Status VARCHAR(20) NOT NULL CHECK(Status IN('active', 'expired', 'pending'))
);






