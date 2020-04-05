DROP TABLE G2_GroupMember_T CASCADE CONSTRAINTS;

DROP TABLE G2_MemberInterestTopic_T CASCADE CONSTRAINTS;

DROP TABLE G2_GroupInterestTopic_T CASCADE CONSTRAINTS;

DROP TABLE G2_Eventparticipation_T CASCADE CONSTRAINTS;

DROP TABLE G2_Event_T CASCADE CONSTRAINTS;

DROP TABLE G2_InterestTopic_T CASCADE CONSTRAINTS;

DROP TABLE G2_Group_T CASCADE CONSTRAINTS;

DROP TABLE G2_Member_T CASCADE CONSTRAINTS;

DROP TABLE G2_Venue_T CASCADE CONSTRAINTS;

DROP TABLE G2_City_T CASCADE CONSTRAINTS;

DROP TABLE G2_Category_T CASCADE CONSTRAINTS;

/* 
category_t is the entity that captures the various categories 
that groups can be created. For example, Sports could be a category etc.
*/

CREATE TABLE G2_Category_T (
    CategoryID     NUMBER(11, 0) NOT NULL,
    CategoryName   VARCHAR2(400) NOT NULL,
    ShortName      VARCHAR2(30) NOT NULL,
    CONSTRAINT Category_PK PRIMARY KEY ( CategoryID )
);

/* 
city_t is the entity that captures the various cities in which 
the onsite site operates
*/

CREATE TABLE G2_City_T (
    CityID        NUMBER(11, 0) NOT NULL,
    CityName      VARCHAR2(100) NOT NULL,
    CountryCode   CHAR(2) NOT NULL,
    Country       VARCHAR2(100) NOT NULL,
    Latitude      DECIMAL(6, 2),
    Longitude     DECIMAL(6, 2),
    State         CHAR(2) NOT NULL,
    Zipcode       VARCHAR2(10) NOT NULL,
    CONSTRAINT City_PK PRIMARY KEY ( CityID )
);

/*
venue_t is the entity that captures the venues in a particular city
where group events can be conducted
*/

CREATE TABLE G2_Venue_T (
    VenueID          NUMBER(11, 0) NOT NULL,
    VenueName        VARCHAR2(100) NOT NULL,
    Phone            VARCHAR2(20),
    StreetAddress1   VARCHAR2(100) NOT NULL,
    StreetAddress2   VARCHAR2(100) NOT NULL,
    CityID           NUMBER(11, 0) NOT NULL,
    CONSTRAINT Venue_PK PRIMARY KEY ( VenueID ),
    CONSTRAINT Venue_FK1 FOREIGN KEY ( CityID ) REFERENCES G2_City_T ( CityID )
);

/*
member_t is the entity that captures the members registered in this site
*/

CREATE TABLE G2_Member_T (
    MemberID         NUMBER(11, 0) NOT NULL,
    CityID           NUMBER(11, 0) NOT NULL,
    MemberName       VARCHAR2(200) NOT NULL,
    MemberStatus     VARCHAR2(10) NOT NULL,
    LastVisited      TIMESTAMP NOT NULL,
    MembershipDate   DATE NOT NULL,
    ProfileLink      VARCHAR2(200) NOT NULL,
    CONSTRAINT Member_PK PRIMARY KEY ( MemberID ),
    CONSTRAINT Member_FK1 FOREIGN KEY ( CityID ) REFERENCES G2_City_T ( CityID )
);

/*
group_t is the entity that captures the groups that are created by members in a particular city and category
*/

CREATE TABLE G2_Group_T (
    GroupID             NUMBER(11, 0) NOT NULL,
    CategoryID          NUMBER(11, 0) NOT NULL,
    CityID              NUMBER(11, 0) NOT NULL,
    GroupName           VARCHAR2(200) NOT NULL,
    CreatedDate         TIMESTAMP NOT NULL,
    Description         VARCHAR2(1000) NOT NULL,
    OrganizerMemberID   NUMBER(11, 0) NOT NULL,
    Rating              NUMBER(2, 0) NOT NULL,
    URLName             VARCHAR2(200) NOT NULL,
    Visibility          VARCHAR2(20) NOT NULL,
    CONSTRAINT Group_PK PRIMARY KEY ( GroupID ),
    CONSTRAINT Group_FK1 FOREIGN KEY ( OrganizerMemberID ) REFERENCES G2_Member_T ( MemberID ),
    CONSTRAINT Group_FK2 FOREIGN KEY ( CityID ) REFERENCES G2_City_T ( CityID ),
    CONSTRAINT Group_FK3 FOREIGN KEY ( CategoryID ) REFERENCES G2_Category_T ( categoryID )
);

