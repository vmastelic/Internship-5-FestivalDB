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

CREATE TABLE Stage (
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
	EndTime TIMESTAMP NOT NULL CHECK(StartTime > EndTime),
	ExpectedVisitors INT CHECK(ExpextedVisitors > 0)
);

CREATE EXTENSION IF NOT EXISTS btree_gist;

ALTER TABLE Performances
ADD CONSTRAINT no_overlapping_performance
EXCLUDE USING gist (
    StageId WITH =,
    tstzrange(StartTime, EndTime) WITH &&
);





