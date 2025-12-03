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

CREATE TABLE Stages(
	StageId SERIAL PRIMARY KEY,
	FestivalId INT NOT NULL REFERENCES Festivals(FestivalId),
	Location VARCHAR(20) NOT NULL CHECK(Location IN('main', 'forest', 'beach')),
	MaxCapacity INT CHECK(MaxCapacity > 0),
	Covered BOOLEAN DEFAULT FALSE
);