/*
interesttopic_t is the entity that captures all the possible interest topics that groups and members can have. 
For example. Photography could be an interest topic and could contain sub interest topics like landscape photography, 
Night photography, Potrait photography etc.
*/

CREATE TABLE G2_InterestTopic_T (
    InterestTopicID       NUMBER(11, 0) NOT NULL,
    Description           VARCHAR2(1000) NOT NULL,
    Link                  VARCHAR2(200) NOT NULL,
    InterestTopicName     VARCHAR2(200) NOT NULL,
    URLKey                VARCHAR2(20) NOT NULL,
    MainInterestTopicID   NUMBER(11, 0) NOT NULL,
    CONSTRAINT InterestTopic_PK PRIMARY KEY ( InterestTopicID ),
    CONSTRAINT MainInterestTopic_FK1 FOREIGN KEY ( MainInterestTopicID ) REFERENCES G2_InterestTopic_T ( InterestTopicID )
);

/*
event_t is the entity that captures all the events organized by groups in a particular venue in a city
*/

CREATE TABLE G2_Event_T (
    EventID         NUMBER(11, 0) NOT NULL,
    GroupID         NUMBER(11, 0) NOT NULL,
    VenueID         NUMBER(11, 0) NOT NULL,
    CreatedDate     TIMESTAMP NOT NULL,
    Description     VARCHAR2(1000) NOT NULL,
    Duration        NUMBER(10, 0) NOT NULL,
    RSVPLimit       NUMBER(10, 0) NOT NULL,
    WaitlistCount   NUMBER(10, 0) NOT NULL,
    Headcount       NUMBER(10, 0) NOT NULL,
    CONSTRAINT Event_PK PRIMARY KEY ( EventID ),
    CONSTRAINT Event_FK1 FOREIGN KEY ( GroupID ) REFERENCES G2_Group_T ( GroupID ),
    CONSTRAINT Event_FK2 FOREIGN KEY ( VenueID ) REFERENCES G2_Venue_T ( VenueID )
);

/*
eventparticipation_t is the associative entity that captures the members who participated in an event
*/

CREATE TABLE G2_EventParticipation_T (
    EventID        NUMBER(11, 0) NOT NULL,
    MemberID       NUMBER(11, 0) NOT NULL,
    IsWaitlisted   CHAR(1),
    IsRegistered   CHAR(1),
    CONSTRAINT EventParticipation_PK PRIMARY KEY ( EventID, memberID ),
    CONSTRAINT EventParticipation_FK1 FOREIGN KEY ( MemberID ) REFERENCES G2_Member_T ( MemberID ),
    CONSTRAINT EventParticipation_FK2 FOREIGN KEY ( EventID ) REFERENCES G2_Event_T ( EventID )
);

/*
groupinteresttopic_t is the associative entity that captures the interest topics that the group is interested in
*/

CREATE TABLE G2_GroupInterestTopic_T (
    GroupID           NUMBER(11, 0) NOT NULL,
    InterestTopicID   NUMBER(11, 0) NOT NULL,
    CONSTRAINT GroupInterestTopic_PK PRIMARY KEY ( GroupID, InterestTopicID ),
    CONSTRAINT GroupInterestTopic_FK1 FOREIGN KEY ( GroupID ) REFERENCES G2_Group_T ( GroupID ),
    CONSTRAINT GroupInterestTopic_FK2 FOREIGN KEY ( InterestTopicID ) REFERENCES G2_InterestTopic_T ( InterestTopicID )
);

/*
memberinteresttopic_t is the associative entity that captures the interest topics that the member is interested in
*/

CREATE TABLE G2_MemberInterestTopic_T (
    MemberID          NUMBER(11, 0) NOT NULL,
    InterestTopicID   NUMBER(11, 0) NOT NULL,
    CONSTRAINT MemberInterestTopic_PK PRIMARY KEY ( MemberID, InteresttopicID ),
    CONSTRAINT MemberInterestTopic_FK1 FOREIGN KEY ( MemberID ) REFERENCES G2_Member_T ( MemberID ),
    CONSTRAINT MemberInterestTopic_FK2 FOREIGN KEY ( InterestTopicID ) REFERENCES G2_InterestTopic_T ( InterestTopicID )
);

/*
groupmember_t is the associative entity that groups in which the member belong to
*/

CREATE TABLE G2_GroupMember_T (
    MemberID   NUMBER(11, 0) NOT NULL,
    GroupID    NUMBER(11, 0) NOT NULL,
    CONSTRAINT GroupMember_PK PRIMARY KEY ( MemberID, GroupID ),
    CONSTRAINT GroupMember_FK1 FOREIGN KEY ( MemberID ) REFERENCES G2_Member_T ( MemberID ),
    CONSTRAINT GroupMember_FK2 FOREIGN KEY ( GroupID ) REFERENCES G2_Group_T ( GroupID )
);