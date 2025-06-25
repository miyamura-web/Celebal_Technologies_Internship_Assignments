-- SubjectDetails table
Create table SubjectDetails (SubjectId varchar(20) primary key, SubjectName varchar(50), MaxSeats int, RemainingSeats int);
Insert into SubjectDetails values
('PO1491', 'Basics of Political Science', 60, 2),
('PO1492', 'Basics of Accounting', 120, 119),
('PO1493', 'Basics of Financial Markets', 90, 90),
('PO1494', 'Eco philosophy', 60, 50),
('PO1495', 'Automotive Trends', 60, 60);

-- StudentDetails table
Create table StudentDetails (StudentId varchar(20) primary key, StudentName varchar(50), GPA decimal, Branch varchar(20), Section varchar(20))
Insert into StudentDetails values
(159103036, 'Mohit Agarwal', 8.9, 'CCE', 'A'),
(159103037, 'Rohit Agarwal', 5.2, 'CCE', 'A'),
(159103038, 'Shohit Garg', 7.1, 'CCE', 'B'),
(159103039, 'Mrinal Malhotra', 7.9, 'CCE', 'A'),
(159103040, 'Mehreet Singh', 5.6, 'CCE', 'A'),
(159103041, 'Arjun Tehjan', 9.2, 'CCE', 'B');

-- StudentPreference table
Create table StudentPreference (StudentID varchar(20), SubjectID varchar(20), Preference int,
primary key(StudentID, Preference),
foreign key(StudentID) references StudentDetails(StudentID),
foreign key(SubjectID) references SubjectDetails(SubjectID));

Insert into StudentPreference values    -- Only 1 student's preferences are added here
(159103036, 'PO1491', 1),
(159103036, 'PO1492', 2),
(159103036, 'PO1493', 3),
(159103036, 'PO1494', 4),
(159103036, 'PO1495', 5);

-- Allotments table
Create table Allotments (SubjectID varchar(20), StudentID varchar(20), 
foreign key (StudentID) references StudentDetails(StudentID),
foreign key (SubjectID) references SubjectDetails(SubjectID) );

-- UnallottedStudents table
Create table UnallottedStudents (StudentID varchar(20), foreign key(StudentID) references StudentDetails(StudentID) );



--------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------

-- Creating the stored procedure
Create procedure StudentAllotment 
as 
begin

declare @StudentID varchar(20), @SubjectID varchar(20);   -- I t will store the current student and subject being processed in the cursor loops

declare StudentCursor cursor for    -- Cursor will iterates over students
select StudentId from StudentDetails order by GPA desc;    -- GPA desc cause higher GPA are given priority

open StudentCursor; fetch next from StudentCursor into @StudentID;    -- It will opens the cursor and fetches the first student into @StudentID

while @@FETCH_STATUS = 0    -- Loop continues until all students are processed
     begin
     declare @Allotted bit = 0;   -- For keeps track of whether the student was allotted a subject or not

     declare PreferenceCursor cursor for select SubjectID from StudentPreference
     where StudentID = @StudentID 
     order by Preference;    -- Same work but sorted by preference

     open PreferenceCursor; fetch next from PreferenceCursor into @SubjectID;     -- It opens the cursor and gets the first preferred subject


     while @@FETCH_STATUS = 0 and @Allotted = 0   -- It will loop through all 5 preferences until the student is allotted a subject
          begin
          declare @RemainingSeats int;
          select @RemainingSeats = RemainingSeats from SubjectDetails 
          where SubjectID = @SubjectID;   -- To looks up how many seats are left in the preferred subject

          if @RemainingSeats > 0        -- If seat are greater than 0 then will put into allotment table
               begin 
               insert into Allotments (StudentID, SubjectID) values 
               (@StudentID, @SubjectID);

                update SubjectDetails set RemainingSeats = RemainingSeats - 1     -- Also if get alloted then will also update subject details table
                where SubjectID = @SubjectID;

                set @Allotted = 1;       -- To skip further preferences
                end

         fetch next from PreferenceCursor into @SubjectID;     -- It will continues to the next preference only if not allotted
         end

         close PreferenceCursor;           -- To closes the inner loop after checking all preferences
         deallocate PreferenceCursor;

         if @Allotted = 0     --  If the student wasn’t allotted any subject, record them in UnallottedStudents
               begin 
               insert into UnallottedStudents(StudentID) values (@StudentID);
               end

               fetch next from StudentCursor into @StudentID;     -- To move on to the next student
      end

      close StudentCursor;           -- Same as above 
      deallocate StudentCursor;
end;



------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- To executing the procedure
exec StudentAllotment 


-- To check who got subjects
Select * from Allotments;             -- Will see 3 students selected as their preferences were added (below)
-- To check updated seat counts
Select * from SubjectDetails;         -- Will see remaining seats will decrase
-- To check who didn’t
Select * from UnallottedStudents;     -- Other 3 students whose preferences are not added were come under this now (cause added below)


-------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------------
-- To test if the proc is working...with demi data
-- Preferences for Rohit Agarwal
Insert into StudentPreference values
(159103037, 'PO1492', 1),
(159103037, 'PO1494', 2),
(159103037, 'PO1495', 3),
(159103037, 'PO1491', 5);

-- Preferences for Shohit Garg
Insert into StudentPreference values
(159103038, 'PO1492', 1),
(159103038, 'PO1492', 2),
(159103038, 'PO1495', 3),
(159103038, 'PO1491', 4);

---------------------------------------------------------------------------------------------------------------------------------------------------------


